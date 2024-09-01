import Foundation

public struct Method {
	let value: HTTPMethod
	
	public init(
		_ value: HTTPMethod
	) {
		self.value = value
	}
}
