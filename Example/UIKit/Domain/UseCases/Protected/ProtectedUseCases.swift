import Foundation

class ProtectedUseCases: ProtectedUseCasesProtocol {
    var repository: ProtectedRepositoryProtocol

    init(repository: ProtectedRepositoryProtocol) {
        self.repository = repository
    }

    func getMe() async throws -> User {
        try await repository.getMe()
    }
}
