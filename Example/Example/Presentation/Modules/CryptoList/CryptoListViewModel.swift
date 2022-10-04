import Foundation
import TripleA

final class CryptoListViewModel {
    let router: CryptoListRouter
    let network: Network
    var cryptos: [CryptoDTO] = []
    
    init(router: CryptoListRouter) {
        self.router = router
        //NETWORK
        self.network = Network(baseURL: "https://api.coincap.io/v2/")
    }

    func getCryptos() async throws {
        do {
            //LOAD CRYPTO LIST
            let list = try await network.load(endpoint: CryptoAPI.assets.endpoint, of: ListDTO.self)
            self.cryptos = list.data
        } catch let error {
            throw error
        }
    }
}
