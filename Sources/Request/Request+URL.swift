import Foundation

extension Request {
	public init?(
		url: URL
	) {
		guard
			let scheme = url.scheme,
			let host = url.host,
			let port = url.port
		else { return nil }
		
		self.init(
			scheme: HTTPScheme(rawValue: scheme) ?? .https,
			host: host,
			port: port,
			uri: url.path
		)
	}
}
