import Foundation

class ProtectedRepository: ProtectedRepositoryProtocol {
    var remote: ProtectedDataSourceProtocol

    init(remote: ProtectedDataSourceProtocol) {
        self.remote = remote
    }

    func getMe() async throws -> User {
        try await remote.getMe().toDomain()
    }
}

fileprivate extension UserDTO {
    func toDomain() -> User {
        User(firstName: self.firstName,
             email: self.email)
    }
}
