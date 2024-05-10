import Foundation
import TripleA

class DeveloperToolsViewModel: ObservableObject {
    func logout() {
        Task {
            try await Configuration.shared.authenticator.logout()
        }
    }

    func expireAccessToken() {
        Configuration.shared.storage.accessToken?.expireDate = .distantPast
    }

    func expireAccessAndRefreshToken() {
        Configuration.shared.storage.accessToken?.expireDate = .distantPast
        Configuration.shared.storage.refreshToken?.expireDate = .distantPast
    }

    func loadAuthorized() {
        let network = Network(authenticator: Configuration.shared.authenticator, format: .full)
        Task {
            let endpoint = Endpoint(path: "https://dashboard-staging.rudo.es/users/me/", httpMethod: .get)
            _ = try await network.loadAuthorized(this: endpoint)
        }
    }
}
