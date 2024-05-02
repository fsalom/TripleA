import Foundation
import TripleA

class MarvelRemoteDataSource: MarvelDataSourceProtocol {
    var network: Network
    
    init(network: Network) {
        self.network = network
    }

    func getCharacters(parameters: [String:String]) async throws -> ResultDTO {
        return try await network.load(endpoint: MarvelAPI.characters(parameters).endpoint, of: ResultDTO.self)
    }
}
