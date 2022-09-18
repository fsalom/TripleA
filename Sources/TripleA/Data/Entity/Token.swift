import Foundation

public struct Token {
    public let value: String
    public let expireDate: Date?

    public var isValid: Bool {
        return expireDate == nil ? false : expireDate! > Date()
    }

    public init(value: String, expireDate: Date?) {
        self.value = value
        self.expireDate = expireDate
    }
}
