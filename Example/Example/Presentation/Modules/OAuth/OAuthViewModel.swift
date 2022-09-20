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
        let parametersLogin = ["": ""]
        let parametersRefresh = ["": ""]
        let storage = AuthTokenStoreDefault()
        let remoteDataSource = OAuthGrantTypePasswordManager(storage: storage, startController: OAuthController(), refreshTokenEndpoint: OAuthAPI.login(parametersLogin).endpoint, tokensEndPoint: OAuthAPI.refresh(parametersRefresh).endpoint)
        let authManager = AuthManager(storage: storage, remoteDataSource: remoteDataSource, parameters: [:])
        self.network = Network(baseURL: "https://dashboard.rudo.es/", authManager: authManager)
    }

    func login() async throws {
        do {
            //try await network.getToken(for: , username: "sample", password: "rudopassword")
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

