import Foundation
import UIKit
import Combine

public final actor AuthManager {
    private var storage: StorageProtocol
    private var remoteDataSource: RemoteDataSourceProtocol
    private var parameters: [String: Any] = [:]
    private var refreshTask: Task<String, Error>?
    
    public var isLogged: Bool {
        if let accessToken = storage.accessToken {
            return accessToken.isValid
        }else{
            return false
        }
    }

    public init(storage: StorageProtocol, remoteDataSource: RemoteDataSourceProtocol, parameters: [String: Any] = [:]) {
        self.storage = storage
        self.parameters = parameters
        self.remoteDataSource = remoteDataSource
    }

    // MARK: - validToken - check if token is valid or refresh token otherwise
    /**
     Return a valid token or try to get it from storage or remote data source

     - Returns: valid access token
     - Throws: An error of type `CustomError`  with extra info and show login screen
    */
    public func getCurrentToken() async throws -> String {
        if let accessToken = storage.accessToken {
            if accessToken.isValid {
                return accessToken.value
            } else if let refreshToken = storage.refreshToken, refreshToken.isValid {
                do {
                    return try await renewToken()
                } catch {
                    showLogin()
                }
            }
        }
        showLogin()
        throw AuthError.missingToken
    }

    // MARK: - showLogin
    /**
     Shows login when authentication flow fails

    */
    private func showLogin() {
        DispatchQueue.main.async {
            Task{
                await self.storage.removeAll()
                await self.remoteDataSource.showLogin()
            }
        }
    }

    // MARK: - validToken - check if token is valid or refresh token otherwise
    /**
    Call to login if needed and get token

     - Throws: An error of type `CustomError`  with extra info
    */
    public func getNewToken(with parameters: [String: Any] = [:]) async throws {
        do {
            _ = try await remoteDataSource.getAccessToken(with: parameters)
        } catch let error {
            throw error
        }
    }
    
    // MARK: - refreshToken - create a task and call refreshToken if needed
    /**
     Refresh token when is needed or logout
     - Returns: new refresh_token  `String`
     - Throws: An error of type `AuthError`
     */
    func renewToken() async throws -> String {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }
        let task = Task { () throws -> String in
            defer { refreshTask = nil }
            guard let refreshToken = storage.refreshToken?.value else {
                throw AuthError.tokenNotFound
            }
            do {
                return try await remoteDataSource.getRefreshToken(with: refreshToken)
            } catch {
                throw AuthError.badRequest
            }
        }
        self.refreshTask = task
        return try await task.value
    }

    // MARK: - logout
    /**
     Remove data and go to start view controller
     */
    public func logout() async {
        await remoteDataSource.logout()
    }
}
