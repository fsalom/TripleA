import Foundation

class MarvelUseCases: MarvelUseCasesProtocol {
    var repository: MarvelRepositoryProtocol

    init(repository: MarvelRepositoryProtocol) {
        self.repository = repository
    }
    
    func getCharacters() async throws -> [Character] {
        try await repository.getCharacters()
    }
}
