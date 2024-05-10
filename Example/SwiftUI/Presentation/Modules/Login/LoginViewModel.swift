import Foundation


class LoginViewModel: ObservableObject {
    @Published var email: String = "desarrollo@rudo.es"
    @Published var password: String = "12345678A"
    func login() {
        Task {
            do {
                let parameters = ["username": email,
                                  "password": password,
                                  "grant_type": "password"]
                try await Configuration.shared.authenticator.getNewToken(with: parameters)
            } catch {

            }
        }
    }
}
