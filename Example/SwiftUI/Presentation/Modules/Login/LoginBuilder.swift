import Foundation

class LoginBuilder {
    func build() -> LoginView {
        let viewModel = LoginViewModel()
        return LoginView(viewModel: viewModel)
    }
}
