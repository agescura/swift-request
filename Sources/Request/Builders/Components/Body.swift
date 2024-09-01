import Foundation

public struct Body<E: Encodable> {
	let value: E
	
	public init(
		_ value: E
	) {
		self.value = value
	}
}
