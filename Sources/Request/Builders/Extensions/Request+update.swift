import Foundation

extension Request {
	func update(
		uri: Uri? = nil,
		method: Method? = nil
	) -> Self {
		var request = self
		if let uri {
			request.uri = request.uri + uri.value
		}
		if let method {
			request.method = method.value
		}
		return request
	}
}
