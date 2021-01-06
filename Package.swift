// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AdventCore",
            targets: ["AdventCore"]),
        .executable(name: "Advent2020", targets: ["AdventOfCode2020"]),
        .executable(name: "Advent2015", targets: ["AdventOfCode2015"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.3.0")),
        .package(url: "https://github.com/apple/swift-algorithms", .upToNextMajor(from: "0.0.1")),
        .package(url: "https://github.com/davecom/SwiftGraph", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/apple/swift-standard-library-preview.git", from: "0.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "AdventOfCode2020",
                dependencies: [
                    .target(name: "AdventCore"),
                    .product(name: "ArgumentParser", package: "swift-argument-parser"),
                    .product(name: "Algorithms", package: "swift-algorithms"),
                    .product(name: "StandardLibraryPreview", package: "swift-standard-library-preview"),
                ],
                exclude: ["Inputs"]),
        .target(name: "AdventOfCode2015",
                dependencies: [
                    .target(name: "AdventCore"),
                    .product(name: "ArgumentParser", package: "swift-argument-parser"),
                    .product(name: "Algorithms", package: "swift-algorithms"),
                    .product(name: "SwiftGraph", package: "SwiftGraph"),
                ],
                exclude: ["Inputs"]),

        .target(
            name: "AdventCore",
            dependencies: []),
        .testTarget(
            name: "AdventCoreTests",
            dependencies: ["AdventCore"]),
    ]
)



/*
 let package = Package(
 name: "advent2015",
 platforms: [.macOS(.v11)],
 dependencies: [
 // Dependencies declare other packages that this package depends on.
 .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.3.0")),
 .package(url: "https://github.com/apple/swift-algorithms", .upToNextMajor(from: "0.0.1")),
 .package(path: "../AdventCore")
 ],
 targets: [
 // Targets are the basic building blocks of a package. A target can define a module or a test suite.
 // Targets can depend on other targets in this package, and on products in packages this package depends on.
 .target(
 name: "advent2015",
 dependencies: [
 .product(name: "ArgumentParser", package: "swift-argument-parser"),
 .product(name: "Algorithms", package: "swift-algorithms"),
 .product(name: "AdventCore", package: "AdventCore")
 ]),
 ]
 )

 */
