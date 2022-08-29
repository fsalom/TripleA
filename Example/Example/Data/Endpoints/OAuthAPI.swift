import TripleA

enum OAuthAPI {
    case login([String: Any])
    var endpoint: Endpoint {
        get {
            switch self {
            case .login(let parameters):
                return Endpoint(path: "auth/token/", httpMethod: .post, parameters: parameters)
            }
        }
    }
}
