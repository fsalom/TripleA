import Foundation
@testable import TripleA

public actor MockAuthenticator {

    var token = Token(value: "_ACCESSTOKEN_", expireInt: 3600)
    
    
    public init() {
    }

    private func renewToken() async throws -> String {
        return ""
    }
}

extension MockAuthenticator: AuthenticatorProtocol {

    public func isLogged() async -> Bool {
        return true
    }

    public func get(token type: TokenType) async throws -> Token? {
        return token
    }

    public func set(token: Token, for type: TokenType) async throws {
        self.token = token
    }

    // MARK: - validToken - check if token is valid or refresh token otherwise
    /**
     Return a valid token or try to get it from storage or remote data source

     - Returns: valid access token
     - Throws: An error of type `CustomError`  with extra info and show login screen
    */
    public func getCurrentToken() async throws -> String {
        if token.isValid {
            return token.value
        } else {
            throw AuthError.refreshFailed
        }
    }

    // MARK: - validToken - check if token is valid or refresh token otherwise
    /**
    Call to login if needed and get token

     - Throws: An error of type `CustomError`  with extra info
    */
    public func getNewToken(with parameters: [String : Any] = [:], endpoint: Endpoint?) async throws {

    }

    // MARK: - logout
    /**
     Remove data and go to start view controller
     */
    public func logout() async throws {
    }
}
