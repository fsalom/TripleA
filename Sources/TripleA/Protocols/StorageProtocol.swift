public enum StorageKey: String, CaseIterable {
    case accessToken
    case refreshToken
}

public enum StorageError: Error {
    case valueNotFound
    case keyNotFound
}

public protocol StorageProtocol {
    func read(this key: StorageKey) -> Token?
    func save(this object: TokensDTO, for key: StorageKey)
    func remove(this key: StorageKey)
    func removeAll()
}
