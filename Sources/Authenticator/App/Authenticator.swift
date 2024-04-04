import Foundation

@available(macOS 10.15, *)
public final actor Authenticator {
    private var storage: TokenStorageProtocol
    private var card: AuthenticationCardProtocol
    private var parameters: [String: Any] = [:]
    private var refreshTask: Task<String, Error>?
    
    public var isLogged: Bool {
        if let accessToken = storage.accessToken {
            return accessToken.isValid
        }else{
            return false
        }
    }

    public init(storage: TokenStorageProtocol,
                card: AuthenticationCardProtocol,
                parameters: [String: Any] = [:]) {
        self.storage = storage
        self.parameters = parameters
        self.card = card
    }
}

extension Authenticator: AuthenticatorProtocol {
    // MARK: - refreshToken - create a task and call refreshToken if needed
    /**
     Refresh token when is needed or logout
     - Returns: new refresh_token  `String`
     - Throws: An error of type `AuthError`
     */
    public func renewToken() async throws -> String {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }
        let task = Task { () throws -> String in
            defer { refreshTask = nil }
            guard let refreshToken = storage.refreshToken?.value else {
                throw AuthError.tokenNotFound
            }
            do {
                return try await card.getRefreshToken(with: refreshToken)
            } catch {
                await self.logout()
                throw AuthError.refreshFailed
            }
        }
        self.refreshTask = task
        return try await task.value
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
                    self.storage.removeAll()
                    try await getNewToken()
                }
            }
        }
        self.storage.removeAll()
        try await getNewToken()
        throw AuthError.missingToken
    }
    
    // MARK: - validToken - check if token is valid or refresh token otherwise
    /**
    Call to login if needed and get token

     - Throws: An error of type `CustomError`  with extra info
    */
    public func getNewToken(with parameters: [String: Any] = [:]) async throws {
        do {
            _ = try await card.getAccessToken(with: parameters)
        } catch let error {
            throw error
        }
    }

    // MARK: - logout
    /**
     Remove data and go to start view controller
     */
    public func logout() async {
        await card.logout()
    }
}
