import Foundation

public enum NetworkError: Error {
    case missingToken
    case invalidToken
    case invalidResponse
    case errorDecodable
    case errorDecodableWith(Error)
    case errorData(Data)
    
    var localizedDescription: String {
        switch self{
        case .missingToken: return "Access Token not found"
        case .invalidToken: return "Access Token not valid"
        case .invalidResponse: return "Response not expected"
        case .errorDecodable: return "Error while decoding object. Check your DTO."
        case .errorDecodableWith(let message): return "Error while decoding object. Check your DTO. Error message: \(message.localizedDescription)."
        case .errorData(let data): return "Error reponse with data: \(data.prettyPrintedJSONString ?? "")"
        }
    }
    
    public var data: Data {
        switch self {
        case .errorData(let data):
            return data
        default:
            return Data()
        }
    }
}
