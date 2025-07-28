import Foundation
import MicroClient
import ObsidianNetworking

public final class ObsidianRepository: ObsidianRepositoryProtocol {

    // MARK: - Properties

    private let client: NetworkClientProtocol
    private let requestFactory: ObsidianRequestFactoryProtocol

    // MARK: - Life cycle

    public init(
        client: NetworkClientProtocol,
        requestFactory: ObsidianRequestFactoryProtocol = ObsidianRequestFactory()
    ) {
        self.client = client
        self.requestFactory = requestFactory
    }
}

// MARK: - ObsidianRepositoryServerOperations

extension ObsidianRepository: ObsidianRepositoryServerOperations {

    public func getServerInfo() async throws -> ServerInformation {
        let request = requestFactory.makeServerInfoRequest()
        let response = try await client.run(request)
        let serverInfo = response.value

        return .init(
            service: serverInfo.service,
            version: serverInfo.versions.`self`
        )
    }
}

// MARK: - ObsidianRepositoryActiveNoteOperations

extension ObsidianRepository: ObsidianRepositoryActiveNoteOperations {

    public func getActiveNote() async throws -> File {
        let request = requestFactory.makeGetActiveFileRequest()
        let response = try await client.run(request)

        return .init(filename: response.value.path, content: response.value.content)
    }

    public func updateActiveNote(content: String) async throws {
        let request = requestFactory.makeUpdateActiveFileRequest(content: content)
        let response = try await client.run(request)
        try response.validate()
    }

    public func deleteActiveNote() async throws {
        let request = requestFactory.makeDeleteActiveFileRequest()
        let response = try await client.run(request)
        try response.validate()
    }

    public func setActiveNoteFrontmatterStringField(
        key: String,
        value: String
    ) async throws {
        let request = requestFactory.makeSetActiveFrontmatterRequest(
            content: try value.toJSONString(),
            operation: "replace",
            key: key
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func setActiveNoteFrontmatterArrayField(
        key: String,
        value: [String]
    ) async throws {
        let request = requestFactory.makeSetActiveFrontmatterRequest(
            content: try value.toJSONString(),
            operation: "replace",
            key: key
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func appendToActiveNoteFrontmatterStringField(
        key: String,
        value: String
    ) async throws {
        let request = requestFactory.makeSetActiveFrontmatterRequest(
            content: try value.toJSONString(),
            operation: "append",
            key: key
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func appendToActiveNoteFrontmatterArrayField(
        key: String,
        value: [String]
    ) async throws {
        let request = requestFactory.makeSetActiveFrontmatterRequest(
            content: try value.toJSONString(),
            operation: "append",
            key: key
        )
        let response = try await client.run(request)
        try response.validate()
    }
}

// MARK: - ObsidianRepositoryVaultNoteOperations

extension ObsidianRepository: ObsidianRepositoryVaultNoteOperations {

    public func getVaultNote(filename: String) async throws -> File {
        let request = requestFactory.makeGetVaultFileRequest(filename: filename)
        let response = try await client.run(request)

        return .init(filename: response.value.path, content: response.value.content)
    }

    public func createOrUpdateVaultNote(file: File) async throws {
        let request = requestFactory.makeCreateOrUpdateVaultFileRequest(
            filename: file.filename,
            content: file.content
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func appendToVaultNote(file: File) async throws {
        let request = requestFactory.makeAppendToVaultFileRequest(
            filename: file.filename,
            content: file.content
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func deleteVaultNote(filename: String) async throws {
        let request = requestFactory.makeDeleteVaultFileRequest(filename: filename)
        let response = try await client.run(request)
        try response.validate()
    }

    public func setVaultNoteFrontmatterStringField(
        filename: String,
        key: String,
        value: String
    ) async throws {
        let request = requestFactory.makeSetVaultFrontmatterRequest(
            filename: filename,
            content: try value.toJSONString(),
            operation: "replace",
            key: key
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func setVaultNoteFrontmatterArrayField(
        filename: String,
        key: String,
        value: [String]
    ) async throws {
        let request = requestFactory.makeSetVaultFrontmatterRequest(
            filename: filename,
            content: try value.toJSONString(),
            operation: "replace",
            key: key
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func appendToVaultNoteFrontmatterStringField(
        filename: String,
        key: String,
        value: String
    ) async throws {
        let request = requestFactory.makeSetVaultFrontmatterRequest(
            filename: filename,
            content: try value.toJSONString(),
            operation: "append",
            key: key
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func appendToVaultNoteFrontmatterArrayField(
        filename: String,
        key: String,
        value: [String]
    ) async throws {
        let request = requestFactory.makeSetVaultFrontmatterRequest(
            filename: filename,
            content: try value.toJSONString(),
            operation: "append",
            key: key
        )
        let response = try await client.run(request)
        try response.validate()
    }
}

// MARK: - ObsidianRepositoryVaultOperations

extension ObsidianRepository: ObsidianRepositoryVaultOperations {

    public func listVaultDirectory(directory: String = "") async throws -> [String] {
        try await listVaultDirectoryRecursive(directory: directory, currentDepth: 0, maxDepth: 2)
    }

    private func listVaultDirectoryRecursive(
        directory: String,
        currentDepth: Int,
        maxDepth: Int
    ) async throws -> [String] {
        let request = requestFactory.makeListVaultDirectoryRequest(directory: directory)
        let response = try await client.run(request)
        let files = response.value.files

        var allFiles: [String] = []

        for file in files {
            let filePath = directory.appendingPathComponent(file)

            if file.hasSuffix("/") {
                allFiles.append(filePath)

                if currentDepth < maxDepth {
                    let subdirectoryPath = String(file.dropLast())
                    let subdirectoryFullPath = directory.isEmpty ? subdirectoryPath : "\(directory)/\(subdirectoryPath)"

                    let subdirectoryFiles = try await listVaultDirectoryRecursive(
                        directory: subdirectoryFullPath,
                        currentDepth: currentDepth + 1,
                        maxDepth: maxDepth
                    )
                    allFiles.append(contentsOf: subdirectoryFiles)
                }
            } else {
                allFiles.append(filePath)
            }
        }

        return allFiles
    }
}

// MARK: - ObsidianRepositorySearchOperations

extension ObsidianRepository: ObsidianRepositorySearchOperations {

    public func searchVault(
        query: String
    ) async throws -> [SearchResult] {
        let request = requestFactory.makeSearchVaultRequest(
            query: query
        )

        let searchResponse = try await client.run(request).value

        return searchResponse.map { response in
            .init(path: response.filename, score: response.score)
        }
    }
}
