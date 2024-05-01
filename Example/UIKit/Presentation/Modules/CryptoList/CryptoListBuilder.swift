import Foundation
import UIKit

class CryptoListBuilder {
    func build() -> CryptoListViewController {
        let storyboard = UIStoryboard(name: "CryptoListView", bundle: nil)
        let cryptoVC = storyboard.instantiateViewController(withIdentifier: "CryptoListViewController") as! CryptoListViewController
        let router = CryptoListRouter(viewController: cryptoVC)
        let remote = CryptoRemoteDataSource(network: Container.network)
        let repository = CryptoRepository(remote: remote)
        let usecase = CryptoUseCases(repository: repository)
        cryptoVC.viewModel = CryptoListViewModel(router: router, usecase: usecase)
        return cryptoVC
    }
}
