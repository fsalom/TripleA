import Foundation
import TripleA

enum LoginState {
    case none
    case logged
    case error
}

final class OAuthViewModel {
    let router: OAuthRouter
    let usecase: ProtectedUseCasesProtocol
    var currentState: LoginState = .none
    
    init(router: OAuthRouter, usecase: ProtectedUseCasesProtocol) {
        self.router = router
        self.usecase = usecase
    }

    func getInfo() async throws -> User {
        do {
            return try await usecase.getMe()
        } catch let error {
            throw error
        }
    }
}

