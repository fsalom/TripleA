import Foundation
import XCTest

class MockURLProtocol<Responder: MockURLResponder>: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let client = client else { return }

        let data = Responder.respond(to: request)
        let response = Responder.response(for: request)
        let error = Responder.error()
        if let response {
            client.urlProtocol(self,
                               didReceive: response,
                               cacheStoragePolicy: .notAllowed
            )
        }
        if let data {
            client.urlProtocol(self, didLoad: data)
        }
        if let error {
            client.urlProtocol(self, didFailWithError: error)
        }

        client.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }
}
