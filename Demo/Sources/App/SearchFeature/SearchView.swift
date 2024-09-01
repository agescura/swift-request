import ApiClient
import ComposableArchitecture
import Foundation
import Models
import SwiftUI

@Reducer
public struct SearchFeature {
	public init() {}
	@ObservableState
	public struct State: Equatable {
		public var acronyms: [Acronym]
		public var categories: [Models.Category]
		public var searchable: String
		public var users: [User]
		
		public init(
			acronyms: [Acronym] = [],
			categories: [Models.Category] = [],
			searchable: String = "",
			users: [User] = []
		) {
			self.acronyms = acronyms
			self.categories = categories
			self.searchable = searchable
			self.users = users
		}
	}
	public enum Action: Equatable {
		case acronymsResponse([Acronym])
		case categoriesResponse([Models.Category])
		case onAppear
		case onReturn(String)
		case usersResponse([User])
	}
	@Dependency(\.apiClient) var apiClient
	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
				case let .acronymsResponse(acronyms):
					state.acronyms = acronyms
					return .none
				case let .categoriesResponse(categories):
					state.categories = categories
					return .none
				case .onAppear:
					return .none
				case let .onReturn(searchable):
					guard searchable.count > 2 else { return .none }
					state.searchable = searchable
					return .merge(
						.run { send in
							try await send(.acronymsResponse(apiClient.searchAcronyms(searchable)))
						},
						.run { send in
							try await send(.categoriesResponse(apiClient.searchCategories(searchable)))
						},
						.run { send in
							try await send(.usersResponse(apiClient.searchUsers(searchable)))
						}
					)
				case let .usersResponse(users):
					state.users = users
					return .none
			}
		}
	}
}

public struct SearchView: View {
	@Bindable public var store: StoreOf<SearchFeature>
	public init(
		store: StoreOf<SearchFeature>
	) {
		self.store = store
	}
	public var body: some View {
		NavigationStack {
			List {
				Section(header: Text("Acronyms Results")) {
					ForEach(store.acronyms, id: \.self) { acronym in
						HStack {
							Text(acronym.long)
							Text(acronym.short)
						}
					}
				}
				Section(header: Text("Categories Results")) {
					ForEach(store.categories, id: \.self) { category in
						HStack {
							Text(category.name)
						}
					}
				}
				Section(header: Text("Users Results")) {
					ForEach(store.users, id: \.self) { user in
						HStack {
							Text(user.name)
							Text(user.username)
						}
					}
				}
			}
			.navigationTitle("Search Acronyms")
			.onAppear { store.send(.onAppear) }
			.searchable(text: $store.searchable.sending(\.onReturn))
		}
	}
}
