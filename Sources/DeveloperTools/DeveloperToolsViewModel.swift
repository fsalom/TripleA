import Foundation
import TripleA

class DeveloperToolsViewModel: ObservableObject {
    var authenticator: AuthenticatorProtocol

    init(authenticator: AuthenticatorProtocol) {
        self.authenticator = authenticator
    }

    func logout() {
        Task {
            try await authenticator.logout()
        }
    }

    func expireAccessToken() {
        authenticator.storage.accessToken?.expireDate = .distantPast
    }

    func expireAccessAndRefreshToken() {
        authenticator.storage.accessToken?.expireDate = .distantPast
        authenticator.storage.refreshToken?.expireDate = .distantPast
    }

    func loadAuthorized() {
        let network = Network(authenticator: authenticator, format: .full)
        Task {
            let endpoint = Endpoint(path: "https://dashboard-staging.rudo.es/users/me/", httpMethod: .get)
            _ = try await network.loadAuthorized(this: endpoint)
        }
    }
}
