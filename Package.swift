// MARK: - Package.swift Configuration
// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "ObsidianMCPServer",
    platforms: [
        .macOS(.v12),
    ],
    products: [
        .executable(name: "ObsidianMCPServer", targets: ["ObsidianMCPServer"]),
        .library(name: "ObsidianNetworking", targets: ["ObsidianNetworking"]),
        .library(name: "ObsidianRepository", targets: ["ObsidianRepository"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Cocoanetics/SwiftMCP", branch: "main"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/otaviocc/MicroClient", branch: "main"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", branch: "main")
    ],
    targets: [
        .target(
            name: "ObsidianNetworking",
            dependencies: [
                .product(name: "MicroClient", package: "MicroClient")
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "ObsidianRepository",
            dependencies: [
                "ObsidianNetworking",
                .product(name: "SwiftMCP", package: "SwiftMCP"),
                .product(name: "MicroClient", package: "MicroClient")
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .executableTarget(
            name: "ObsidianMCPServer",
            dependencies: [
                "ObsidianRepository",
                .product(name: "SwiftMCP", package: "SwiftMCP"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "ObsidianNetworkingTests",
            dependencies: [
                "ObsidianNetworking"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "ObsidianRepositoryTests",
            dependencies: [
                "ObsidianRepository",
                "ObsidianNetworking"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "ObsidianMCPServerTests",
            dependencies: [
                "ObsidianMCPServer",
                "ObsidianRepository"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        )
    ]
)
