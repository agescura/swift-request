import Foundation

public struct Authorization {
	let value: Strategy
	
	public init(
		_ value: Strategy
	) {
		self.value = value
	}
	
	public enum Strategy {
		case bearer
	}
}
