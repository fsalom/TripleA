import Foundation

internal extension URLSession {
    convenience init<T: MockURLResponder>(mockResponder: T.Type) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol<T>.self]
        self.init(configuration: config)
        URLProtocol.registerClass(MockURLProtocol<T>.self)
    }
}
