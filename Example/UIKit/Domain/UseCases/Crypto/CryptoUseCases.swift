import Foundation

class CryptoUseCases: CryptoUseCasesProtocol {
    var repository: CryptoRepositoryProtocol

    init(repository: CryptoRepositoryProtocol) {
        self.repository = repository
    }

    func getCryptos() async throws -> [Crypto] {
        try await repository.getCryptos()
    }
}
