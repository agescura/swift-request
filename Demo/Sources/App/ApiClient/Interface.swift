import Dependencies
import DependenciesMacros
import Foundation
import Models

extension DependencyValues {
	public var apiClient: ApiClient {
		get { self[ApiClient.self] }
		set { self[ApiClient.self] = newValue }
	}
}

@DependencyClient
public struct ApiClient {
	public var acronyms: () async throws -> [Acronym]
	public var addAcronym: (Acronym) async throws -> Acronym
	public var deleteAcronym: (Acronym) async throws -> Void
	public var editAcronym: (Acronym) async throws -> Acronym
	public var firstAcronym: () async throws -> Acronym?
	public var searchAcronyms: (String) async throws -> [Acronym]
	public var sortedAcronyms: () async throws -> [Acronym]
	
	public var users: () async throws -> [User]
	public var addUser: (User) async throws -> User
	public var deleteUser: (User) async throws -> Void
	public var editUser: (User) async throws -> User
	public var firstUser: () async throws -> User?
	public var searchUsers: (String) async throws -> [User]
	public var sortedUsers: () async throws -> [User]
	
	public var login: (String, String) async throws -> Void
	public var isLoggedIn: () async throws -> Bool
	public var logout: () async throws -> Void
	
	public var categories: () async throws -> [Models.Category]
	public var addCategory: (Models.Category) async throws -> Models.Category
	public var deleteCategory: (Models.Category) async throws -> Void
	public var editCategory: (Models.Category) async throws -> Models.Category
	public var firstCategory: () async throws -> Models.Category?
	public var searchCategories: (String) async throws -> [Models.Category]
	public var sortedCategories: () async throws -> [Models.Category]
	
	public var acronymsByCategory: (Models.Category) async throws -> [Acronym]
	public var addAcronymByCategory: (Acronym, Models.Category) async throws -> Void
	public var deleteAcronymByCategory: (Acronym, Models.Category) async throws -> Void
}
