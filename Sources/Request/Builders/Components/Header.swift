import Foundation

public struct Header {
	let key: String
	let value: String
	
	public init(
		key: String,
		value: String
	) {
		self.key = key
		self.value = value
	}
}

extension Header {
	public enum HeaderField {
		case authorization(AuthorizationValue)
		case contentType(Value)
		
		public enum AuthorizationValue {
			case basic(String, String)
			case bearer(String)
			
			public var rawValue: String {
				switch self {
					case let .basic(username, password):
						return "Basic \(String(format: "%@:%@", username, password).data(using: .utf8)!.base64EncodedString())"
					case let .bearer(token):
						return "Bearer \(token)"
				}
			}
		}
		
		public enum Value {
			case application(ApplicationValue)
			
			public enum ApplicationValue: String {
				case json
				case xml
			}
			
			var rawValue: String {
				switch self {
					case let .application(value):
						return "application/" + value.rawValue
				}
			}
		}
		
		var key: String {
			switch self {
				case .contentType:
					return "Content-Type"
				case .authorization:
					return "Authorization"
			}
		}
		
		var value: String {
			switch self {
				case let .contentType(value):
					return value.rawValue
				case let .authorization(value):
					return value.rawValue
			}
		}
	}
	
	public init(_ header: HeaderField) {
		self.init(key: header.key, value: header.value)
	}
}
