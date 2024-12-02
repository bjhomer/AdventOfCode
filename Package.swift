// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let dependencies: [Target.Dependency] = [
    .product(name: "ArgumentParser", package: "swift-argument-parser"),
    .product(name: "Algorithms", package: "swift-algorithms"),
    .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
    .product(name: "StandardLibraryPreview", package: "swift-standard-library-preview"),
    .product(name: "SwiftGraph", package: "SwiftGraph"),
    .product(name: "Collections", package: "swift-collections")
]

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v15)],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "1.5.0")),
        .package(url: "https://github.com/apple/swift-algorithms", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/apple/swift-async-algorithms", .upToNextMajor(from: "0.0.3")),
        .package(url: "https://github.com/davecom/SwiftGraph", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/apple/swift-standard-library-preview.git", from: "0.0.3"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(name: "Advent2024",
                          dependencies: ["AdventCore"] + dependencies,
                          exclude: ["Tests"],
                          resources: [.copy("Inputs")]
                         ),
       .executableTarget(name: "Advent2023",
                         dependencies: ["AdventCore"] + dependencies,
                         exclude: ["Tests"],
                         resources: [.copy("Inputs")]
                        ),
        .executableTarget(name: "Advent2022",
                          dependencies: ["AdventCore"] + dependencies,
                          exclude: ["Inputs"],
                          resources: [.copy("Inputs")]
                         ),
        .executableTarget(name: "Advent2020",
                          dependencies: ["AdventCore"] + dependencies,
                          exclude: ["Inputs"],
                          resources: [.copy("Inputs")]
                         ),
        .executableTarget(name: "Advent2015",
                dependencies: ["AdventCore"] + dependencies,
                exclude: ["Inputs"]),
        .target(
            name: "AdventCore",
            dependencies: dependencies
        ),
        .testTarget(
            name: "AdventCoreTests",
            dependencies: ["AdventCore"]),
        .testTarget(
            name: "Advent2023Tests",
            dependencies: ["Advent2023"] + dependencies,
            path: "Sources/Advent2023/Tests"
        ),
        .testTarget(
            name: "Advent2024Tests",
            dependencies: ["Advent2024"] + dependencies,
            path: "Sources/Advent2024/Tests"
        )
    ],
    swiftLanguageModes: [.v6]
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
