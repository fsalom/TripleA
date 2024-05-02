import Foundation
import TripleA

enum MarvelAPI {
    case characters([String: Any])

    var endpoint: Endpoint {
        get {
            switch self {
            case .characters(let parameters):
                return Endpoint(path: "https://gateway.marvel.com:443/v1/public/characters", httpMethod: .get, query: parameters)
            }
        }
    }    
}
