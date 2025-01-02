import Foundation

#if !os(watchOS)
public class DeveloperToolsUIKitViewModel: DeveloperToolsViewModelProtocol {
    var wrapper: TripleAForUIKitProtocol

    init(wrapper: TripleAForUIKitProtocol) {
        self.wrapper = wrapper
    }

    public func logout() {
        Task {
            try await wrapper.authenticator.logout()
        }
    }

    public func expireAccessToken() {
        Task {

            guard var token = try await wrapper.authenticator.get(token: .access) else { return }
            token.expireDate = .distantPast
            try await wrapper.authenticator.set(token: token, for: .access)
        }
    }

    public func expireAccessAndRefreshToken() {
        Task {
            do {
                guard var accessToken = try await wrapper.authenticator.get(token: .access) else { return }
                accessToken.expireDate = .distantPast
                try await wrapper.authenticator.set(token: accessToken, for: .access)
                guard var refreshToken = try await wrapper.authenticator.get(token: .refresh) else { return }
                refreshToken.expireDate = .distantPast
                try await wrapper.authenticator.set(token: refreshToken, for: .access)
            } catch {

            }
        }
    }

    public func loadAuthorized() {
        let network = Network(authenticator: wrapper.authenticator, format: .full)
        Task {
            let endpoint = Endpoint(path: "https://dashboard-staging.rudo.es/users/me/", httpMethod: .get)
            _ = try await network.loadAuthorized(this: endpoint)
        }
    }

    public func launchParallelCalls() {
        loadAuthorized()
        loadAuthorized()
        loadAuthorized()
        loadAuthorized()
    }
}
#endif
