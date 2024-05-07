public protocol AuthenticatorProtocol {
    func getCurrentToken() async throws -> String
    func getNewToken(with parameters: [String: Any]) async throws
    func renewToken() async throws -> String
    func logout() async throws
}
