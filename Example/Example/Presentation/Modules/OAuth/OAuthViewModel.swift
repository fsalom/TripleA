import Foundation
import TripleA

enum LoginState {
    case none
    case logged
    case error
}

final class OAuthViewModel {
    let router: OAuthRouter
    var currentState: LoginState = .none
    
    init(router: OAuthRouter) {
        self.router = router        
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
            return try await Container.network.loadAuthorized(endpoint: OAuthAPI.me.endpoint, of: UserDTO.self)
        } catch let error {
            throw error
        }
    }
}

