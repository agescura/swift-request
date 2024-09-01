import SwiftUI

extension Menu where Label == Image {
	public init(
		systemName: String,
		content: @escaping () -> Content
	) {
		self.init(
			content: content,
			label: { Image(systemName: systemName) }
		)
	}
}
