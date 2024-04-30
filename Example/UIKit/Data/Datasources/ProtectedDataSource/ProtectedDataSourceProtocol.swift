import Foundation

protocol ProtectedDataSourceProtocol {
    func getMe() async throws -> UserDTO
}
