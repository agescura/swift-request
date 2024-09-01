import Foundation

public struct Query {
	public let name: String
	public let value: String?
	
	public init(
		name: String,
		value: String? = nil
	) {
		self.name = name
		self.value = value
	}
}
