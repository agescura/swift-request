import Foundation
import Dependencies

final public class Category: Equatable, Hashable, Codable {
	public var id: UUID
	public var name: String
	
	public init(
		id: UUID? = nil,
		name: String
	) {
		@Dependency(\.uuid) var uuid
		self.id = id ?? uuid()
		self.name = name
	}
	
	public static func == (lhs: Category, rhs: Category) -> Bool {
		lhs.id == rhs.id
	}
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.id)
	}
}

extension Category {
	public static let new = Category(name: "")
}

extension Category {
	public static let mock = Category(
		id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
		name: "MOCK"
	)
}
