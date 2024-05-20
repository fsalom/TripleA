import Foundation

public protocol TripleAForUIKitProtocol {
    var authenticator: AuthenticatorUIKit { get }
    var storage: TokenStorageProtocol { get }
    var card: AuthenticationCardProtocol { get }
    var baseURLString: String { get }
}
