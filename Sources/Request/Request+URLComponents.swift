import Foundation

extension Request {
	public init?(
		urlComponents: URLComponents
	) {
		guard
			let scheme = urlComponents.scheme,
			let host = urlComponents.host,
			let port = urlComponents.port,
			let queryItems = urlComponents.queryItems
		else { return nil }
		
		self.init(
			scheme: HTTPScheme(rawValue: scheme) ?? .https,
			host: host,
			port: port,
			uri: urlComponents.path,
			queryItems: queryItems.map { Query(name: $0.name, value: $0.value) }
		)
	}
}
