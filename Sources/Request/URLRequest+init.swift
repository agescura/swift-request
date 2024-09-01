import Foundation

extension URLRequest {
	public init<D, E: Encodable>(_ request: Request<D, E>) throws {
		var urlRequest = URLRequest(url: build(request: request).url!)
		urlRequest.httpMethod = request.method.rawValue
		switch request.httpBody {
			case let .encodable(value):
				urlRequest.httpBody = try request.encoder.encode(value)
			case let .data(httpBody):
				urlRequest.httpBody = httpBody
			case .none:
				urlRequest.httpBody = nil
		}
		request.headers.forEach { header in
			urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
		}
		urlRequest.cachePolicy = request.cachePolicy
		urlRequest.timeoutInterval = request.timeoutInterval
		urlRequest.mainDocumentURL = request.mainDocumentURL
		urlRequest.networkServiceType = request.networkServiceType.rawValue
		urlRequest.allowsCellularAccess = request.allowsCellularAccess
		urlRequest.allowsExpensiveNetworkAccess = request.allowsExpensiveNetworkAccess
		urlRequest.allowsConstrainedNetworkAccess = request.allowsConstrainedNetworkAccess
		if #available(iOS 14.5, macOS 11.3, tvOS 14.5, watchOS 7.4, *) {
			urlRequest.assumesHTTP3Capable = request.assumesHTTP3Capable
		}
		urlRequest.httpShouldHandleCookies = request.httpShouldHandleCookies
		if #available(iOS 15, macOS 12, tvOS 15, watchOS 8.0, *) {
			urlRequest.attribution = request.attribution.rawValue
		}
		if #available(iOS 16.1, macOS 13, tvOS 16.1, watchOS 9.1, *) {
			urlRequest.requiresDNSSECValidation = request.requiresDNSSECValidation
		}
		urlRequest.httpShouldHandleCookies = request.httpShouldHandleCookies
		urlRequest.httpShouldUsePipelining = request.httpShouldUsePipelining
		self = urlRequest
	}
}

fileprivate func build<D, E: Encodable>(
	request: Request<D, E>
) -> URLComponents {
	var components = URLComponents()
	components.scheme = request.scheme.rawValue
	components.host = request.host
	components.port = request.port
	components.path = request.uri
	if !request.queryItems.isEmpty {
		components.queryItems = request.queryItems.map(URLQueryItem.init)
	}
	return components
}

extension URLQueryItem {
	init(_ query: Query) {
		self.init(name: query.name, value: query.value)
	}
}

extension ServiceType {
	var rawValue: URLRequest.NetworkServiceType {
		switch self {
			case .default:
				return .default
			case .video:
				return .video
			case .background:
				return .background
			case .voice:
				return .voice
			case .responsiveData:
				return .responsiveData
			case .avStreaming:
				return .avStreaming
			case .responsiveAV:
				return .responsiveAV
			case .callSignaling:
				return .callSignaling
		}
	}
}

extension Attribution {
	@available(iOS 15, tvOS 15, watchOS 8.0, *)
	var rawValue: URLRequest.Attribution {
		switch self {
			case .developer:
				return .developer
			case .user:
				return .user
		}
	}
}
