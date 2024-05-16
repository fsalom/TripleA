import Foundation

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
        Task {
            guard var token = try await authenticator.get(token: .access) else { return }
            token.expireDate = .distantPast
            try await authenticator.set(token: token, for: .access)
        }
    }

    func expireAccessAndRefreshToken() {
        Task {
            do {
                guard var accessToken = try await authenticator.get(token: .access) else { return }
                accessToken.expireDate = .distantPast
                try await authenticator.set(token: accessToken, for: .access)
                guard var refreshToken = try await authenticator.get(token: .refresh) else { return }
                refreshToken.expireDate = .distantPast
                try await authenticator.set(token: refreshToken, for: .access)
            } catch {
                
            }
        }
    }

    func loadAuthorized() {
        let network = Network(authenticator: authenticator, format: .full)
        Task {
            let endpoint = Endpoint(path: "https://dashboard-staging.rudo.es/users/me/", httpMethod: .get)
            _ = try await network.loadAuthorized(this: endpoint)
        }
    }

    func launchParallelCalls() {
        loadAuthorized()
        loadAuthorized()
        loadAuthorized()
        loadAuthorized()
    }
}
