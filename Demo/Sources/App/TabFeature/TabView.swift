import ComposableArchitecture
import Foundation
import HomeFeature
import Models
import ListFeature
import LoginFeature
import SearchFeature
import SwiftUI

@Reducer
public struct TabFeature {
	public init() {}
	@ObservableState
	public struct State: Equatable {
		public var list: ListFeature.State
		@Presents public var login: LoginFeature.State?
		public var home: HomeFeature.State
		public var search: SearchFeature.State
		public var selectedTab: Tab
		public init(
			list: ListFeature.State = ListFeature.State(),
			login: LoginFeature.State? = LoginFeature.State(),
			home: HomeFeature.State = HomeFeature.State(),
			search: SearchFeature.State = SearchFeature.State(),
			selectedTab: Tab = .home
		) {
			self.list = list
			self.login = login
			self.home = home
			self.search = search
			self.selectedTab = selectedTab
		}
	}
	public enum Action: Equatable {
		case list(ListFeature.Action)
		case login(PresentationAction<LoginFeature.Action>)
		case home(HomeFeature.Action)
		case search(SearchFeature.Action)
		case tabChanged(Tab)
	}
	public var body: some ReducerOf<Self> {
		Scope(state: \.list, action: \.list) {
			ListFeature()
		}
		Scope(state: \.home, action: \.home) {
			HomeFeature()
		}
		Scope(state: \.search, action: \.search) {
			SearchFeature()
		}
		Reduce { state, action in
			switch action {
				case .login(.presented(.delegate(.authenticated))):
					state.login = nil
					return .none
				case let .tabChanged(tab):
					state.selectedTab = tab
					return .none
				case .list, .login, .home, .search:
					return .none
			}
		}
		.ifLet(\.$login, action: \.login) {
			LoginFeature()
		}
	}
}

public struct TabView: View {
	@Bindable public var store: StoreOf<TabFeature>
	public init(
		store: StoreOf<TabFeature>
	) {
		self.store = store
	}
	public var body: some View {
		SwiftUI.TabView(
			selection: $store.selectedTab.sending(\.tabChanged)
		) {
			ListView(
				store: store.scope(
					state: \.list,
					action: \.list
				)
			)
			.tabItem {
				Image(systemName: "list.bullet")
				Text("List")
			}
			.tag(Tab.list)
			
			HomeView(
				store: store.scope(
					state: \.home,
					action: \.home
				)
			)
			.tabItem {
				Image(systemName: "house")
				Text("Home")
			}
			.tag(Tab.home)
			
			SearchView(
				store: store.scope(
					state: \.search,
					action: \.search
				)
			)
			.tabItem {
				Image(systemName: "magnifyingglass")
				Text("Search")
			}
			.tag(Tab.search)
		}
		.sheet(
			item: $store.scope(
				state: \.login,
				action: \.login
			)
		) { store in
			LoginView(store: store)
				.interactiveDismissDisabled()
		}
	}
}

#Preview {
	TabView(
		store: Store(
			initialState: TabFeature.State()
		) {
			TabFeature()
		}
	)
}
