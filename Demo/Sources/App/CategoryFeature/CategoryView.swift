import ApiClient
import ComposableArchitecture
import DesignSystem
import Models
import Foundation
import SwiftUI

@Reducer
public struct CategoryFeature {
	public init() {}
	@ObservableState
	public struct State: Equatable {
		public var category: Models.Category
		public var acronyms: [Acronym]
		public var acronymsByCategory: [Acronym]
		
		public init(
			category: Models.Category = .new,
			acronyms: [Acronym] = [],
			acronymsByCategory: [Acronym] = []
		) {
			self.category = category
			self.acronyms = acronyms
			self.acronymsByCategory = acronymsByCategory
		}
	}
	public enum Action: BindableAction, ViewAction, Equatable {
		case acronymsByCategoryResponse([Acronym])
		case acronymsResponse([Acronym])
		case binding(BindingAction<State>)
		case view(View)
		
		public enum View: Equatable {
			case addAcronymButtonTapped(Acronym)
			case deleteAcronym(IndexSet)
			case onAppear
		}
	}
	@Dependency(\.apiClient) var apiClient
	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
				case let .acronymsByCategoryResponse(acronymsByCategory):
					state.acronymsByCategory = acronymsByCategory
					return .none
				case let .acronymsResponse(acronyms):
					state.acronyms = acronyms
					return .none
				case .binding:
					return .none
				case let .view(viewAction):
					switch viewAction {
						case let .addAcronymButtonTapped(acronym):
							return .run { [category = state.category] send in
								_ = try await apiClient.addAcronymByCategory(acronym, category)
								await send(.view(.onAppear))
							}
						case let .deleteAcronym(indexSet):
							return .run { [category = state.category, acronymsByCategory = state.acronymsByCategory] send in
								for index in indexSet {
									let acronym = acronymsByCategory[index]
									_ = try await apiClient.deleteAcronymByCategory(acronym, category)
									await send(.view(.onAppear))
								}
							}
						case .onAppear:
							return .run { [category = state.category] send in
								var acronyms = Set(try await apiClient.acronyms())
								let acronymsByCategory = try await apiClient.acronymsByCategory(category)
								acronyms.subtract(Set(acronymsByCategory))
								await send(.acronymsResponse(Array(acronyms)))
								await send(.acronymsByCategoryResponse(acronymsByCategory))
							} catch: { _, _ in }
					}
			}
		}
	}
}

@ViewAction(for: CategoryFeature.self)
public struct CategoryView: View {
	@Bindable public var store: StoreOf<CategoryFeature>
	public init(
		store: StoreOf<CategoryFeature>
	) {
		self.store = store
	}
	public var body: some View {
		Form {
			Section(header: Text("Name")) {
				TextField("Name", text: $store.category.name)
			}
			.textCase(nil)
			Section(
				header: HStack {
					Text("Acronyms")
					Spacer()
					Menu(systemName: "plus") {
						ForEach(store.acronyms, id: \.self) { acronym in
							Button(acronym.short) { send(.addAcronymButtonTapped(acronym)) }
						}
					}
					.disabled(store.acronyms.isEmpty)
				}
			) {
				if store.acronymsByCategory.isEmpty {
					Text("No tienes acronyms")
				} else {
					ForEach(store.acronymsByCategory, id: \.self) { acronym in
						Text(acronym.short)
					}
					.onDelete { indexSet in
						send(.deleteAcronym(indexSet))
					}
				}
			}
		}
		.onAppear { send(.onAppear) }
	}
}
