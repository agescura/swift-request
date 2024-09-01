import Foundation

@available(iOS 17, macOS 14, tvOS 17, watchOS 10, *)
public typealias RequestDecodable<D: Decodable> = Request<D, Never>
