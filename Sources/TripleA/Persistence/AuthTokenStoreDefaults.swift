import UIKit

public protocol AuthTokenStoreProtocol {
    var accessToken: Token? { get set }
    var refreshToken: Token? { get set }
    var idToken: Token? { get set }
    var uniqueName: String? { get set }
    func clear()
}

public class AuthTokenStoreDefault {
    private let userDefaults = UserDefaults.standard
    public init() { }
}

extension AuthTokenStoreDefault: StorageProtocol {
    public func read(this key: StorageKey) -> Token? {
        guard let savedData = userDefaults.object(forKey: key.rawValue) as? Data  else { return nil }
        guard let object = try? JSONDecoder().decode(TokensDTO.self, from: savedData) else { return nil }
        switch key {
        case .accessToken:
            return object.toBOAccessToken()
        case .refreshToken:
            return object.toBORefreshToken()
        }
    }

    public func save(this token: TokensDTO, for key: StorageKey) {
        guard let encodedData = try? JSONEncoder().encode(token) else {
            print("🤬 ERROR: Persistence.save(objectFor: \(key.rawValue)) > JSON ENCODER ERROR")
            return
        }
        UserDefaults.standard.set(encodedData, forKey: key.rawValue)
    }

    public func remove(this key: StorageKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }

    public func removeAll() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }

}
