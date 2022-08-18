public enum AuthError: Error {
    case missingToken
    case missingExpiresIn
    case badRequest
    case tokenNotFound
    case errorData(Data)

    var data: Data {
        switch self {
        case .errorData(let data):
            return data
        default:
            return Data()
        }
    }
}
