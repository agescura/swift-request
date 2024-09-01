import Dependencies
import Foundation
import XCTestDynamicOverlay

extension ApiClient: TestDependencyKey {
	public static let testValue = Self()
	public static let previewValue = Self(
		acronyms: { [] },
		addAcronym: { _ in .mock },
		deleteAcronym: { _ in },
		editAcronym: { _ in .mock },
		firstAcronym: { nil },
		searchAcronyms: { _ in [] },
		sortedAcronyms: { [] },
		
		users: { [] },
		addUser: { _ in .mock },
		deleteUser: { _ in },
		editUser: { _ in .mock },
		firstUser: { nil },
		searchUsers: { _ in [] },
		sortedUsers: { [] },
		
		login: { _, _ in },
		isLoggedIn: { false },
		logout: { },
		
		categories: { [] },
		addCategory: { _ in .mock },
		deleteCategory: { _ in },
		editCategory: { _ in .mock },
		firstCategory: { nil },
		searchCategories: { _ in [] },
		sortedCategories: { [] },
		
		acronymsByCategory: { _ in [] },
		addAcronymByCategory: { _, _ in },
		deleteAcronymByCategory: { _, _ in }
	)
}
