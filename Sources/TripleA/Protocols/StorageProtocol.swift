public enum StorageKey {
    case accessToken
    case expireIn
    case refreshToken
    case refreshExpireIn
    case idToken
}

public enum StorageError: Error {
    case valueNotFound
    case keyNotFound
}

public protocol StorageProtocol {
    func read(this: StorageKey) -> Token?
    func save(this: Any, for: StorageKey)
    func remove(this: StorageKey)
    func removeAll()
}
