import XCTest
@testable import NeoNetwork

final class NeoEndpointTests: XCTestCase {
    private var sut: NeoEndpointConformant!

    override func setUp() {
        super.setUp()
        sut = .init()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_NeoEndpoint_Init_ReturnsCorrectHTTPScheme() throws {
        XCTAssertEqual(sut.httpScheme, .https)
    }

    func test_NeoEndpoint_Init_ReturnsCorrectHost() throws {
        XCTAssertEqual(sut.host, "neonetwork.com")
    }

    func test_NeoEndpoint_Init_ReturnsCorrectPath() throws {
        XCTAssertEqual(sut.path, "/contacts")
    }

    func test_NeoEndpoint_Init_ReturnsCorrectQueryItem() throws {
        XCTAssertTrue(sut.queryItems.contains(where: { $0.name == "api_key" }))
        XCTAssertTrue(sut.queryItems.contains(where: { $0.value == "some_api_key" }))
    }

    func test_NeoEndpoint_Init_ReturnsCorrectHTTPMethod() throws {
        XCTAssertEqual(sut.httpMethod, .get)
    }

    func test_NeoEndpoint_URL_ReturnsCorrectURLString() throws {
        XCTAssertEqual(sut.url?.absoluteString, "https://neonetwork.com/contacts?api_key=some_api_key")
    }

    func test_NeoEndpoint_URL_ReturnsCorrectURLStringWithoutQueryItems() throws {
        let sut = NeoEndpointConformant(queryItems: [])
        XCTAssertEqual(sut.url?.absoluteString, "https://neonetwork.com/contacts")
    }
}

private extension NeoEndpointTests {
    struct NeoEndpointConformant: NeoEndpoint {
        let httpScheme: HTTPScheme
        let host: String
        let path: String
        let queryItems: [URLQueryItem]
        let httpMethod: HTTPMethod

        init(httpScheme: HTTPScheme = .https,
             host: String = "neonetwork.com",
             path: String = "/contacts",
             queryItems: [URLQueryItem] = [.init(name: "api_key", value: "some_api_key")],
             httpMethod: HTTPMethod = .get) {
            self.httpScheme = httpScheme
            self.host = host
            self.path = path
            self.queryItems = queryItems
            self.httpMethod = httpMethod
        }
    }
}
