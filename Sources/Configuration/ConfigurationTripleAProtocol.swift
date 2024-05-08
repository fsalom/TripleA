import Foundation

public protocol ConfigurationTripleAProtocol {
    var authenticator: AuthenticatorSUI { get }
    var storage: TokenStorageProtocol { get }
    var card: AuthenticationCardProtocol { get }
}
