import Foundation
import TripleA

enum LoginState {
    case none
    case logged
    case error
}

final class OAuthViewModel {
    let router: OAuthRouter    
    let network: Network
    var currentState: LoginState = .none
    
    init(router: OAuthRouter) {
        self.router = router
        let authManager = AuthManager(clientId: "a4wiEENUCq2y4VjVBiSoMseER20XC5xgtsuWY2yF",
                                      clientSecret: "1rOMdZg26PawAqA4reAUCr1nLc1dd1KJiuwOrvGAgweZffodg9OaZJFDZaunZZi75K97SwtTd95GxTVBD1VsWu5PYlnSTt0RBQwHKgI4vlnP9qOyIubb52VyhkbC3Wwm")
        self.network = Network(baseURL: "https://dashboard.rudo.es/", authManager: authManager)
    }

    func login() async throws {
        do {
            try await network.getToken(for: OAuthAPI.login.endpoint, username: "sample", password: "rudopassword")
        } catch let error {
            throw error
        }
    }

    func getInfo() async throws -> UserDTO {
        do {
            return try await network.loadAuthorized(endpoint: OAuthAPI.me.endpoint, of: UserDTO.self)
        } catch let error {
            throw error
        }
    }
}

