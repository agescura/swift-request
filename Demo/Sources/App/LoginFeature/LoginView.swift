import ApiClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct LoginFeature {
	public init() {}
	@ObservableState
	public struct State: Equatable {
		public var username: String = "agescura"
		public var password: String = "password"
		
		public init() {}
	}
	public enum Action: BindableAction, ViewAction, Equatable {
		case binding(BindingAction<State>)
		case delegate(Delegate)
		case view(View)
		
		public enum Delegate: Equatable {
			case authenticated
		}
		public enum View: Equatable {
			case loginButtonTapped
		}
	}
	@Dependency(\.apiClient.login) var login
	public var body: some ReducerOf<Self> {
		BindingReducer()
		Reduce { state, action in
			switch action {
				case .binding:
					return .none
				case .delegate:
					return .none
				case .view(.loginButtonTapped):
					return .run { [username = state.username, password = state.password] send in
						try await self.login(username, password)
						await send(.delegate(.authenticated))
					}
			}
		}
	}
}

@ViewAction(for: LoginFeature.self)
public struct LoginView: View {
	@Bindable public var store: StoreOf<LoginFeature>
	public init(
		store: StoreOf<LoginFeature>
	) {
		self.store = store
	}
	public var body: some View {
		VStack {
			TextField("Username", text: $store.username)
			TextField("Password", text: $store.password)
			Button("Login") { send(.loginButtonTapped) }
		}
		.padding()
	}
}

#Preview {
	LoginView(
		store: Store(
			initialState: LoginFeature.State(),
			reducer: { LoginFeature() }
		)
	)
}
