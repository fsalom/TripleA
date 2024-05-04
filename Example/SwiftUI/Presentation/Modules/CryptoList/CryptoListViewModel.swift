import Foundation

final class CryptoListViewModel: ObservableObject {
    let usecase: CryptoUseCasesProtocol
    @Published var cryptos: [Crypto] = []
    @Published var searchText: String = ""

    init(usecase: CryptoUseCasesProtocol) {
        self.usecase = usecase
    }

    @MainActor
    func load() async throws {
        do {
            let cryptos = try await usecase.getCryptos()
            self.cryptos = cryptos
        } catch let error {
            throw error
        }
    }
}
