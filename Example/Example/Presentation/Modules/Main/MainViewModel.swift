import Foundation
import TripleA

final class MainViewModel {
    let router: MainRouter
    let network: Network
    var cryptos: [CryptoDTO] = []
    
    init(router: MainRouter) {
        self.router = router
        self.network = Network(baseURL: "https://api.coincap.io/v2/")
    }

    func getCryptos() async throws {
        do {
            let list = try await network.load(endpoint: CryptoAPI.assets.endpoint, of: ListDTO.self)
            self.cryptos = list.data
        } catch let error {
            throw error
        }
    }
}
