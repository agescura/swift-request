@testable import Request
import XCTest

final class RequestTest: XCTestCase {
	struct EncodableType: Encodable {}
	
	func testUrlRequest() {
		let url = URL(string: "http://localhost:8080/foo")!
		XCTAssertTrue(
			try! URLRequest(
				Request<Void, EncodableType>(url: url)!
			)
			.isEqual(
				URLRequest(url: url)
			)
		)
	}
	
	func testUrlComponentsRequest() {
		XCTAssertTrue(
			try! URLRequest(
				Request<Void, EncodableType>(
					urlComponents: URLComponents(string: "http://localhost:8080/foo?query")!
				)!
			)
			.isEqual(
				URLRequest(url: URL(string: "http://localhost:8080/foo?query")!)
			)
		)
	}
}
