import AcronymFeature
import ApiClient
import CategoryFeature
import ComposableArchitecture
import Foundation
import Models
import UserFeature
import SwiftUI

@Reducer
public struct HomeFeature {
	public init() {}
	@Reducer(state: .equatable, action: .equatable)
	public enum Path {
		case editAcronym(AcronymFeature)
		case editCategory(CategoryFeature)
		case editUser(UserFeature)
	}
	@ObservableState
	public struct State: Equatable {
		public var firstAcronym: Acronym?
		public var firstCategory: Models.Category?
		public var firstUser: User?
		public var path: StackState<Path.State>
		
		public init(
			firstAcronym: Acronym? = nil,
			firstCategory: Models.Category? = nil,
			firstUser: User? = nil,
			path: StackState<Path.State> = StackState<Path.State>()
		) {
			self.firstAcronym = firstAcronym
			self.firstCategory = firstCategory
			self.firstUser = firstUser
			self.path = path
		}
	}
	public enum Action: ViewAction, Equatable {
		case firstAcronymResponse(Acronym?)
		case firstCategoryResponse(Models.Category?)
		case firstUserResponse(User?)
		case path(StackActionOf<Path>)
		case view(View)
		
		public enum View: Equatable {
			case backButtonTapped
			case onAppear
			case updatedAcronymButtonTapped
		}
	}
	@Dependency(\.apiClient) var apiClient
	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
				case let .firstAcronymResponse(acronym):
					state.firstAcronym = acronym
					return .none
				case let .firstCategoryResponse(category):
					state.firstCategory = category
					return .none
				case let .firstUserResponse(user):
					state.firstUser = user
					return .none
				case .path:
					return .none
				case let .view(viewAction):
					switch viewAction {
						case .backButtonTapped:
							_ = state.path.popLast()
							return .run { send in
								try await send(.firstAcronymResponse(apiClient.firstAcronym()))
							}
						case .onAppear:
							return .merge(
								.run { send in
									try await send(.firstAcronymResponse(apiClient.firstAcronym()))
								} catch: { _, send in
									await send(.firstAcronymResponse(nil))
								},
								.run { send in
									try await send(.firstCategoryResponse(apiClient.firstCategory()))
								} catch: { _, send in
									await send(.firstCategoryResponse(nil))
								},
								.run { send in
									try await send(.firstUserResponse(apiClient.firstUser()))
								} catch: { _, send in
									await send(.firstUserResponse(nil))
								}
							)
						case .updatedAcronymButtonTapped:
							let path = state.path.popLast()
							guard let acronym = path?.editAcronym?.acronym
							else { return .none }
							return .run { send in
								_ = try await apiClient.editAcronym(acronym)
								try await send(.firstAcronymResponse(apiClient.firstAcronym()))
							}
					}
			}
		}
		.forEach(\.path, action: \.path)
	}
}

@ViewAction(for: HomeFeature.self)
public struct HomeView: View {
	@Bindable public var store: StoreOf<HomeFeature>
	public init(
		store: StoreOf<HomeFeature>
	) {
		self.store = store
	}
	public var body: some View {
		NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
			Form {
				Section(
					header: Text("First Acronym")
				) {
					if let acronym = store.firstAcronym {
						NavigationLink(
							state: HomeFeature.Path.State.editAcronym(AcronymFeature.State(acronym: acronym))
						) {
							HStack {
								Text(acronym.long)
								Text(acronym.short)
							}
						}
					} else {
						Text("There is not acronyms, yet!")
					}
				}
				.textCase(nil)
				Section(
					header: Text("First Category")
				) {
					if let category = store.firstCategory {
						NavigationLink(
							state: HomeFeature.Path.State.editCategory(CategoryFeature.State(category: category))
						) {
							HStack {
								Text(category.name)
							}
						}
					} else {
						Text("There is not categories, yet!")
					}
				}
				.textCase(nil)
				Section(
					header: Text("First User")
				) {
					if let user = store.firstUser {
						NavigationLink(
							state: HomeFeature.Path.State.editUser(UserFeature.State(user: user))
						) {
							HStack {
								Text(user.name)
								Text(user.username)
							}
						}
					} else {
						Text("There is not users, yet!")
					}
				}
				.textCase(nil)
			}
			.navigationTitle("Home")
			.onAppear { send(.onAppear) }
		} destination: { store in
			switch store.case {
				case let .editAcronym(store):
					AcronymView(store: store)
						.navigationTitle("Edit Acronym")
						.navigationBarBackButtonHidden()
						.toolbar {
							ToolbarItem(placement: .cancellationAction) {
								Button("Back") { send(.backButtonTapped) }
							}
							ToolbarItem(placement: .confirmationAction) {
								Button("Update") { send(.updatedAcronymButtonTapped) }
							}
						}
				case let .editCategory(store):
					CategoryView(store: store)
						.navigationTitle("Edit Category")
						.navigationBarBackButtonHidden()
						.toolbar {
							ToolbarItem(placement: .cancellationAction) {
								Button("Back") { send(.backButtonTapped) }
							}
							ToolbarItem(placement: .confirmationAction) {
								Button("Update") { send(.updatedAcronymButtonTapped) }
							}
						}
				case let .editUser(store):
					UserView(store: store)
						.navigationTitle("Edit User")
						.navigationBarBackButtonHidden()
						.toolbar {
							ToolbarItem(placement: .cancellationAction) {
								Button("Back") { send(.backButtonTapped) }
							}
							ToolbarItem(placement: .confirmationAction) {
								Button("Update") { send(.updatedAcronymButtonTapped) }
							}
						}
			}
		}
	}
}

#Preview {
	HomeView(
		store: Store(
			initialState: HomeFeature.State(),
			reducer: { HomeFeature() }
		)
	)
}
