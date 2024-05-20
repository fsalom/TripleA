import Foundation

public class AuthTokenStoreDefault {
    private let userDefaults = UserDefaults.standard
    private var format: LogFormat
    public init(format: LogFormat = .short) {
        self.format = format
    }
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
            Log.this(text: "Fetching - \(accessTokenKey)", value: String(describing: object.value), format: format)
            return object
        }
        set {
            let accessTokenKey = StorageKey.accessToken.rawValue
            guard let newValue = newValue else {
                Log.this(text: "Removing - \(accessTokenKey)", value: String(describing: newValue), format: format)
                userDefaults.removeObject(forKey: StorageKey.accessToken.rawValue)
                return
            }
            Log.this(text: "Saving - \(accessTokenKey)", value: String(describing: newValue), format: format)
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
            Log.this(text: "Fetching - \(refreshTokenKey)", value: String(describing: object.value), format: format)
            return object
        }
        set {
            let refreshTokenKey = StorageKey.refreshToken.rawValue
            guard let newValue = newValue else {
                Log.this(text: "Removing - \(refreshTokenKey)", value: String(describing: newValue), format: format)
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
            Log.this(text: "Fetching - \(idTokenKey)", value: String(describing: object.value), format: format)
            return object
        }
        set {
            let idTokenKey = StorageKey.idToken.rawValue
            guard let newValue = newValue else {
                Log.this(text: "Removing - \(idTokenKey)", value: String(describing: newValue), format: format)
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
            Log.this(text: "Fetching - \(uniqueNameKey)", value: String(describing: value), format: format)
            return value
        }
        set {
            let uniqueNameKey = StorageKey.idToken.rawValue
            guard let newValue = newValue else {
                Log.this(text: "Removing - \(uniqueNameKey)", value: String(describing: newValue), format: format)
                userDefaults.removeObject(forKey: StorageKey.uniqueName.rawValue)
                return
            }
            Log.this(text: "Saving - \(uniqueNameKey)", value: newValue, format: format)
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

fileprivate extension Log {
    static func this(text: String, value: String, format: LogFormat) {
        switch format {
        case .full:
            print("🔒 💾 \(text): \(value)")
        case .short:
            print("🔒 💾 \(text)")
        default:
            break
        }
    }
}
