import Foundation

class MarvelUseCases: MarvelUseCasesProtocol {
    var repository: MarvelRepositoryProtocol

    init(repository: MarvelRepositoryProtocol) {
        self.repository = repository
    }
    
    func getCharacters(parameters: [String:String]) async throws -> [Character] {
        try await repository.getCharacters(parameters: parameters)
    }
}
