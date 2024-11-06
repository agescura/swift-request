// swift-tools-version:5.10

import PackageDescription

let package = Package(
	name: "Demo",
	platforms: [
		.macOS(.v13),
		.iOS(.v17)
	],
	products: [
		.library(name: "AcronymFeature", targets: ["AcronymFeature"]),
		.library(name: "ApiClient", targets: ["ApiClient"]),
		.library(name: "CategoryFeature", targets: ["CategoryFeature"]),
		.library(name: "DesignSystem", targets: ["DesignSystem"]),
		.library(name: "Models", targets: ["Models"]),
		.library(name: "LoginFeature", targets: ["LoginFeature"]),
		.library(name: "HomeFeature", targets: ["HomeFeature"]),
		.library(name: "ListFeature", targets: ["ListFeature"]),
		.library(name: "TabFeature", targets: ["TabFeature"]),
		.library(name: "SearchFeature", targets: ["SearchFeature"]),
		.library(name: "UserFeature", targets: ["UserFeature"])
	],
	dependencies: [
		.package(url: "https://github.com/vapor/vapor.git", from: "4.106.1"),
		.package(url: "https://github.com/vapor/fluent.git", from: "4.12.0"),
		.package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.10.0"),
		.package(url: "https://github.com/apple/swift-nio.git", from: "2.76.0"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact:"1.15.2"),
		.package(url: "https://github.com/vapor/leaf.git", from: "4.4.0"),
		.package(name: "swift-request", path: "../")
	],
	targets: [
		.executableTarget(
			name: "Main",
			dependencies: [
				.product(name: "Fluent", package: "fluent"),
				.product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
				.product(name: "Vapor", package: "vapor"),
				.product(name: "NIOCore", package: "swift-nio"),
				.product(name: "NIOPosix", package: "swift-nio"),
				.product(name: "Leaf", package: "leaf")
			],
			path: "Sources/Server/Main",
			swiftSettings: swiftSettings
		),
		.testTarget(
			name: "MainTests",
			dependencies: [
				.target(name: "Main"),
				.product(name: "XCTVapor", package: "vapor"),
			],
			path: "Tests/Server/MainTests",
			swiftSettings: swiftSettings
		),
		.target(
			name: "ApiClient",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				.product(name: "Request", package: "swift-request"),
				"Models"
			],
			path: "Sources/App/ApiClient"
		),
		.target(
			name: "AcronymFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"ApiClient",
				"Models"
			],
			path: "Sources/App/AcronymFeature"
		),
		.target(
			name: "CategoryFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"ApiClient",
				"DesignSystem",
				"Models"
			],
			path: "Sources/App/CategoryFeature"
		),
		.target(
			name: "HomeFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"AcronymFeature",
				"ApiClient",
				"CategoryFeature",
				"Models",
				"UserFeature"
			],
			path: "Sources/App/HomeFeature"
		),
		.target(
			name: "DesignSystem",
			dependencies: [],
			path: "Sources/App/DesignSystem"
		),
		.target(
			name: "Models",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			],
			path: "Sources/App/Models"
		),
		.target(
			name: "LoginFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"ApiClient",
				"DesignSystem",
				"Models"
			],
			path: "Sources/App/LoginFeature"
		),
		.target(
			name: "ListFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"AcronymFeature",
				"ApiClient",
				"CategoryFeature",
				"Models",
				"UserFeature"
			],
			path: "Sources/App/ListFeature"
		),
		.target(
			name: "SearchFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"AcronymFeature",
				"ApiClient",
				"CategoryFeature",
				"Models",
				"UserFeature"
			],
			path: "Sources/App/SearchFeature"
		),
		.target(
			name: "TabFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"HomeFeature",
				"ListFeature",
				"LoginFeature",
				"Models",
				"SearchFeature"
			],
			path: "Sources/App/TabFeature"
		),
		.target(
			name: "UserFeature",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"ApiClient",
				"Models"
			],
			path: "Sources/App/UserFeature"
		),
	]
)

var swiftSettings: [SwiftSetting] {
	[
		.enableUpcomingFeature("DisableOutwardActorInference"),
		.enableExperimentalFeature("StrictConcurrency"),
	]
}
