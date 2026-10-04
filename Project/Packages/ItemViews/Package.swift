// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
// swiftlint:disable force_unwrapping

import PackageDescription

let name = "ItemViews"
let localPackages: [String] = [
	"Persistence",
]
let remotePackages = [
	RemotePackage("https://github.com/EmilioPelaez/CGMath", .version("1.0.0")),
]

let package = Package(
	name: name,
	platforms: [.iOS(.v17)],
	products: [
		.library(
			name: name,
			targets: [name],
		),
	],
	dependencies:
	localPackages.map { Package.Dependency.package(path: "../" + $0) }
		+ remotePackages.map(\.packageDependency),
	targets: [
		.target(
			name: name,
			dependencies:
			localPackages.map { Target.Dependency.byName(name: $0) }
				+ remotePackages.flatMap(\.targetDependencies),
			swiftSettings: [.swiftLanguageMode(.v5)],
		),
	],
)

struct RemotePackage {
	let url: String
	let requirement: Requirement
	let package: String
	let products: [String]

	init(_ url: String, _ requirement: Requirement) {
		let urlComponents = url.split(separator: "/")
		let defaultValue = String(urlComponents[urlComponents.count - 1])
		self.url = url
		self.requirement = requirement
		self.package = defaultValue
		self.products = [defaultValue]
	}

	init(_ url: String, _ requirement: Requirement, package: String) {
		let urlComponents = url.split(separator: "/")
		let defaultValue = String(urlComponents[urlComponents.count - 1])
		self.url = url
		self.requirement = requirement
		self.package = package
		self.products = [defaultValue]
	}

	init(_ url: String, _ requirement: Requirement, package: String? = nil, products: String...) {
		let urlComponents = url.split(separator: "/")
		let defaultValue = String(urlComponents[urlComponents.count - 1])
		self.url = url
		self.requirement = requirement
		self.package = package ?? defaultValue
		self.products = products
	}

	var packageDependency: Package.Dependency {
		switch requirement {
		case let .version(version): .package(url: url, from: .init(version)!)
		case let .branch(branch): .package(url: url, branch: branch)
		case let .revision(revision): .package(url: url, revision: revision)
		}
	}

	var targetDependencies: [Target.Dependency] {
		products.map { .product(name: $0, package: package) }
	}

	enum Requirement {
		case version(String)
		case branch(String)
		case revision(String)
	}
}
