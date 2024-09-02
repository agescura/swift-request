import Foundation
import Models
import Request

extension Acronym /*: EncodableMappable*/ {
//	public static func map(_ acronym: Acronym) -> AcronymData {
//		AcronymData(acronym: acronym)
//	}
//
	public struct AcronymData: Encodable {
		let id: UUID
		let long: String
		let short: String
		let userID: UUID
		
		public init(acronym: Acronym) {
			self.id = acronym.id
			self.long = acronym.long
			self.short = acronym.short
			self.userID = acronym.user.id
		}
	}
}

extension Acronym {
	convenience init(dto: AcronymData) {
		self.init(
			id: dto.id,
			short: dto.short,
			long: dto.long,
			userID: dto.userID
		)
	}
	
	var dto: AcronymData {
		AcronymData(acronym: self)
	}
}

@RequestBuilder
var baseRequest: RequestBase {
	Scheme(.http)
	Host("localhost")
	Port(8080)
	Uri("api")
	Header(.contentType(.application(.json)))
}

struct Acronyms {
	@RequestBuilder
	static private var base: RequestBase {
		baseRequest
		Uri("acronyms")
	}
	
	@RequestBuilder
	static var get: RequestCodable<[Acronym]> {
		base
	}
	
	@RequestBuilder
	static var first: RequestCodable<Acronym> {
		base
		Uri("first")
	}
	
	@RequestBuilder
	static var sorted: RequestCodable<[Acronym]> {
		base
		Uri("sorted")
	}
	
	@RequestBuilder
	static func search(_ q: String) -> RequestCodable<[Acronym]> {
		base
		Uri("search")
		Query(name: "term", value: q)
	}
	
	@RequestBuilder
	static func add(_ acronym: Acronym) -> Request<Acronym, Acronym.AcronymData> {
		base
		Method(.post)
		Body(acronym.dto)
		Authorization(.bearer)
	}
	
	@RequestBuilder
	static func edit(_ acronym: Acronym) -> Request<Acronym, Acronym.AcronymData> {
		base
		Uri(acronym.id)
		Method(.put)
		Body(acronym.dto)
		Authorization(.bearer)
	}
	
	@RequestBuilder
	static func delete(_ acronym: Acronym) -> RequestPlain {
		base
		Uri(acronym.id)
		Method(.delete)
		Authorization(.bearer)
	}
}

struct Users {
	@RequestBuilder
	static private var base: RequestBase {
		baseRequest
		Uri("users")
	}
	
	@RequestBuilder
	static var get: RequestCodable<[User]> {
		base
	}
	
	@RequestBuilder
	static var first: RequestCodable<User> {
		base
		Uri("first")
	}
	
	@RequestBuilder
	static var sorted: RequestCodable<[User]> {
		base
		Uri("sorted")
	}
	
	@RequestBuilder
	static func delete(_ user: User) -> RequestPlain {
		base
		Uri(user.id)
		Method(.delete)
	}
	
	@RequestBuilder
	static func add(_ user: User) -> RequestCodable<User> {
		base
		Method(.post)
		Body(user)
	}
	
	@RequestBuilder
	static func edit(_ user: User) -> RequestCodable<User> {
		base
		Method(.put)
		Body(user)
	}
	
	@RequestBuilder
	static func search(_ q: String) -> RequestCodable<[User]> {
		base
		Uri("search")
		Query(name: "term", value: q)
	}
	
	@RequestBuilder
	static func login(_ username: String, _ password: String) -> RequestDecodable<Token> {
		base
		Uri("login")
		Method(.post)
		Header(.authorization(.basic(username, password)))
	}
}

struct Categories {
	@RequestBuilder
	static private var base: RequestBase {
		baseRequest
		Uri("categories")
	}
	
	@RequestBuilder
	static var get: RequestCodable<[Models.Category]> {
		base
	}
	
	@RequestBuilder
	static var first: RequestCodable<Models.Category> {
		base
		Uri("first")
	}
	
	@RequestBuilder
	static var sorted: RequestCodable<[Models.Category]> {
		base
		Uri("sorted")
	}
	
	@RequestBuilder
	static func search(_ q: String) -> RequestCodable<[Models.Category]> {
		base
		Uri("search")
		Method(.get)
		Query(name: "term", value: q)
	}
	
	@RequestBuilder
	static func delete(_ category: Models.Category) -> RequestPlain {
		base
		Uri(category.id)
		Method(.delete)
	}
	
	@RequestBuilder
	static func add(_ category: Models.Category) -> RequestCodable<Models.Category> {
		base
		Method(.post)
		Body(category)
	}
	
	@RequestBuilder
	static func edit(_ category: Models.Category) -> RequestCodable<Models.Category> {
		base
		Method(.put)
		Body(category)
	}
	
	@RequestBuilder
	static func acronymsBy(_ category: Models.Category) -> RequestCodable<[Acronym]> {
		base
		Uri {
			category.id.uuidString
			"acronyms"
		}
	}
	
	@RequestBuilder
	static func add(acronym: Acronym, by category: Models.Category) -> RequestPlain {
		base
		Uri {
			category.id.uuidString
			"acronyms"
			acronym.id.uuidString
		}
		Method(.post)
	}
	
	@RequestBuilder
	static func delete(acronym: Acronym, by category: Models.Category) -> RequestPlain {
		base
		Uri {
			category.id.uuidString
			"acronyms"
			acronym.id.uuidString
		}
		Method(.delete)
	}
}
