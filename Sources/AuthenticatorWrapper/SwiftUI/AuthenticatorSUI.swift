import Foundation

public enum Screen {
    case login
    case home
}

public final class AuthenticatorSUI: ObservableObject {
    @Published public var screen: Screen = .login {
        didSet {
            print("🛡️ Authenticator: launched \(screen)")
        }
    }

    private var authenticator: AuthenticatorProtocol

    public init(authenticator: AuthenticatorProtocol) {
        self.authenticator = authenticator
        checkState()
    }

    public func checkState() {
        Task {
            await self.changeScreen(to: isLogged() ? .home : .login)
        }
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

extension AuthenticatorSUI: AuthenticatorProtocol {
    public func isLogged() async -> Bool {
        return await authenticator.isLogged()
    }
    
    public func get(token type: TokenType) async throws -> Token? {
        return try await authenticator.get(token: type)
    }

    public func set(token: Token, for type: TokenType) async throws {
        try await authenticator.set(token: token, for: type)
    }

    // MARK: - validToken - check if token is valid or refresh token otherwise
    /**
     Return a valid token or try to get it from storage or remote data source

     - Returns: valid access token
     - Throws: An error of type `CustomError`  with extra info and show login screen
    */
    public func getCurrentToken() async -> String {
        do {
            return try await authenticator.getCurrentToken()
        } catch {
            handle(error)
            return ""
        }
    }

    // MARK: - validToken - check if token is valid or refresh token otherwise
    /**
    Call to login if needed and get token

     - Throws: An error of type `CustomError`  with extra info
    */
    public func getNewToken(with parameters: [String : Any] = [:]) async throws {
        do {
            try await authenticator.getNewToken(with: parameters)
            self.changeScreen(to: .home)
        } catch let error {
            handle(error)
        }
    }

    // MARK: - logout
    /**
     Remove data and go to start view controller
     */
    public func logout() async throws {
        try await authenticator.logout()
        await changeScreen(to: .login)
    }
}