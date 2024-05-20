import Foundation
import SwiftUI

public class DeveloperToolsBuilder {
    public init() { }
    
    public func build(with wrapper: TripleAForSwiftUIProtocol) -> DeveloperToolsView<DeveloperToolsViewModel> {
        let viewModel = DeveloperToolsViewModel(wrapper: wrapper)
        return DeveloperToolsView(viewModel: viewModel)
    }

    public func buildForUIKit(with wrapper: TripleAForUIKitProtocol) -> UIHostingController<DeveloperToolsView<DeveloperToolsUIKitViewModel>> {
        let viewModel = DeveloperToolsUIKitViewModel(wrapper: wrapper)
        return UIHostingController(rootView: DeveloperToolsView(viewModel: viewModel))
    }
}
