import Foundation

public enum Screen {
    case login
    case home
}

public final class AuthenticatorSUI: ObservableObject {
    @Published public var screen: Screen {
        didSet {
            print("SCREEN: \(screen)")
        }
    }

    public var storage: TokenStorageProtocol
    private var card: AuthenticationCardProtocol
    private var refreshTask: Task<String, Error>?

    public var isLogged: Bool {
        if let refreshToken = storage.refreshToken {
            return refreshToken.isValid
        } else {
            return false
        }
    }

    public func checkState() {
        self.changeScreen(to: isLogged ? .home : .login)
    }

    public init(storage: TokenStorageProtocol,
                card: AuthenticationCardProtocol) {
        self.storage = storage
        self.card = card
        self.screen = storage.refreshToken?.isValid ?? false ? .home : .login
    }

}

extension AuthenticatorSUI: AuthenticatorProtocol {
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
                    self.handle(error)
                    throw AuthError.missingToken
                }
            }
        }
        self.storage.removeAll()
        throw AuthError.missingToken
    }

    // MARK: - validToken - check if token is valid or refresh token otherwise
    /**
    Call to login if needed and get token

     - Throws: An error of type `CustomError`  with extra info
    */
    public func getNewToken(with parameters: [String : Any] = [:]) async throws {
        do {
            let tokens = try await card.getTokensWithLogin(with: parameters)
            self.storage.accessToken = tokens.accessToken
            self.storage.refreshToken = tokens.refreshToken
            self.changeScreen(to: .home)
        } catch let error {
            handle(error)
        }
    }

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
                let tokens = try await card.getNewTokens(with: refreshToken)
                self.storage.accessToken = tokens.accessToken
                self.storage.refreshToken = tokens.refreshToken
                return tokens.accessToken.value
            } catch {
                try await self.logout()
                throw AuthError.refreshFailed
            }
        }
        self.refreshTask = task
        return try await task.value
    }

    // MARK: - logout
    /**
     Remove data and go to start view controller
     */
    public func logout() async throws {
        try await card.logout()
        self.storage.removeAll()
        changeScreen(to: .login)
    }

    private func handle(_ error: Error) {
        changeScreen(to: .login)
    }

    private func changeScreen(to screen: Screen) {
        DispatchQueue.main.async {
            self.screen = screen
        }
    }
}
