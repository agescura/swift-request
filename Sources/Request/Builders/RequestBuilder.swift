import Foundation

@resultBuilder
public struct RequestBuilder {}

extension RequestBuilder {
	static public func buildBlock<D, E: Encodable>(
		_ scheme: Scheme,
		_ host: Host,
		_ port: Port,
		_ uri: Uri,
		_ queries: [Query],
		_ method: Method,
		_ body: Body<E>,
		_ headers: [Header],
		_ encoder: JSONEncoder,
		_ decoder: JSONDecoder
	) -> Request<D, E> {
		Request(
			scheme: scheme.value,
			host: host.value,
			port: port.value,
			uri: uri.value,
			queryItems: queries,
			method: method.value,
			httpBody: .encodable(body.value),
			headers: headers.reduce(into: [String: String](), { $0[$1.key] = $1.value }),
			encoder: encoder,
			decoder: decoder
		)
	}
}
