import Foundation
import TripleA

class CryptoRemoteDataSource: CryptoDataSourceProtocol {

    var network: Network

    init(network: Network) {
        self.network = network
    }

    func getCryptos() async throws -> [CryptoDTO] {
        try await network.load(endpoint: CryptoAPI.assets.endpoint, of: ListDTO.self).data
    }
}
