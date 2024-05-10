import Foundation

class DeveloperToolsBuilder {
    func build() -> DeveloperToolsView {
        let viewModel = DeveloperToolsViewModel()
        return DeveloperToolsView(viewModel: viewModel)
    }
}
