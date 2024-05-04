import Foundation

class CryptoListBuilder {
    func build() -> CryptoListView {
        let remote = CryptoRemoteDataSource(network: DI.shared.network)
        let repository = CryptoRepository(remote: remote)
        let usecase = CryptoUseCases(repository: repository)
        let viewModel = CryptoListViewModel(usecase: usecase)
        return CryptoListView(VM: viewModel)
    }
}
