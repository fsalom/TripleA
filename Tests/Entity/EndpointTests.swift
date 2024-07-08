import XCTest
@testable import TripleA

class EndpointTests: XCTestCase {

    func testHTTPMethodRawValue() {
        XCTAssertEqual(Endpoint.HTTPMethod.get.rawValue, "GET")
        XCTAssertEqual(Endpoint.HTTPMethod.post.rawValue, "POST")
        XCTAssertEqual(Endpoint.HTTPMethod.patch.rawValue, "PATCH")
        XCTAssertEqual(Endpoint.HTTPMethod.put.rawValue, "PUT")
        XCTAssertEqual(Endpoint.HTTPMethod.delete.rawValue, "DELETE")
    }

    func testContentTypeRawValue() {
        XCTAssertEqual(Endpoint.ContentType.json.rawValue, "application/json")
        XCTAssertEqual(Endpoint.ContentType.xml.rawValue, "text/xml; charset=utf-8")
        XCTAssertEqual(Endpoint.ContentType.image.rawValue, "image/jpeg")
        XCTAssertEqual(Endpoint.ContentType.form.rawValue, "application/x-www-form-urlencoded")
        XCTAssertEqual(Endpoint.ContentType.custom(contentType: "custom/type").rawValue, "custom/type")
        XCTAssertEqual(Endpoint.ContentType.defaultInMethod(.post).rawValue, "application/json")
        XCTAssertNil(Endpoint.ContentType.none.rawValue)
    }

    func testRequestCreation() {
        let endpoint = Endpoint(
            path: "/test",
            contentType: .json,
            httpMethod: .post,
            parameters: ["key": "value"],
            headers: ["HeaderKey": "HeaderValue"]
        )
        let request = endpoint.request
        XCTAssertEqual(request.url?.absoluteString, "/test")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.value(forHTTPHeaderField: "HeaderKey"), "HeaderValue")

        if let httpBody = request.httpBody,
           let json = try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: Any] {
            XCTAssertEqual(json["key"] as? String, "value")
        } else {
            XCTFail("HTTP Body is not a valid JSON")
        }
    }

    func testRequestQueryParameters() {
        let endpoint = Endpoint(
            path: "/test",
            contentType: .json,
            httpMethod: .get,
            query: ["queryKey": "queryValue", "queryArray": ["1", "2"]]
        )
        let request = endpoint.request
        XCTAssertEqual(request.url?.absoluteString, "/test?queryArray=1&queryArray=2&queryKey=queryValue")
    }

    func testSetURLEncoding() {
        let endpoint = Endpoint(
            path: "/test",
            contentType: .json,
            httpMethod: .get,
            query: ["queryKey": "queryValue", "queryArray": ["1", "2"]]
        )
        let request = endpoint.request
        guard let url = request.url else {
            XCTFail()
            return
        }

        let result = endpoint.setURLEncoding(for: url)

        XCTAssertNotNil(result)
    }

    func testAddExtraHeaders() {
        var endpoint = Endpoint(
            path: "/test",
            contentType: .json,
            httpMethod: .get,
            headers: ["HeaderKey": "HeaderValue"]
        )
        endpoint.addExtra(headers: ["NewHeaderKey": "NewHeaderValue"])
        let request = endpoint.request
        XCTAssertEqual(request.value(forHTTPHeaderField: "HeaderKey"), "HeaderValue")
        XCTAssertEqual(request.value(forHTTPHeaderField: "NewHeaderKey"), "NewHeaderValue")
    }

    func testAddBaseURLIfNeeded() {
        var endpoint = Endpoint(
            path: "/test",
            contentType: .json,
            httpMethod: .get
        )
        endpoint.addBaseURLIfNeeded(url: "https://example.com")
        XCTAssertEqual(endpoint.baseURL, "https://example.com")
    }

    func testCreateBodyWithParametersAndImage() {
        var endpoint = Endpoint(
            path: "/test",
            contentType: .form,
            httpMethod: .post
        )
        let imageData = "imageData".data(using: .utf8)!
        endpoint.createBody(with: ["paramKey": "paramValue", "paramNum": 2], and: imageData, for: "imageKey", boundary: "boundary")

        XCTAssertNotNil(endpoint.body)
    }

    func testCreateBodyWithParametersAndImages() {
        var endpoint = Endpoint(
            path: "/test",
            contentType: .form,
            httpMethod: .post
        )
        let imageData = "imageData".data(using: .utf8)!
        endpoint.createBody(with: ["paramKey": "paramValue", "paramNum": 2], and: [imageData], for: "imageKey", boundary: "boundary")

        XCTAssertNotNil(endpoint.body)
    }
}
