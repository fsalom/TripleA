import Foundation
import UIKit

class OAuthBuilder {
    func build() -> OAuthViewController {
        let storyboard = UIStoryboard(name: "OAuthView", bundle: nil)
        let oauthVC = storyboard.instantiateViewController(withIdentifier: "OAuthViewController") as! OAuthViewController
        let router = OAuthRouter(viewController: oauthVC)
        let remote = ProtectedDataSource(network: Container.network)
        let repository = ProtectedRepository(remote: remote)
        let usecase = ProtectedUseCases(repository: repository)
        oauthVC.viewModel = OAuthViewModel(router: router, usecase: usecase)
        return oauthVC
    }
}
