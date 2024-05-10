import Foundation
import TripleA

class CryptoListBuilder {
    func build() -> CryptoListView {
        let network = Network(authenticator: Configuration.shared.authenticator, format: .short)
        let remote = CryptoRemoteDataSource(network: network)
        let repository = CryptoRepository(remote: remote)
        let usecase = CryptoUseCases(repository: repository)
        let viewModel = CryptoListViewModel(usecase: usecase)
        return CryptoListView(viewModel: viewModel)
    }
}
