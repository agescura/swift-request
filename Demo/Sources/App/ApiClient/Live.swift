import ComposableArchitecture
import Dependencies
import Foundation
import Request

extension ApiClient: DependencyKey {
	public static var liveValue: Self = {
		let session = Session()

		actor Session {
			private let shared = URLSession.shared
			nonisolated let value: Isolated<String?>
			
			init(
				value: String? = nil
			) {
				self.value = Isolated(value)
			}
			
			var isLoggedIn: Bool { self.value.value != nil }
			
			func logout() {
				self.value.value = nil
			}
			
			func set(value: String) {
				self.value.value = value
			}
			
			@discardableResult
			public func data<D: Decodable, E: Encodable>(
				for request: Request<D, E>
			) async throws -> D {
				try await self.shared.data(for: request)
			}
			
			@discardableResult
			public func data<E: Encodable>(
				for request: Request<Void, E>
			) async throws -> Data {
				try await self.shared.data(for: request)
			}
		}
		
		return Self(
			acronyms: { try await session.data(for: Acronyms.get) },
			addAcronym: {
				guard let value = session.value.value else { fatalError() }
				return try await session.data(for: Acronyms.add($0, token: value))
			},
			deleteAcronym: {
				guard let value = session.value.value else { fatalError() }
				try await session.data(for: Acronyms.delete($0, token: value))
			},
			editAcronym: {
				guard let value = session.value.value else { fatalError() }
				return try await session.data(for: Acronyms.edit($0, token: value))
			},
			firstAcronym: { try await session.data(for: Acronyms.first) },
			searchAcronyms: { try await session.data(for: Acronyms.search($0)) },
			sortedAcronyms: { try await session.data(for: Acronyms.sorted) },
			
			users: { try await session.data(for: Users.get) },
			addUser: { try await session.data(for: Users.add($0)) },
			deleteUser: { try await session.data(for: Users.delete($0)) },
			editUser: { try await session.data(for: Users.edit($0)) },
			firstUser: { try await session.data(for: Users.first) },
			searchUsers: { try await session.data(for: Users.search($0)) },
			sortedUsers: { try await session.data(for: Users.sorted) },
			
			login: {
				let token = try await session.data(for: Users.login($0, $1))
				session.value.value = token.value
			},
			isLoggedIn: { await session.isLoggedIn },
			logout: { await session.logout() },
			
			categories: { try await session.data(for: Categories.get) },
			addCategory: { try await session.data(for: Categories.add($0)) },
			deleteCategory: { try await session.data(for: Categories.delete($0)) },
			editCategory: { try await session.data(for: Categories.edit($0)) },
			firstCategory: { try await session.data(for: Categories.first) },
			searchCategories: { try await session.data(for: Categories.search($0)) },
			sortedCategories: { try await session.data(for: Categories.sorted) },
			
			acronymsByCategory: { try await session.data(for: Categories.acronymsBy($0)) },
			
			addAcronymByCategory: { try await session.data(for: Categories.add(acronym: $0, by: $1)) },
			deleteAcronymByCategory: { try await session.data(for: Categories.delete(acronym: $0, by: $1)) }
		)
	}()
}

public struct Token: Decodable {
	public let id: UUID
	public let user: User
	public let value: String
	
	public struct User: Decodable {
		public let id: UUID
	}
}

extension Token {
	static let mock = Token(id: UUID(), user: User(id: UUID()), value: "token")
}

@dynamicMemberLookup
@propertyWrapper
public final class Isolated<Value>: @unchecked Sendable {
	private var _value: Value {
	 willSet {
		self.lock.lock()
		defer { self.lock.unlock() }
		self.willSet(self._value, newValue)
	 }
	 didSet {
		self.lock.lock()
		defer { self.lock.unlock() }
		self.didSet(oldValue, self._value)
	 }
	}
	private let lock = NSRecursiveLock()
	let willSet: @Sendable (Value, Value) -> Void
	let didSet: @Sendable (Value, Value) -> Void

	public init(
	 _ value: Value,
	 willSet: @escaping @Sendable (Value, Value) -> Void = { _, _ in },
	 didSet: @escaping @Sendable (Value, Value) -> Void = { _, _ in }
	) {
	 self._value = value
	 self.willSet = willSet
	 self.didSet = didSet
	}

	public convenience init(wrappedValue: Value) {
	 self.init(wrappedValue)
	}

	public var value: Value {
	 _read {
		self.lock.lock()
		defer { self.lock.unlock() }
		yield self._value
	 }
	 _modify {
		self.lock.lock()
		defer { self.lock.unlock() }
		yield &self._value
	 }
	}

	public var wrappedValue: Value {
	 _read {
		self.lock.lock()
		defer { self.lock.unlock() }
		yield self._value
	 }
	 _modify {
		self.lock.lock()
		defer { self.lock.unlock() }
		yield &self._value
	 }
	}

	public var projectedValue: Isolated<Value> {
	 self
	}

	public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Subject {
	 _read {
		self.lock.lock()
		defer { self.lock.unlock() }
		yield self._value[keyPath: keyPath]
	 }
	 _modify {
		self.lock.lock()
		defer { self.lock.unlock() }
		yield &self._value[keyPath: keyPath]
	 }
	}

	public func withExclusiveAccess<T: Sendable>(
	 _ operation: @Sendable (inout Value) throws -> T
	) rethrows -> T {
	 self.lock.lock()
	 defer { self.lock.unlock() }
	 return try operation(&self._value)
	}
}
