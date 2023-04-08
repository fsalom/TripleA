import Security
import Foundation

fileprivate class KeyChain {
    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary)
        return SecItemAdd(query as CFDictionary, nil)
    }

    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject? = nil

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }

    class func remove(key: String) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        // Delete any existing items
        let status = SecItemDelete(query as CFDictionary)
        if (status != errSecSuccess) {
            if let _ = SecCopyErrorMessageString(status, nil) {
                return false
            }
        }
        return true
    }

    class func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)

        let swiftString: String = cfStr as String
        return swiftString
    }
}

fileprivate extension Data {
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }

    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}

public class AuthTokenStoreKeychain {
    public init() { }
}

extension AuthTokenStoreKeychain: StorageProtocol {
    public var accessToken: Token? {
        get {
            let accessTokenKey = StorageKey.accessToken.rawValue
            guard let savedData = KeyChain.load(key: accessTokenKey)  else {
                Log.this("Fetching - \(accessTokenKey) > NOT FOUND")
                return nil
            }
            guard let object = try? JSONDecoder().decode(Token.self, from: savedData) else {
                Log.this("🤬 Error Decoding - \(accessTokenKey)")
                return nil
            }
            Log.this("Fetching - \(accessTokenKey): \(String(describing: object.value))")
            return object
        }
        set {
            let accessTokenKey = StorageKey.accessToken.rawValue
            guard let newValue = newValue else {
                let success = KeyChain.remove(key: StorageKey.accessToken.rawValue)
                if success {
                    Log.this("Removing - \(accessTokenKey): \(String(describing: newValue))")
                } else {
                    Log.this("🤬 Error Removing - \(accessTokenKey)")
                }
                return
            }
            Log.this("Saving - \(accessTokenKey): \(newValue)")
            guard let encodedData = try? JSONEncoder().encode(newValue) else {
                Log.this("🤬 Error saving - \(accessTokenKey) > JSON ENCODER ERROR")
                return
            }
            _ = KeyChain.save(key: accessTokenKey, data: encodedData)
        }
    }

    public var refreshToken: Token? {
        get {
            let refreshTokenKey = StorageKey.refreshToken.rawValue
            guard let savedData = KeyChain.load(key: refreshTokenKey) else {
                Log.this("Fetching - \(refreshTokenKey) > NOT FOUND")
                return nil
            }
            guard let object = try? JSONDecoder().decode(Token.self, from: savedData) else {
                Log.this("🤬 Error Decoding - \(refreshTokenKey)")
                return nil

            }
            Log.this("Fetching - \(refreshTokenKey): \(String(describing: object.value))")
            return object
        }
        set {
            let refreshTokenKey = StorageKey.refreshToken.rawValue
            guard let newValue = newValue else {
                let success = KeyChain.remove(key: StorageKey.refreshToken.rawValue)
                if success {
                    Log.this("Removing - \(refreshTokenKey): \(String(describing: newValue))")
                } else {
                    Log.this("🤬 Error Removing - \(refreshTokenKey)")
                }
                return
            }
            Log.this("Saving - \(refreshTokenKey): \(newValue)")
            guard let encodedData = try? JSONEncoder().encode(newValue) else {
                Log.this("🤬 Error saving - \(refreshTokenKey) > JSON ENCODER ERROR")
                return
            }
            _ = KeyChain.save(key: refreshTokenKey, data: encodedData)
        }
    }

    public var idToken: Token? {
        get {
            let idTokenKey = StorageKey.idToken.rawValue
            guard let savedData = UserDefaults.standard.object(forKey: idTokenKey) as? Data  else {
                Log.this("Fetching - \(idTokenKey) > NOT FOUND")
                return nil
            }
            guard let object = try? JSONDecoder().decode(Token.self, from: savedData) else {
                Log.this("🤬 Error Decoding - \(idTokenKey)")
                return nil
            }
            Log.this("Fetching - \(idTokenKey): \(String(describing: object.value))")
            return object
        }
        set {
            let idTokenKey = StorageKey.idToken.rawValue
            guard let newValue = newValue else {
                let success = KeyChain.remove(key: StorageKey.refreshToken.rawValue)
                if success {
                    Log.this("Removing - \(idTokenKey): \(String(describing: newValue))")
                } else {
                    Log.this("🤬 Error Removing - \(idTokenKey)")
                }
                return
            }
            Log.this("Saving - \(idTokenKey): \(newValue)")
            guard let encodedData = try? JSONEncoder().encode(newValue) else {
                Log.this("🤬 Error saving - \(idTokenKey) > JSON ENCODER ERROR")
                return
            }
            _ = KeyChain.save(key: idTokenKey, data: encodedData)
        }
    }

    public var uniqueName: String? {
        get {
            let uniqueNameKey = StorageKey.uniqueName.rawValue
            if let receivedData = KeyChain.load(key: uniqueNameKey) {
                let value = receivedData.to(type: String.self)
                Log.this("Fetching - \(uniqueNameKey): \(String(describing: value))")
                return value
            }
            Log.this("🤬 Error Fetching - \(uniqueNameKey)")
            return nil
        }
        set {
            let uniqueNameKey = StorageKey.uniqueName.rawValue
            guard let newValue = newValue else {
                let success = KeyChain.remove(key: uniqueNameKey)
                if success {
                    Log.this("Removing - \(uniqueNameKey): \(String(describing: newValue))")
                } else {
                    Log.this("🤬 Error Removing - \(uniqueNameKey)")
                }
                return
            }
            Log.this("Saving - \(uniqueNameKey): \(newValue)")
            _ = KeyChain.save(key: uniqueNameKey, data: Data(from: newValue))
        }
    }

    public func removeAll() {
        let keysToRemove = [StorageKey.uniqueName.rawValue,
                            StorageKey.idToken.rawValue,
                            StorageKey.accessToken.rawValue,
                            StorageKey.refreshToken.rawValue]
        for key in keysToRemove {
            let success = KeyChain.remove(key: key)
            if success {
                Log.this("Removing - \(key)")
            } else {
                Log.this("🤬 Error Removing - \(key)")
            }
        }
    }
}
