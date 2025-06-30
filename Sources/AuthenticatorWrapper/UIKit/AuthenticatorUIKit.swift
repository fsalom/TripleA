import Foundation
#if os(iOS) || os(tvOS)
import UIKit

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS 10.15, *)
public final class AuthenticatorUIKit {
    private var authenticator: AuthenticatorProtocol
    private var entryViewController: UIViewController?

    public init(authenticator: AuthenticatorProtocol,
                entryViewController: UIViewController? = nil) {
        self.authenticator = authenticator
        self.entryViewController = entryViewController
    }

    private func showLogin() {
        if let entryViewController {
            DispatchQueue.main.async {
                guard let scene = UIApplication
                    .shared
                    .connectedScenes
                    .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
                    .last else { return }

                scene.rootViewController = entryViewController
                scene.makeKeyAndVisible()
            }
        }
    }
}

extension AuthenticatorUIKit: AuthenticatorProtocol {
    // MARK: - validToken - check if token is valid or refresh token otherwise
    /**
     Return a valid token or try to get it from storage or remote data source

     - Returns: valid access token
     - Throws: An error of type `CustomError`  with extra info and show login screen
    */
    public func getCurrentToken() async throws -> String {
        do {
            return try await authenticator.getCurrentToken()
        } catch {
            try await logout()
            throw AuthError.refreshFailed
        }
    }
    
    public func isLogged() async -> Bool {
        await authenticator.isLogged()
    }

    public func get(token type: TokenType) async throws -> Token? {
        try await authenticator.get(token: type)
    }

    public func set(token: Token, for type: TokenType) async throws {
        try await authenticator.set(token: token, for: type)
    }

    // MARK: - validToken - check if token is valid or refresh token otherwise
    /**
    Call to login if needed and get token
     - Throws: An error of type `CustomError`  with extra info
    */
    public func getNewToken(with parameters: [String: Any] = [:], endpoint: Endpoint?) async throws {
        try await authenticator.getNewToken(with: parameters, endpoint: endpoint)
    }

    // MARK: - logout
    /**
     Remove data and go to start view controller
     */
    public func logout() async throws {
        try await authenticator.logout()
        showLogin()
    }
}
#endif
