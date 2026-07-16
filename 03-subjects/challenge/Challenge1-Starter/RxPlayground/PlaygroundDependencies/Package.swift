// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlaygroundDependencies",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PlaygroundDependencies",
            targets: ["PlaygroundDependencies"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PlaygroundDependencies"
        ),
        .testTarget(
            name: "PlaygroundDependenciesTests",
            dependencies: ["PlaygroundDependencies"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

package.dependencies = [
    .package(url: "https://github.com//ReactiveX/RxSwift", from: "6.10.2")
]
package.targets = [
    .target(name: "PlaygroundDependencies",
        dependencies: [
            .product(name: "RxSwift", package: "RxSwift"),
            .product(name: "RxRelay", package: "RxSwift")
        ]
    )
]
package.platforms = [
    .iOS("12.0"),
    .macOS("10.13"),
    .tvOS("12.0"),
    .watchOS("4.0")
]
