import Foundation

protocol ProtectedUseCasesProtocol {
    func getMe() async throws -> User
}
