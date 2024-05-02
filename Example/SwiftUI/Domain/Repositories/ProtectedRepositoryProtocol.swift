import Foundation

protocol ProtectedRepositoryProtocol {
    func getMe() async throws -> User
}
