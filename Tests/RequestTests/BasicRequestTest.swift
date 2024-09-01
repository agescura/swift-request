import OHHTTPStubsSwift
import OHHTTPStubs
@testable import Request
import SnapshotTesting
import XCTest

@MainActor
final class BasicRequestTest: XCTestCase {
	let session = URLSession.shared

	struct User: Decodable {
		let id: UUID
		let name: String
		let username: String
	}
	
	struct EntityUser: DecodableMappable {
		let id: UUID
		let name: String
		let username: String
		
		static func map(_ response: DTO) -> Self {
			Self(id: response.id, name: response.name, username: response.username)
		}
		
		struct DTO: Decodable {
			let id: UUID
			let name: String
			let username: String
		}
	}
	
	@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
	func testBasics() async throws {
		stub(
				condition: { req in
						if let url = req.url?.absoluteString { return url.contains("/api/users") }
						return false
				}
		) { _ in fixture(json: "users") }
		
		let request = RequestDecodable<[User]>(
			scheme: .http,
			host: "localhost",
			port: 8080,
			uri: "/api/users"
		)
		
		let users = try await session.data(for: request)
		assertSnapshot(matching: users, as: .dump)
	}
	
	@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
	func testBasicsError() async throws {
		stub(
				condition: { req in
						if let url = req.url?.absoluteString { return url.contains("/api/users") }
							return false
				}
		) { _ in .init(data: Data(), statusCode: 400, headers: nil) }
		
		let request = RequestDecodable<[User]>(
			scheme: .http,
			host: "localhost",
			port: 8080,
			uri: "/api/users"
		)
		
		do {
			try await session.data(for: request)
		} catch {
			let error = error as! HTTPError
			XCTAssertEqual(error.data, Data())
			XCTAssertEqual(error.response.url, URL(string: "http://localhost:8080/api/users"))
			XCTAssertEqual(error.response.statusCode, 400)
		}
	}
	
	@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
	func testMappable() async throws {
		stub(
				condition: { req in
						if let url = req.url?.absoluteString { return url.contains("/api/users") }
						return false
				}
		) { _ in fixture(json: "users") }
		
		let request = RequestDecodableMappable<[EntityUser]>(
			scheme: .http,
			host: "localhost",
			port: 8080,
			uri: "/api/users"
		)
		
		let users = try await session.data(for: request)
		assertSnapshot(matching: users, as: .dump)
	}
	
	@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
	func testPost() async throws {
		struct UserDTO: Encodable {
			let username: String
			let name: String
		}
		
		let request = RequestPlain(
			scheme: .http,
			host: "localhost",
			port: 8080,
			uri: "/api/users/94DA9A69-10B5-419E-B972-5FEE66728D7F",
			method: .delete,
			headers: ["Content-Type": "application/json"]
		)
		
		let response = try await session.data(for: request)
		print(response)
	}
	
	@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
	func testBasics2() {
		let request = RequestPlain(
			scheme: .http,
			host: "localhost",
			port: 8080,
			uri: "/api/users/94DA9A69-10B5-419E-B972-5FEE66728D7F",
			method: .delete,
			headers: ["Content-Type": "application/json"]
		)
		
		var request2 = URLRequest(url: URL(string: "http://localhost:8080/api/users/94DA9A69-10B5-419E-B972-5FEE66728D7F")!)
		request2.httpMethod = "delete"
		request2.allHTTPHeaderFields = ["Content-Type": "application/json"]
		
		XCTAssertTrue(try! URLRequest(request).isEqual(request2))
	}
}

func fixture(
		json: String,
		status: Int = 200
) -> HTTPStubsResponse {
		let path = Bundle.module
				.path(
				forResource: json,
				ofType: "json",
				inDirectory: "stubs"
		)
		return fixture(
				filePath: path!,
				status: Int32(status),
				headers: ["Content-Type": "application/json"]
		)
}
