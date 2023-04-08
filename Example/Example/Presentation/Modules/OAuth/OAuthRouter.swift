#if canImport(UIKit)
import UIKit

final class OAuthRouter {
    weak var viewController: UIViewController?

    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}
#endif
