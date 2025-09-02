// MARK: - Package.swift Configuration
// swift-tools-version:6.0

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
        .package(url: "https://github.com/otaviocc/MicroClient", from: "0.0.18"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", branch: "main")
    ],
    targets: [
        .target(
            name: "ObsidianModels",
            dependencies: [],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "ObsidianNetworking",
            dependencies: [
                .product(name: "MicroClient", package: "MicroClient"),
                "AnyCodable"
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
        .target(
            name: "ObsidianPrompt",
            dependencies: [
                "ObsidianRepository",
                "ObsidianModels"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .target(
            name: "ObsidianResource",
            dependencies: [
                "ObsidianModels"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
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
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "ObsidianModelsTests",
            dependencies: [
                "ObsidianModels"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "ObsidianNetworkingTests",
            dependencies: [
                "ObsidianNetworking",
                "AnyCodable"
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
            name: "ObsidianPromptTests",
            dependencies: [
                "ObsidianPrompt",
                "ObsidianRepository",
                "ObsidianModels"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "ObsidianResourceTests",
            dependencies: [
                "ObsidianResource",
                "ObsidianModels"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "ObsidianMCPServerTests",
            dependencies: [
                "ObsidianMCPServer",
                "ObsidianPrompt",
                "ObsidianRepository",
                "ObsidianResource"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        )
    ]
)
