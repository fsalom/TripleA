import Foundation

public class AuthTokenStoreDefault {
    private let userDefaults = UserDefaults.standard
    public init() { }
}

extension AuthTokenStoreDefault: TokenStorageProtocol {
    public var accessToken: Token? {
        get {
            let accessTokenKey = StorageKey.accessToken.rawValue
            guard let savedData = UserDefaults.standard.object(forKey: accessTokenKey) as? Data  else {
                Log.this("Fetching - \(accessTokenKey) > NOT FOUND")
                return nil
            }
            guard let object = try? JSONDecoder().decode(Token.self, from: savedData) else { return nil }
            Log.this("Fetching - \(accessTokenKey): \(String(describing: object.value))")
            return object
        }
        set {
            let accessTokenKey = StorageKey.accessToken.rawValue
            guard let newValue = newValue else {
                Log.this("Removing - \(accessTokenKey): \(String(describing: newValue))")
                userDefaults.removeObject(forKey: StorageKey.accessToken.rawValue)
                return
            }
            Log.this("Saving - \(accessTokenKey): \(newValue)")
            guard let encodedData = try? JSONEncoder().encode(newValue) else {
                Log.this("🤬 Error saving - \(accessTokenKey) > JSON ENCODER ERROR")
                return
            }
            userDefaults.set(encodedData, forKey: accessTokenKey)
        }
    }

    public var refreshToken: Token? {
        get {
            let refreshTokenKey = StorageKey.refreshToken.rawValue
            guard let savedData = UserDefaults.standard.object(forKey: refreshTokenKey) as? Data  else {
                Log.this("Fetching - \(refreshTokenKey) > NOT FOUND")
                return nil
            }
            guard let object = try? JSONDecoder().decode(Token.self, from: savedData) else { return nil }
            Log.this("Fetching - \(refreshTokenKey): \(String(describing: object.value))")
            return object
        }
        set {
            let refreshTokenKey = StorageKey.refreshToken.rawValue
            guard let newValue = newValue else {
                Log.this("Removing - \(refreshTokenKey): \(String(describing: newValue))")
                userDefaults.removeObject(forKey: StorageKey.refreshToken.rawValue)
                return
            }
            Log.this("Saving - \(refreshTokenKey): \(newValue)")
            guard let encodedData = try? JSONEncoder().encode(newValue) else {
                Log.this("🤬 Error saving - \(refreshTokenKey) > JSON ENCODER ERROR")
                return
            }
            userDefaults.set(encodedData, forKey: refreshTokenKey)
        }
    }

    public var idToken: Token? {
        get {
            let idTokenKey = StorageKey.idToken.rawValue
            guard let savedData = UserDefaults.standard.object(forKey: idTokenKey) as? Data  else {
                Log.this("Fetching - \(idTokenKey) > NOT FOUND")
                return nil
            }
            guard let object = try? JSONDecoder().decode(Token.self, from: savedData) else { return nil }
            Log.this("Fetching - \(idTokenKey): \(String(describing: object.value))")
            return object
        }
        set {
            let idTokenKey = StorageKey.idToken.rawValue
            guard let newValue = newValue else {
                Log.this("Removing - \(idTokenKey): \(String(describing: newValue))")
                userDefaults.removeObject(forKey: StorageKey.idToken.rawValue)
                return
            }
            Log.this("Saving - \(idTokenKey): \(newValue)")
            guard let encodedData = try? JSONEncoder().encode(newValue) else {
                Log.this("🤬 Error saving - \(idTokenKey) > JSON ENCODER ERROR")
                return
            }
            userDefaults.set(encodedData, forKey: idTokenKey)
        }
    }

    public var uniqueName: String? {
        get {
            let uniqueNameKey = StorageKey.idToken.rawValue
            let value = userDefaults.object(forKey: StorageKey.uniqueName.rawValue) as? String
            Log.this("Fetching - \(uniqueNameKey): \(String(describing: value))")
            return value
        }
        set {
            let uniqueNameKey = StorageKey.idToken.rawValue
            guard let newValue = newValue else {
                Log.this("Removing - \(uniqueNameKey): \(String(describing: newValue))")
                userDefaults.removeObject(forKey: StorageKey.uniqueName.rawValue)
                return
            }
            Log.this("Saving - \(uniqueNameKey): \(newValue)")
            userDefaults.set(newValue, forKey: StorageKey.uniqueName.rawValue)
        }
    }

    public func removeAll() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }

}
