import ComposableArchitecture
import TabFeature
import SwiftUI

@main
struct DemoApp: App {
	var body: some Scene {
		WindowGroup {
			TabView(
				store: Store(
					initialState: TabFeature.State()
				) {
					TabFeature()
						._printChanges()
				}
			)
		}
	}
}
