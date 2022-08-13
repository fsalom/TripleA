import Foundation

enum NetworkError: Error {
    case missingToken
    case invalidToken
    case invalidResponse
    case errorDecodable
    case errorData(Data)

    var localizedDescription: String {
      switch self{
      case .missingToken: return "Access Token not found"
      case .invalidToken: return "Access Token not valid"
      case .invalidResponse: return "Response not expected"
      case .errorDecodable: return "Error while decoding object. Check your DTO"
      case .errorData(let data): return "Error reponse with data: \(data.prettyPrintedJSONString ?? "")"
      }
    }

    var data: Data {
      switch self {
      case .errorData(let data):
        return data
      default:
        return Data()
      }
    }
}
