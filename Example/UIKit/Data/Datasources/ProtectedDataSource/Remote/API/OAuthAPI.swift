import TripleA

enum OAuthAPI {
    case login([String: Any])
    case refresh([String: Any])
    case me
    case users
    var endpoint: Endpoint {
        get {
            switch self {
            case .login(let parameters):
                return Endpoint(path: "https://dashboard-staging.rudo.es/auth/token/", httpMethod: .post, parameters: parameters)
            case .refresh(let parameters):
                return Endpoint(path: "https://dashboard-staging.rudo.es/auth/token/", httpMethod: .post, parameters: parameters)
            case .me:
                return Endpoint(path: "https://dashboard-staging.rudo.es/users/me/", httpMethod: .get)
            case .users:
                return Endpoint(path: "https://dashboard-staging.rudo.es/users/", httpMethod: .get)
            }
        }
    }
}
