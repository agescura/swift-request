import Foundation

extension RequestBuilder {
	static public func buildBlock<D, E: Encodable>(
		_ host: Host,
		_ uri: Uri
	) -> Request<D, E> {
		Request(
			host: host.value,
			uri: uri.value
		)
	}
}

extension RequestBuilder {
	static public func buildBlock<D, E: Encodable>(
		_ request: Request<D, E>,
		_ method: Method
	) -> Request<D, E> {
		request
			.update(method: method)
	}
	
	static public func buildBlock<D, E: Encodable>(
		_ request: Request<D, E>,
		_ uri: Uri,
		_ method: Method
	) -> Request<D, E> {
		request
			.update(uri: uri, method: method)
	}
}

extension RequestBuilder {
	static public func buildBlock(
		_ scheme: Scheme,
		_ host: Host,
		_ port: Port,
		_ uri: Uri,
		_ header: Header
	) -> RequestBase {
		RequestBase(
			scheme: scheme.value,
			host: host.value,
			port: port.value,
			uri: uri.value,
			queryItems: [],
			headers: [header.key: header.value]
		)
	}
	
	static public func buildBlock(
		_ request: RequestBase,
		_ uri: Uri
	) -> RequestBase {
		RequestBase(
			scheme: request.scheme,
			host: request.host,
			port: request.port,
			uri: request.uri + uri.value,
			queryItems: request.queryItems,
			headers: request.headers
		)
	}
	
	static public func buildBlock<D, E: Encodable>(
		_ request: RequestBase
	) -> Request<D, E> {
		Request(
			scheme: request.scheme,
			host: request.host,
			port: request.port,
			uri: request.uri,
			queryItems: request.queryItems,
			headers: request.headers
		)
	}
	
	static public func buildBlock<D, E: Encodable>(
		_ request: RequestBase,
		_ uri: Uri
	) -> Request<D, E> {
		Request(
			scheme: request.scheme,
			host: request.host,
			port: request.port,
			uri: request.uri + uri.value,
			queryItems: request.queryItems,
			headers: request.headers
		)
	}
	
	static public func buildBlock<D, E: Encodable>(
		_ request: RequestBase,
		_ method: Method,
		_ body: Body<E>
	) -> Request<D, E> {
		Request(
			scheme: request.scheme,
			host: request.host,
			port: request.port,
			uri: request.uri,
			queryItems: request.queryItems,
			method: method.value,
			httpBody: .encodable(body.value),
			headers: request.headers
		)
	}
	
	static public func buildBlock<D, E: Encodable>(
		_ request: RequestBase,
		_ uri: Uri,
		_ method: Method
	) -> Request<D, E> {
		Request(
			scheme: request.scheme,
			host: request.host,
			port: request.port,
			uri: request.uri + uri.value,
			method: method.value,
			headers: request.headers
		)
	}
}


extension RequestBuilder {
	static public func buildBlock<D, E: Encodable>(
		_ scheme: Scheme,
		_ host: Host,
		_ port: Port,
		_ uri: Uri,
		_ method: Method,
		_ header: Header
	) -> Request<D, E> {
		Request(
			scheme: scheme.value,
			host: host.value,
			port: port.value,
			uri: uri.value,
			queryItems: [],
			method: method.value,
			headers: [header.key: header.value]
		)
	}
	
	static public func buildBlock<D, E: Encodable>(
		_ scheme: Scheme,
		_ host: Host,
		_ port: Port,
		_ uri: Uri
	) -> Request<D, E> {
		Request(
			scheme: scheme.value,
			host: host.value,
			port: port.value,
			uri: uri.value,
			queryItems: [],
			method: .get
		)
	}
}

extension RequestBuilder {
	static public func buildBlock<D, E: Encodable>(
		_ request: RequestBase,
		_ uri: Uri,
		_ query: Query
	) -> Request<D, E> {
		Request(
			scheme: request.scheme,
			host: request.host,
			port: request.port,
			uri: request.uri + uri.value,
			queryItems: [query],
			method: .get,
			headers: request.headers
		)
	}
	
	static public func buildBlock<D, E: Encodable>(
		_ request: RequestBase,
		_ uri: Uri,
		_ method: Method,
		_ query: Query
	) -> Request<D, E> {
		Request(
			scheme: request.scheme,
			host: request.host,
			port: request.port,
			uri: request.uri + uri.value,
			queryItems: [query],
			method: method.value,
			headers: request.headers
		)
	}
	
	static public func buildBlock<D, E: Encodable>(
		_ request: RequestBase,
		_ uri: Uri,
		_ method: Method,
		_ body: Body<E>
	) -> Request<D, E> {
		Request(
			scheme: request.scheme,
			host: request.host,
			port: request.port,
			uri: request.uri + uri.value,
			queryItems: request.queryItems,
			method: method.value,
			httpBody: .encodable(body.value),
			headers: request.headers
		)
	}
	
	static public func buildBlock<D, E: Encodable>(
		_ request: RequestBase,
		_ method: Method,
		_ body: Body<E>,
		_ header: Header
	) -> Request<D, E> {
		Request(
			scheme: request.scheme,
			host: request.host,
			port: request.port,
			uri: request.uri,
			queryItems: request.queryItems,
			method: method.value,
			httpBody: .encodable(body.value),
			headers: [header.key: header.value, "Content-Type": "application/json"]
		)
	}
	
	static public func buildBlock<D, E: Encodable>(
		_ request: RequestBase,
		_ uri: Uri,
		_ method: Method,
		_ header: Header
	) -> Request<D, E> {
		Request(
			scheme: request.scheme,
			host: request.host,
			port: request.port,
			uri: request.uri + uri.value,
			queryItems: request.queryItems,
			method: method.value,
			headers: [header.key: header.value, "Content-Type": "application/json"]
		)
	}
	
	static public func buildBlock<D, E: Encodable>(
		_ request: RequestBase,
		_ header: Header
	) -> Request<D, E> {
		Request(
			scheme: request.scheme,
			host: request.host,
			port: request.port,
			uri: request.uri,
			queryItems: request.queryItems,
			method: request.method,
			headers: [header.key: header.value, "Content-Type": "application/json"]
		)
	}
	
	static public func buildBlock<D, E: Encodable>(
		_ request: RequestBase,
		_ uri: Uri,
		_ method: Method,
		_ body: Body<E>,
		_ header: Header
	) -> Request<D, E> {
		Request(
			scheme: request.scheme,
			host: request.host,
			port: request.port,
			uri: request.uri + uri.value,
			queryItems: request.queryItems,
			method: method.value,
			httpBody: .encodable(body.value),
			headers: [header.key: header.value, "Content-Type": "application/json"]
		)
	}
	
	static public func buildBlock<D, E: Encodable>(
		_ request: RequestBase,
		_ method: Method,
		_ body: Body<E>,
		_ authorization: Authorization
	) -> Request<D, E> {
		Request(
			scheme: request.scheme,
			host: request.host,
			port: request.port,
			uri: request.uri,
			queryItems: request.queryItems,
			method: method.value,
			httpBody: .encodable(body.value),
			headers: ["Content-Type": "application/json"],
			authorization: .bearer
		)
	}
	
	static public func buildBlock<D, E: Encodable>(
		_ request: RequestBase,
		_ uri: Uri,
		_ method: Method,
		_ authorization: Authorization
	) -> Request<D, E> {
		Request(
			scheme: request.scheme,
			host: request.host,
			port: request.port,
			uri: request.uri + uri.value,
			queryItems: request.queryItems,
			method: method.value,
			headers: ["Content-Type": "application/json"],
			authorization: .bearer
		)
	}
	
	static public func buildBlock<D, E: Encodable>(
		_ request: RequestBase,
		_ uri: Uri,
		_ method: Method,
		_ body: Body<E>,
		_ authorization: Authorization
	) -> Request<D, E> {
		Request(
			scheme: request.scheme,
			host: request.host,
			port: request.port,
			uri: request.uri + uri.value,
			queryItems: request.queryItems,
			method: method.value,
			httpBody: .encodable(body.value),
			headers: ["Content-Type": "application/json"],
			authorization: .bearer
		)
	}
}
