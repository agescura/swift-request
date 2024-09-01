import ComposableArchitecture
import Models
import Foundation
import SwiftUI

@Reducer
public struct UserFeature {
	public init() {}
	@ObservableState
	public struct State: Equatable {
		public var user: User
		
		public init(
			user: User = .new
		) {
			self.user = user
		}
	}
	public enum Action: BindableAction, Equatable {
		case binding(BindingAction<State>)
	}
	public var body: some ReducerOf<Self> {
		EmptyReducer()
	}
}

extension StoreOf<UserFeature> {
	var password: String {
		get { state.user.password ?? "" }
		set { send(.binding(.set(\.user.password, newValue))) }
	}
}

public struct UserView: View {
	@Bindable public var store: StoreOf<UserFeature>
	public init(
		store: StoreOf<UserFeature>
	) {
		self.store = store
	}
	public var body: some View {
		Form {
			Section(header: Text("Name")) {
				TextField("Name", text: $store.user.name)
			}
			.textCase(nil)
			Section(header: Text("Username")) {
				TextField("Username", text: $store.user.username)
			}
			Section(header: Text("Password")) {
				TextField("Password", text: $store.password)
			}
		}
	}
}
