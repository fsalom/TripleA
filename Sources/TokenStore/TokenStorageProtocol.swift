public enum StorageKey: String, CaseIterable {
    case accessToken
    case refreshToken
    case uniqueName
    case idToken
}

public enum StorageError: Error {
    case valueNotFound
    case keyNotFound
}

public protocol TokenStorageProtocol {
    var accessToken: Token? { get set }
    var refreshToken: Token? { get set }
    var idToken: Token? { get set }
    var uniqueName: String? { get set }    
    func removeAll()
}
