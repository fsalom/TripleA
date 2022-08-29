import Foundation
import TripleA

final class OAuthViewModel {
    let router: OAuthRouter
    let network: Network
    
    init(router: OAuthRouter) {
        self.router = router
        let authManager = AuthManager(clientId: "a4wiEENUCq2y4VjVBiSoMseER20XC5xgtsuWY2yF",
                                      clientSecret: "1rOMdZg26PawAqA4reAUCr1nLc1dd1KJiuwOrvGAgweZffodg9OaZJFDZaunZZi75K97SwtTd95GxTVBD1VsWu5PYlnSTt0RBQwHKgI4vlnP9qOyIubb52VyhkbC3Wwm")
        self.network = Network(baseURL: "https://dashboard.rudo.es/", authManager: authManager)
    }

    func login() async throws {
        do {
            let parameters = ["grant_type": "password",
                              "username": "sample",
                              "password": "rudopassword"]
            let login = try await network.getToken(for: OAuthAPI.login(parameters).endpoint)
            print(login)
        } catch let error {
            throw error
        }
    }
}

