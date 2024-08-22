public enum TokenType {
    case access
    case refresh
}

public protocol AuthenticatorProtocol {
    func isLogged() async -> Bool
    func getCurrentToken() async throws -> String
    func getNewToken(with parameters: [String: Any], endpoint: Endpoint?) async throws
    func logout() async throws
    func get(token type: TokenType) async throws -> Token?
    func set(token: Token, for type: TokenType) async throws
}
