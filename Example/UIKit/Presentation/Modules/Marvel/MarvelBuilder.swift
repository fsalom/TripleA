import Foundation
import UIKit

class MarvelBuilder {
    func build() -> MarvelViewController {
        let storyboard = UIStoryboard(name: "MarvelView", bundle: nil)
        let marvelVC = storyboard.instantiateViewController(withIdentifier: "MarvelViewController") as! MarvelViewController
        let router = MarvelRouter(viewController: marvelVC)
        let remote = MarvelRemoteDataSource(network: Container.network)
        let repository = MarvelRepository(remote: remote)
        let usecase = MarvelUseCases(repository: repository)
        marvelVC.viewModel = MarvelViewModel(router: router, usecase: usecase)
        return marvelVC
    }
}
