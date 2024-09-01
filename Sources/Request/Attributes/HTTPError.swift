import Foundation

public struct HTTPError: Error {
	let data: Data
	let response: HTTPURLResponse
	
	public init(
		data: Data,
		response: HTTPURLResponse
	) {
		self.data = data
		self.response = response
	}
}
