import TripleA

enum CryptoAPI {
    case assets
    var endpoint: Endpoint {
        get {
            switch self {
            case .assets:
                return Endpoint(path: "https://api.coincap.io/v2/assets", httpMethod: .get)
            }
        }
    }
}
