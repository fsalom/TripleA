import TripleA

enum CryptoAPI {
    case assets
    var endpoint: Endpoint {
        get {
            switch self {
            case .assets:
                return Endpoint(path: "assets", httpMethod: .get)
            }
        }
    }
}
