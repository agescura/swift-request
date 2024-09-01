import Foundation

public struct RequestBase {
	public var scheme: HTTPScheme
	public var host: String
	public var port: Int?
	public var uri: String
	public var queryItems: [Query]
	public var method: HTTPMethod
	public var headers: [String: String]
	public var encoder: JSONEncoder
	public var decoder: JSONDecoder
	public var cachePolicy: URLRequest.CachePolicy
	public var timeoutInterval: TimeInterval
	public var mainDocumentURL: URL?
	public var networkServiceType: ServiceType
	public var allowsCellularAccess: Bool
	public var allowsExpensiveNetworkAccess: Bool
	public var allowsConstrainedNetworkAccess: Bool
	public var assumesHTTP3Capable: Bool
	public var attribution: Attribution
	public var requiresDNSSECValidation: Bool
	// httpBodyStream
	public var httpShouldHandleCookies: Bool
	public var httpShouldUsePipelining: Bool
	
	public init(
		scheme: HTTPScheme = .https,
		host: String,
		port: Int? = nil,
		uri: String,
		queryItems: [Query] = [],
		method: HTTPMethod = .get,
		headers: [String: String] = [:],
		encoder: JSONEncoder = JSONEncoder(),
		decoder: JSONDecoder = JSONDecoder(),
		cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
		timeoutInterval: TimeInterval = 60.0,
		mainDocumentURL: URL? = nil,
		networkServiceType: ServiceType = .default,
		allowsCellularAccess: Bool = true,
		allowsExpensiveNetworkAccess: Bool = true,
		allowsConstrainedNetworkAccess: Bool = true,
		assumesHTTP3Capable: Bool = false,
		attribution: Attribution = .developer,
		requiresDNSSECValidation: Bool = false,
		// httpBodyStream
		httpShouldHandleCookies: Bool = true,
		httpShouldUsePipelining: Bool = false
	) {
		self.scheme = scheme
		self.host = host
		self.port = port
		self.uri = uri
		self.queryItems = queryItems
		self.method = method
		self.headers = headers
		self.encoder = encoder
		self.decoder = decoder
		self.cachePolicy = cachePolicy
		self.timeoutInterval = timeoutInterval
		self.mainDocumentURL = mainDocumentURL
		self.networkServiceType = networkServiceType
		self.allowsCellularAccess = allowsCellularAccess
		self.allowsExpensiveNetworkAccess = allowsExpensiveNetworkAccess
		self.allowsConstrainedNetworkAccess = allowsConstrainedNetworkAccess
		self.assumesHTTP3Capable = assumesHTTP3Capable
		self.attribution = attribution
		self.requiresDNSSECValidation = requiresDNSSECValidation
		// httpBodyStream
		self.httpShouldHandleCookies = httpShouldHandleCookies
		self.httpShouldUsePipelining = httpShouldUsePipelining
	}
}
