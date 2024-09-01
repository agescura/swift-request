// swift-tools-version: 5.10

import PackageDescription

let package = Package(
	name: "swift-urlrequest-builder",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15),
		.tvOS(.v13),
		.visionOS(.v1),
		.watchOS(.v6)
	],
	products: [
		.library(
			name: "Request",
			targets: ["Request"]
		)
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.1"),
		.package(url: "https://github.com/AliSoftware/OHHTTPStubs", from: "9.1.0"),
		.package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.17.4")
	],
	targets: [
		.target(
			name: "Request",
			dependencies: []
		),
		.testTarget(
			name: "RequestTests",
			dependencies: [
				.product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs"),
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"Request"
			],
			resources: [.copy("stubs")]
		),
	]
)
