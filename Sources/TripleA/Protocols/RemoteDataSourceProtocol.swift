public protocol RemoteDataSourceProtocol {
    func getAccessToken() async throws -> String
    func getRefreshToken(with refreshToken: String) async throws -> String
    func logout() async
}
