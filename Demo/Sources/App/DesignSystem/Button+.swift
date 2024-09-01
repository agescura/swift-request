import SwiftUI

extension Button where Label == Image {
	public init(
		systemName: String,
		action: @escaping () -> Void
	) {
		self.init(
			action: action,
			label: { Image(systemName: systemName) }
		)
	}
}
