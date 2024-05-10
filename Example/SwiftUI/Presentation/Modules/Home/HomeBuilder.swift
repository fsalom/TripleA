import Foundation

class HomeBuilder {
    func build() -> HomeView {
        let viewModel = HomeViewModel()
        return HomeView(viewModel: viewModel)
    }
}
