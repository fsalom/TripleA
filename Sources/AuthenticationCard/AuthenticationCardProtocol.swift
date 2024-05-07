public protocol AuthenticationCardProtocol {
    func getTokensWithLogin(with parameters: [String: Any]) async throws -> Tokens
    func getNewTokens(with refreshToken: String) async throws -> Tokens    
    func logout() async throws
}
