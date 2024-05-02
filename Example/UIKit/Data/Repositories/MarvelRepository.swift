import Foundation

class MarvelRepository: MarvelRepositoryProtocol {
    var remote: MarvelDataSourceProtocol

    init(remote: MarvelDataSourceProtocol) {
        self.remote = remote
    }
    
    func getCharacters(parameters: [String:String]) async throws -> [Character] {
        let resultsDTO = try await remote.getCharacters(parameters: parameters)
        return resultsDTO.data.results.map({$0.toDomain()})
    }
}

fileprivate extension CharacterDTO {
    func toDomain() -> Character {
        Character(id: self.id,
                  name: self.name)
    }
}
