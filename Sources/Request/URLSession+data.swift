import Foundation

extension URLSession {
	@discardableResult
	public func data<D: Decodable, E: Encodable>(
		for request: Request<D, E>
	) async throws -> D {
		let (data, response) = try await self.data(request: request)
		
		switch response.statusCode {
			case 200..<300:
				return try request.decoder.decode(D.self, from: data)
			default:
				throw HTTPError(data: data, response: response)
		}
	}
	
	@discardableResult
	public func data<E: Encodable>(
		for request: Request<Void, E>
	) async throws -> Data {
		let (data, response) = try await self.data(request: request)
		
		switch response.statusCode {
			case 200..<300:
				return data
			default:
				throw HTTPError(data: data, response: response)
		}
	}
}

extension URLSession {
	fileprivate func data<D, E: Encodable>(
		request: Request<D, E>
	) async throws -> (Data, HTTPURLResponse) {
		let (data, response) = try await self.data(
			for: URLRequest(request)
		)
		
		guard let response = response as? HTTPURLResponse else {
			throw URLError(.badServerResponse)
		}
		return (data, response)
	}
}

public protocol DecodableMappable {
	associatedtype D: Decodable

	static func map(_ response: D) -> Self
}

public protocol EncodableMappable {
	associatedtype E: Encodable
	
	static func map(_ entity: Self) -> E
}

extension Array: DecodableMappable where Element: DecodableMappable {
	public static func map(_ response: [Element.D]) -> Array<Element> {
		response.compactMap(Element.map)
	}
}

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
typealias RequestDecodableMappable<D: DecodableMappable> = Request<D, Never>
typealias RequestMappable<D: DecodableMappable, E: Encodable> = Request<D, E>

extension URLSession {
	@discardableResult
	public func data<Entity: DecodableMappable, E: Encodable>(
		for request: Request<Entity, E>
	) async throws -> Entity {
		let (data, response) = try await self.data(request: request)

		switch response.statusCode {
			case 200..<300:
				let element = try request.decoder.decode(Entity.D.self, from: data)
				return Entity.map(element)
			default:
				throw HTTPError(data: data, response: response)
		}
	}
}

extension URLSession {
	@discardableResult
	public func data<Void, Entity: EncodableMappable>(
		for request: Request<Void, Entity>
	) async throws -> Data {
		let (data, response) = try await self.data(request: request)

		switch response.statusCode {
			case 200..<300:
				return data
			default:
				throw HTTPError(data: data, response: response)
		}
	}
}
