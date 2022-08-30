import TripleA

enum OAuthAPI {
    case login
    case me
    var endpoint: Endpoint {
        get {
            switch self {
            case .login:
                return Endpoint(path: "auth/token/", httpMethod: .post)
            case .me:
                return Endpoint(path: "users/me/", httpMethod: .get)
            }
        }
    }
}
