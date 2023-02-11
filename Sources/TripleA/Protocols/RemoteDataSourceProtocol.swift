public protocol RemoteDataSourceProtocol {
    func getAccessToken(with parameters: [String: Any]) async throws -> String
    func getRefreshToken(with refreshToken: String) async throws -> String
    func logout() async
}
