enum AuthError: Error {
    case missingToken
    case missingExpiresIn
    case badRequest
    case tokenNotFound
}
