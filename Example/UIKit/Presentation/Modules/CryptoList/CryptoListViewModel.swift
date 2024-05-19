import Foundation
import TripleA

final class CryptoListViewModel {
    let router: CryptoListRouter
    let usecase: CryptoUseCasesProtocol
    var cryptos: [Crypto] = []
    
    init(router: CryptoListRouter, usecase: CryptoUseCasesProtocol) {
        self.router = router
        self.usecase = usecase
    }

    func getCryptos() async throws {
        do {
            //LOAD CRYPTO LIST
            let cryptos = try await usecase.getCryptos()
            self.cryptos = cryptos
        } catch let error {
            throw error 
        }
    }
}
