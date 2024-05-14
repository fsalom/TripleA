public enum TokenType {
    case access
    case refresh
}

public protocol AuthenticatorProtocol {
    func getCurrentToken() async throws -> String
    func getNewToken(with parameters: [String: Any]) async throws
    func renewToken() async throws -> String
    func logout() async throws
    func get(token type: TokenType) async throws -> Token?
    func set(token: Token, for type: TokenType) async throws
}
