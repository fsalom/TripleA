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

    func login() async throws -> String {
        do {
            let parameters = ["grant_type": "password",
                              "username": "sample",
                              "password": "rudopassword",
                              "client_id": "a4wiEENUCq2y4VjVBiSoMseER20XC5xgtsuWY2yF",
                              "client_secret": "1rOMdZg26PawAqA4reAUCr1nLc1dd1KJiuwOrvGAgweZffodg9OaZJFDZaunZZi75K97SwtTd95GxTVBD1VsWu5PYlnSTt0RBQwHKgI4vlnP9qOyIubb52VyhkbC3Wwm"]
            return try await network.getToken(for: OAuthAPI.login(parameters).endpoint)
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

