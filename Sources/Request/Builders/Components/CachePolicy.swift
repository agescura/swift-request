import Foundation

public struct CachePolicy {
	let value: URLRequest.CachePolicy
	
	public init(
		_ value: URLRequest.CachePolicy
	) {
		self.value = value
	}
}
