import Dependencies
import Foundation

final public class User: Identifiable, Equatable, Hashable, Codable {
	public var id: UUID
	public var name: String
	public var username: String
	public var password: String?
	
	public init(
		id: UUID? = nil,
		name: String,
		username: String,
		password: String? = nil
	) {
		@Dependency(\.uuid) var uuid
		self.id = id ?? uuid()
		self.name = name
		self.username = username
		self.password = password
	}
	
	public static func == (lhs: User, rhs: User) -> Bool {
		lhs.id == rhs.id
	}
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
}

extension User {
	public static let new = User(name: "", username: "", password: "")
}

extension User {
	public static let mock = User(
		id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
		name: "MOCK",
		username: "Multiple Order Checklist Test",
		password: "password"
	)
	
	public static func mock(
		_ id: UUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
	) -> User {
		User(
			id: id,
			name: "MOCK",
			username: "Multiple Order Checklist Test",
			password: "password"
		)
	}
}
