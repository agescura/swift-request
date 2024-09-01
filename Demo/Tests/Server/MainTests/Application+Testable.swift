import XCTVapor
import Main

extension Application {
	static func testable() async throws -> Application {
		let app = try await Application.make(.testing)
		try await configure(app)
		try await app.autoRevert()
		try await app.autoMigrate()
		return app
	}
}
