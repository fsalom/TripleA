import Foundation

@available(swift, obsoleted: 2.0.3, renamed: "TripleAForSwiftUIProtocol")
public protocol ConfigurationTripleAProtocol {
    var authenticator: AuthenticatorSUI { get }
    var storage: TokenStorageProtocol { get }
    var card: AuthenticationCardProtocol { get }
}

@available(macOS 15.0, *)
public protocol TripleAForSwiftUIProtocol {
    var authenticator: AuthenticatorSUI { get }
    var storage: TokenStorageProtocol { get }
    var card: AuthenticationCardProtocol { get }
    var authenticatedTestingEndpoint: Endpoint? { get }
}
