// MARK: - Package.swift Configuration
// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "ObsidianMCPServer",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "ObsidianMCPServer", targets: ["ObsidianMCPServer"]),
        .library(name: "ObsidianModels", targets: ["ObsidianModels"]),
        .library(name: "ObsidianNetworking", targets: ["ObsidianNetworking"]),
        .library(name: "ObsidianRepository", targets: ["ObsidianRepository"]),
        .library(name: "ObsidianPrompt", targets: ["ObsidianPrompt"]),
        .library(name: "ObsidianResource", targets: ["ObsidianResource"])
    ],
    dependencies: [
        .package(url: "https://github.com/Cocoanetics/SwiftMCP", branch: "main"),
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/otaviocc/MicroClient", from: "0.0.24")
    ],
    targets: [
        .target(
            name: "ObsidianModels",
            dependencies: []
        ),
        .target(
            name: "ObsidianNetworking",
            dependencies: [
                .product(name: "MicroClient", package: "MicroClient"),
                "AnyCodable"
            ]
        ),
        .target(
            name: "ObsidianRepository",
            dependencies: [
                "ObsidianNetworking",
                .product(name: "SwiftMCP", package: "SwiftMCP"),
                .product(name: "MicroClient", package: "MicroClient")
            ]
        ),
        .target(
            name: "ObsidianPrompt",
            dependencies: [
                "ObsidianRepository",
                "ObsidianModels"
            ]
        ),
        .target(
            name: "ObsidianResource",
            dependencies: [
                "ObsidianModels"
            ]
        ),
        .executableTarget(
            name: "ObsidianMCPServer",
            dependencies: [
                "ObsidianPrompt",
                "ObsidianRepository",
                "ObsidianResource",
                .product(name: "SwiftMCP", package: "SwiftMCP"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "ObsidianModelsTests",
            dependencies: [
                "ObsidianModels"
            ]
        ),
        .testTarget(
            name: "ObsidianNetworkingTests",
            dependencies: [
                "ObsidianNetworking",
                "AnyCodable"
            ]
        ),
        .testTarget(
            name: "ObsidianRepositoryTests",
            dependencies: [
                "ObsidianRepository",
                "ObsidianNetworking"
            ]
        ),
        .testTarget(
            name: "ObsidianPromptTests",
            dependencies: [
                "ObsidianPrompt",
                "ObsidianRepository",
                "ObsidianModels"
            ]
        ),
        .testTarget(
            name: "ObsidianResourceTests",
            dependencies: [
                "ObsidianResource",
                "ObsidianModels"
            ]
        ),
        .testTarget(
            name: "ObsidianMCPServerTests",
            dependencies: [
                "ObsidianMCPServer",
                "ObsidianPrompt",
                "ObsidianRepository",
                "ObsidianResource"
            ]
        )
    ]
)
