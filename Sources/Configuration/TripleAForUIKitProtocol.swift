import Foundation

#if !os(watchOS)
public protocol TripleAForUIKitProtocol {
    var authenticator: AuthenticatorUIKit { get }
    var storage: TokenStorageProtocol { get }
    var card: AuthenticationCardProtocol { get }
    var authenticatedTestingEndpoint: Endpoint? { get }
}
#endif
