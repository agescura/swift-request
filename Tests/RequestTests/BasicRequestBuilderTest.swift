@testable import Request
import XCTest

final class BasicRequestBuilderTest: XCTestCase {

	struct User: Decodable, Equatable {
		let id: UUID
		let name: String
		let username: String
	}
	
	@RequestBuilder
	var base: RequestBase {
		Scheme(.http)
		Host("localhost")
		Port(8080)
		Uri("/api")
		Header(.contentType(.application(.json)))
	}
	
	@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
	func testBasics() async throws {
		@RequestBuilder
		var users: Request<[User], Never> {
			base
			Uri("/users")
		}
		
		XCTAssertEqual(
			users,
			Request<[User], Never>(
				scheme: .http,
				host: "localhost",
				port: 8080,
				uri: "/api/users",
				headers: ["Content-Type": "application/json"]
			)
		)
	}
	
	@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
	func testBasics2() async throws {
		@RequestBuilder
		var users: Request<[User], Never> {
			Scheme(.http)
			Host("localhost")
			Port(8080)
			Uri("/api/users")
			Method(.get)
			Header(.contentType(.application(.xml)))
		}
		
		XCTAssertEqual(
			users,
			Request<[User], Never>(
				scheme: .http,
				host: "localhost",
				port: 8080,
				uri: "/api/users",
				headers: ["Content-Type": "application/xml"]
			)
		)
	}
}
