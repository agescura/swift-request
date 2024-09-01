import Foundation

public enum HTTPBody<E: Encodable> {
	case encodable(E)
	case data(Data)
}
