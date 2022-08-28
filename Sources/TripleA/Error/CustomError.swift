import Foundation

public struct CustomError: Error {
    public let type: NetworkError
    public let data: Data?
    public let description: NSString?
    public let code: Int
    public let raw: Error?
    public let rawDescription: String?

    public init(type: NetworkError, data: Data? = nil, error: Error? = nil, code: Int = 0) {
        self.type = type
        self.data = data
        self.code = code
        self.description = data?.prettyPrintedJSONString ?? ""
        self.rawDescription = error?.localizedDescription
        self.raw = error
    }
}
