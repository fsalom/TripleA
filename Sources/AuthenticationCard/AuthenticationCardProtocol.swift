public protocol AuthenticationCardProtocol {    
    func getTokensWithLogin(with parameters: [String: Any], endpoint: Endpoint?) async throws -> Tokens
    func getNewTokens(with refreshToken: String) async throws -> Tokens    
    func logout() async throws
}
