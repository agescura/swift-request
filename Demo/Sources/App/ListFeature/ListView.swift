import AcronymFeature
import ApiClient
import CategoryFeature
import ComposableArchitecture
import Foundation
import Models
import SwiftUI
import UserFeature

@Reducer
public struct ListFeature {
	public init() {}
	@Reducer(state: .equatable, action: .equatable)
	public enum Destination {
		case addAcronym(AcronymFeature)
		case addCategory(CategoryFeature)
		case addUser(UserFeature)
		case alert(AlertState<Alert>)
		
		public enum Alert: Equatable { case ok }
	}
	@Reducer(state: .equatable, action: .equatable)
	public enum Path {
		case editAcronym(AcronymFeature)
		case editCategory(CategoryFeature)
		case editUser(UserFeature)
	}
	@ObservableState
	public struct State: Equatable {
		public var acronyms: [Acronym]
		public var categories: [Models.Category]
		@Presents var destination: Destination.State?
		public var path: StackState<Path.State>
		public var sorted: Sorted
		public var users: [User]
		
		public enum Sorted: String {
			case `default`
			case sorted
		}
		
		public init(
			acronyms: [Acronym] = [],
			categories: [Models.Category] = [],
			destination: Destination.State? = nil,
			path: StackState<Path.State> = StackState<Path.State>(),
			sorted: Sorted = .default,
			users: [User] = []
		) {
			self.acronyms = acronyms
			self.categories = categories
			self.destination = destination
			self.path = path
			self.sorted = sorted
			self.users = users
		}
	}
	public enum Action: ViewAction, Equatable {
		case acronymsResponse([Acronym])
		case acronymsError(String)
		case categoriesResponse([Models.Category])
		case destination(PresentationAction<Destination.Action>)
		case path(StackActionOf<Path>)
		case usersResponse([User])
		case view(View)
		
		public enum View: Equatable {
			case addAcronymButtonTapped
			case addCategoryButtonTapped
			case addUserButtonTapped
			case backButtonTapped
			case cancelButtonTapped
			case confirmAddAcronymButtonTapped
			case confirmAddCategoryButtonTapped
			case confirmAddUserButtonTapped
			case deleteAcronyms(IndexSet)
			case deleteCategory(IndexSet)
			case deleteUsers(IndexSet)
			case onAppear
			case sortedAcronymsButtonTapped
			case updateAcronymButtonTapped
			case updateCategoryButtonTapped
			case updateUserButtonTapped
		}
	}
	@Dependency(\.apiClient) var apiClient
	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
				case let .acronymsResponse(acronyms):
					state.acronyms = acronyms
					return .none
				case let .acronymsError(error):
					state.destination = .alert(.error(error))
					return .none
				case let .categoriesResponse(categories):
					state.categories = categories
					return .none
				case let .destination(.presented(destinationAction)):
					switch destinationAction {
						case .alert, .addAcronym, .addCategory, .addUser:
							return .none
					}
				case .destination(.dismiss):
					return .none
				case .path:
					return .none
				case let .usersResponse(users):
					state.users = users
					return .none
				case let .view(viewAction):
					switch viewAction {
						case .addAcronymButtonTapped:
							state.destination = .addAcronym(AcronymFeature.State())
							return .none
						case .addCategoryButtonTapped:
							state.destination = .addCategory(CategoryFeature.State(category: .new))
							return .none
						case .addUserButtonTapped:
							state.destination = .addUser(UserFeature.State(user: .new))
							return .none
						case .backButtonTapped:
							_ = state.path.popLast()
							return .run { send in
								try await send(.acronymsResponse(apiClient.acronyms()))
							}
						case .cancelButtonTapped:
							state.destination = nil
							return .none
						case .confirmAddAcronymButtonTapped:
							guard let acronym = state.destination?.addAcronym?.acronym
							else { return .none }
							state.destination = nil
							return .run { send in
								_ = try await apiClient.addAcronym(acronym)
								try await send(.acronymsResponse(apiClient.acronyms()))
							} catch: { error, send in
								await send(.acronymsError(error.localizedDescription))
							}
						case .confirmAddCategoryButtonTapped:
							guard let category = state.destination?.addCategory?.category
							else { return .none }
							state.destination = nil
							return .run { send in
								_ = try await apiClient.addCategory(category)
								try await send(.categoriesResponse(apiClient.categories()))
							}
						case .confirmAddUserButtonTapped:
							guard let user = state.destination?.addUser?.user
							else { return .none }
							state.destination = nil
							return .run { send in
								_ = try await apiClient.addUser(user)
								try await send(.usersResponse(apiClient.users()))
							}
						case let .deleteAcronyms(indexSet):
							return .run { [acronyms = state.acronyms] send in
								for index in indexSet {
									let acronym = acronyms[index]
									_ = try await apiClient.deleteAcronym(acronym)
									try await send(.acronymsResponse(apiClient.acronyms()))
								}
							}
						case let .deleteCategory(indexSet):
							return .run { [categories = state.categories] send in
								for index in indexSet {
									let category = categories[index]
									_ = try await apiClient.deleteCategory(category)
									try await send(.categoriesResponse(apiClient.categories()))
								}
							}
						case let .deleteUsers(indexSet):
							return .run { [users = state.users] send in
								for index in indexSet {
									let user = users[index]
									_ = try await apiClient.deleteUser(user)
									try await send(.usersResponse(apiClient.users()))
								}
							}
						case .onAppear:
							return .run { send in
								try await send(.acronymsResponse(apiClient.acronyms()))
								try await send(.usersResponse(apiClient.users()))
								try await send(.categoriesResponse(apiClient.categories()))
							}
						case .sortedAcronymsButtonTapped:
							switch state.sorted {
								case .default:
									state.sorted = .sorted
									return .run { send in
										try await send(.acronymsResponse(apiClient.acronyms()))
										try await send(.usersResponse(apiClient.users()))
									}
								case .sorted:
									state.sorted = .default
									return .run { send in
										try await send(.acronymsResponse(apiClient.sortedAcronyms()))
										try await send(.usersResponse(apiClient.sortedUsers()))
									}
							}
						case .updateAcronymButtonTapped:
							let path = state.path.popLast()
							guard let acronym = path?.editAcronym?.acronym
							else { return .none }
							return .run { send in
								_ = try await apiClient.editAcronym(acronym)
								try await send(.acronymsResponse(apiClient.acronyms()))
							}
						case .updateCategoryButtonTapped:
							let path = state.path.popLast()
							guard let category = path?.editCategory?.category
							else { return .none }
							return .run { send in
								_ = try await apiClient.editCategory(category)
								try await send(.categoriesResponse(apiClient.categories()))
							}
						case .updateUserButtonTapped:
							let path = state.path.popLast()
							guard let user = path?.editUser?.user
							else { return .none }
							return .run { send in
								_ = try await apiClient.editUser(user)
								try await send(.usersResponse(apiClient.users()))
							}
					}
			}
		}
		.ifLet(\.$destination, action: \.destination)
		.forEach(\.path, action: \.path)
	}
}

extension AlertState where Action == ListFeature.Destination.Alert {
	static func error(_ error: String) -> Self {
		Self {
			TextState("There was an error.")
		} actions: {
			ButtonState { TextState("OK") }
		} message: {
			TextState(error)
		}
	}
}

@ViewAction(for: ListFeature.self)
public struct ListView: View {
	@Bindable public var store: StoreOf<ListFeature>
	public init(
		store: StoreOf<ListFeature>
	) {
		self.store = store
	}
	public var body: some View {
		NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
			List {
				Section(header: Text("Create Object")) {
					Button("Acronym") {
						send(.addAcronymButtonTapped)
					}
					Button("Category") {
						send(.addCategoryButtonTapped)
					}
					Button("User") {
						send(.addUserButtonTapped)
					}
				}
				.textCase(nil)
				Section(header: Text("Acronyms")) {
					ForEach(store.acronyms, id: \.self) { acronym in
						NavigationLink(
							state: ListFeature.Path.State.editAcronym(AcronymFeature.State(acronym: acronym))
						) {
							HStack {
								Text(acronym.long)
								Text(acronym.short)
							}
						}
					}
					.onDelete { indexSet in
						send(.deleteAcronyms(indexSet))
					}
				}
				.textCase(nil)
				Section(header: Text("Categories")) {
					ForEach(store.categories, id: \.self) { category in
						NavigationLink(
							state: ListFeature.Path.State.editCategory(CategoryFeature.State(category: category))
						) {
							HStack {
								Text(category.name)
							}
						}
					}
					.onDelete { indexSet in
						send(.deleteCategory(indexSet))
					}
				}
				.textCase(nil)
				Section(header: Text("Users")) {
					ForEach(store.users, id: \.self) { user in
						NavigationLink(
							state: ListFeature.Path.State.editUser(UserFeature.State(user: user))
						) {
							HStack {
								Text(user.name)
								Text(user.username)
							}
						}
					}
					.onDelete { indexSet in
						send(.deleteUsers(indexSet))
					}
				}
				.textCase(nil)
			}
			.navigationTitle("Acronyms")
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button(store.sorted.rawValue.capitalized) {
						send(.sortedAcronymsButtonTapped)
					}
				}
			}
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
								Button("Update") { send(.updateAcronymButtonTapped) }
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
								Button("Update") { send(.updateCategoryButtonTapped) }
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
								Button("Update") { send(.updateUserButtonTapped) }
							}
						}
			}
		}
		.onAppear { send(.onAppear) }
		.alert(
			$store.scope(
				state: \.destination?.alert,
				action: \.destination.alert
			)
		)
//		.confirmationDialog(
//			$store.scope(
//				state: \.destination?.dialog,
//				action: \.destination.dialog
//			)
//		)
		.sheet(
			item: $store.scope(
				state: \.destination?.addAcronym,
				action: \.destination.addAcronym
			)
		) { store in
			NavigationStack {
				AcronymView(store: store)
					.navigationTitle("Add Acronym")
					.navigationBarTitleDisplayMode(.inline)
					.toolbar {
						ToolbarItem(placement: .confirmationAction) {
							Button("Save") {
								send(.confirmAddAcronymButtonTapped)
							}
						}
						ToolbarItem(placement: .cancellationAction) {
							Button("Cancel") {
								send(.cancelButtonTapped)
							}
						}
					}
			}
		}
		.sheet(
			item: $store.scope(
				state: \.destination?.addCategory,
				action: \.destination.addCategory
			)
		) { store in
			NavigationStack {
				CategoryView(store: store)
					.navigationTitle("Add Category")
					.navigationBarTitleDisplayMode(.inline)
					.toolbar {
						ToolbarItem(placement: .confirmationAction) {
							Button("Save") {
								send(.confirmAddCategoryButtonTapped)
							}
						}
						ToolbarItem(placement: .cancellationAction) {
							Button("Cancel") {
								send(.cancelButtonTapped)
							}
						}
					}
			}
		}
		.sheet(
			item: $store.scope(
				state: \.destination?.addUser,
				action: \.destination.addUser
			)
		) { store in
			NavigationStack {
				UserView(store: store)
					.navigationTitle("Add User")
					.navigationBarTitleDisplayMode(.inline)
					.toolbar {
						ToolbarItem(placement: .confirmationAction) {
							Button("Save") {
								send(.confirmAddUserButtonTapped)
							}
						}
						ToolbarItem(placement: .cancellationAction) {
							Button("Cancel") {
								send(.cancelButtonTapped)
							}
						}
					}
			}
		}
	}
}

#Preview {
	ListView(
		store: Store(
			initialState: ListFeature.State(),
			reducer: { ListFeature() }
		)
	)
}
