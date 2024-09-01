import Foundation
import Dependencies

final public class Acronym: Equatable, Hashable, Codable {
	public var id: UUID
	public var short: String
	public var long: String
	public var user: User
	
	public struct User: Equatable, Hashable, Codable {
		public var id: UUID
		
		public init(
			id: UUID
		) {
			self.id = id
		}
	}
	
	public init(
		id: UUID? = nil,
		short: String,
		long: String,
		userID: UUID
	) {
		@Dependency(\.uuid) var uuid
		self.id = id ?? uuid()
		self.short = short
		self.long = long
		self.user = User(id: userID)
	}
	
	public static func == (lhs: Acronym, rhs: Acronym) -> Bool {
		lhs.id == rhs.id &&
		lhs.short == rhs.short &&
		lhs.long == rhs.long &&
		lhs.user == rhs.user
	}
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
}

extension Acronym {
	public static let mock = Acronym(
		id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
		short: "MOCK",
		long: "Multiple Order Checklist Test",
		userID: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
	)
}
