import Foundation

public struct Token: Codable {
    public let value: String?
    public var expireDate: Date?
    public let expireInt: Int?

    public var isValid: Bool {
        return expireDate == nil ? false : expireDate! > Date()
    }

    public init(value: String? = "", expireInt: Int?) {
        self.value = value
        self.expireInt = expireInt
        self.expireDate = self.parseDate(from: expireInt)
    }

    func parseDate(from value: Int?) -> Date? {
        guard let value = value else {
            return Date().addingTimeInterval(Double(1000000))
        }
        return Date().addingTimeInterval(Double(value))
    }
}

