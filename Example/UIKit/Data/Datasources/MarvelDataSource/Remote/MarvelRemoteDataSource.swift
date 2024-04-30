import Foundation
import TripleA

class MarvelRemoteDataSource: MarvelDataSourceProtocol {
    var network: Network
    
    init(network: Network) {
        self.network = network
    }

    func getCharacters() async throws -> ResultDTO {
        return try await network.load(endpoint: MarvelAPI.characters([:]).endpoint, of: ResultDTO.self)
    }
}
