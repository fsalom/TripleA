import TripleA

enum OAuthAPI {
    case login([String: Any])
    case refresh([String: Any])
    case me
    var endpoint: Endpoint {
        get {
            switch self {
            case .login(let parameters):
                return Endpoint(baseURL: "https://dashboard.rudo.es/", path: "auth/token/", httpMethod: .post, parameters: parameters)
            case .refresh(let parameters):
                return Endpoint(path: "auth/token/", httpMethod: .post, parameters: parameters)
            case .me:
                return Endpoint(path: "users/me/", httpMethod: .get)
            }
        }
    }
}
