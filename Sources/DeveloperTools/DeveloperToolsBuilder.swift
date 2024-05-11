import Foundation
import SwiftUI

public class DeveloperToolsBuilder {
    public init() { }
    
    public func build(with authenticator: AuthenticatorProtocol) -> DeveloperToolsView {
        let viewModel = DeveloperToolsViewModel(authenticator: authenticator)
        return DeveloperToolsView(viewModel: viewModel)
    }

    public func buildForUIKit(with authenticator: AuthenticatorProtocol) -> UIHostingController<DeveloperToolsView> {
        let viewModel = DeveloperToolsViewModel(authenticator: authenticator)
        return UIHostingController(rootView: DeveloperToolsView(viewModel: viewModel))
    }
}
