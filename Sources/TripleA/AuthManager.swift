//
//  AuthManager.swift
//  Template
//
//  Created by Fernando Salom on 21/12/21.
//  Copyright © 2021 Rudo. All rights reserved.
//

import Foundation
import UIKit

public final actor AuthManager {
    private var storage: StorageProtocol
    public var remoteDataSource: RemoteDataSourceProtocol
    private var parameters: [String: Any] = [:]
    private var refreshTask: Task<String, Error>?

    public init(storage: StorageProtocol, remoteDataSource: RemoteDataSourceProtocol, parameters: [String: Any] = [:]) {
        self.storage = storage
        self.parameters = parameters
        self.remoteDataSource = remoteDataSource
    }

    // MARK: - validToken - check if token is valid or refresh token otherwise
    func getCurrentToken() async throws -> String {
        if let accessToken = storage.read(this: .accessToken) {
            if accessToken.isValid {
                return accessToken.value
            } else if let refreshToken = storage.read(this: .refreshToken), refreshToken.isValid {
                return try await getRefreshToken()
            }
        }
        remoteDataSource.showLogin()
        throw AuthError.missingToken
    }
    
    // MARK: - refreshToken - create a task and call refreshToken if needed
    /**
    Refresh token when is needed or logout
    - Returns: new refresh_token  `String`
    - Throws: An error of type `AuthError`
    */
    func getRefreshToken() async throws -> String {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }
        let task = Task { () throws -> String in
            defer { refreshTask = nil }
            guard let refreshToken = storage.read(this: .refreshToken)?.value else {
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

    // MARK: - authorize request
    /**
    go to  login
    */
    public func authorizeRequest(_ request: URLRequest) async throws -> URLRequest {
        do {
            let token = try await getCurrentToken()
            var resultRequest = request
            resultRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return resultRequest
        } catch {
            throw AuthError.missingToken
        }
    }
}
