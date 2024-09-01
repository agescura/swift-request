import ApiClient
import ComposableArchitecture
import Models
import Foundation
import SwiftUI

@Reducer
public struct AcronymFeature {
	public init() {}
	@ObservableState
	public struct State: Equatable {
		public var id: UUID
		public var long: String
		public var short: String
		public var userID: UUID? = nil
		public var users: [User]
		
		public init(
			acronym: Acronym? = nil,
			users: [User] = []
		) {
			@Dependency(\.uuid) var uuid
			self.id = acronym?.id ?? uuid()
			self.short = acronym?.short ?? ""
			self.long = acronym?.long ?? ""
			self.userID = acronym?.user.id ?? nil
			self.users = users
		}
		
		public var acronym: Acronym? {
			guard let userID = self.userID
			else { return nil }
			return Acronym(
				id: self.id,
				short: self.short,
				long: self.long,
				userID: userID
			)
		}
	}
	public enum Action: ViewAction, Equatable {
		case longChanged(String)
		case shortChanged(String)
		case userIDChanged(UUID?)
		case usersResponse([User])
		case view(View)
		
		public enum View: Equatable {
			case onAppear
		}
	}
	@Dependency(\.apiClient) var apiClient
	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
				case let .longChanged(long):
					state.long = long
					return .none
				case let .shortChanged(short):
					state.short = short
					return .none
				case let .userIDChanged(userID):
					state.userID = userID
					return .none
				case let .usersResponse(users):
					state.users = users
					return .none
				case let .view(viewAction):
					switch viewAction {
						case .onAppear:
							return .run { send in
								try await send(.usersResponse(apiClient.users()))
							}
					}
			}
		}
	}
}

@ViewAction(for: AcronymFeature.self)
public struct AcronymView: View {
	@Bindable public var store: StoreOf<AcronymFeature>
	public init(
		store: StoreOf<AcronymFeature>
	) {
		self.store = store
	}
	
	public var body: some View {
		Form {
			Section(header: Text("Short")) {
				TextField("Short", text: $store.short.sending(\.shortChanged))
			}
			.textCase(nil)
			Section(header: Text("Long")) {
				TextField("Long", text: $store.long.sending(\.longChanged))
			}
			Section(header: Text("User")) {
				Picker(
					selection: $store.userID.sending(\.userIDChanged), label: Text("Users")) {
					Text("None")
						.tag(UUID?.none)
					ForEach(
						self.store.users,
						id: \.id
					) { user in
						Text(user.username)
							.tag(Optional(user.id))
					}
				}
				.pickerStyle(.navigationLink)
			}
		}
		.task { send(.onAppear) }
	}
}

#Preview {
	NavigationStack {
		AcronymView(
			store: Store(
				initialState: AcronymFeature.State(),
				reducer: { AcronymFeature() }
			) {
				$0.apiClient.users = {
					[
						.mock(UUID(uuidString: "00000000-0000-0000-0000-000000000000")!),
						.mock(UUID(uuidString: "00000000-0000-0000-0000-000000000001")!),
						.mock(UUID(uuidString: "00000000-0000-0000-0000-000000000002")!)
					]
				}
			}
		)
	}
}
