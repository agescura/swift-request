import Foundation

public struct Uri {
	let value: String
	
	public init(
		_ value: String
	) {
		self.value = "/\(value)"
	}
}

extension Uri {
	public init(
		@StringBuilder _ path: @escaping () -> String
	) {
		self.value = "/\(path())"
	}
}

extension Uri {
	public init(
		_ id: UUID
	) {
		self.value = "/\(id.uuidString)"
	}
}

@resultBuilder
public struct StringBuilder {
	 public static func buildBlock(_ components: String...) -> String {
		  return components.joined(separator: "/")
	 }
}
