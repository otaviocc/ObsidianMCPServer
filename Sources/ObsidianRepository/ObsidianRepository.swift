import Foundation
import ObsidianNetworking
import MicroClient

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

    // MARK: - Server Operations

    public func getServerInfo() async throws -> ServerInformation {
        let request = requestFactory.makeServerInfoRequest()
        let response = try await client.run(request)
        let serverInfo = response.value

        return .init(
            service: serverInfo.service,
            version: serverInfo.versions.`self`
        )
    }

    // MARK: - Active Note Operations

    public func getActiveNote() async throws -> File {
        let request = requestFactory.makeGetActiveFileRequest()
        let response = try await client.run(request)

        return .init(filename: response.value.path, content: response.value.content)
    }

    public func updateActiveNote(content: String) async throws {
        let request = requestFactory.makeUpdateActiveFileRequest(content: content)
        _ = try await client.run(request)
    }

    public func deleteActiveNote() async throws {
        let request = requestFactory.makeDeleteActiveFileRequest()
        _ = try await client.run(request)
    }

    public func setActiveNoteFrontmatterField(
        key: String,
        value: String
    ) async throws {
        let request = requestFactory.makeSetActiveFrontmatterRequest(
            content: value,
            operation: "replace",
            key: key
        )
        _ = try await client.run(request)
    }

    public func appendToActiveNoteFrontmatterField(
        key: String,
        value: String
    ) async throws {
        let request = requestFactory.makeSetActiveFrontmatterRequest(
            content: value,
            operation: "append",
            key: key
        )
        _ = try await client.run(request)
    }

    // MARK: - Note Operations

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
        _ = try await client.run(request)
    }

    public func appendToVaultNote(file: File) async throws {
        let request = requestFactory.makeAppendToVaultFileRequest(
            filename: file.filename,
            content: file.content
        )
        _ = try await client.run(request)
    }

    public func deleteVaultNote(filename: String) async throws {
        let request = requestFactory.makeDeleteVaultFileRequest(filename: filename)
        _ = try await client.run(request)
    }

    public func setVaultNoteFrontmatterField(
        filename: String,
        key: String,
        value: String
    ) async throws {
        let request = requestFactory.makeSetVaultFrontmatterRequest(
            filename: filename,
            content: value,
            operation: "replace",
            key: key
        )
        _ = try await client.run(request)
    }

    public func appendToVaultNoteFrontmatterField(
        filename: String,
        key: String,
        value: String
    ) async throws {
        let request = requestFactory.makeSetVaultFrontmatterRequest(
            filename: filename,
            content: value,
            operation: "append",
            key: key
        )
        _ = try await client.run(request)
    }

    // MARK: - Directory Operations

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
            let filePath = buildFilePath(directory: directory, filename: file)

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

    // MARK: - Search Operations

    public func searchVault(
        query: String,
        ignoreCase: Bool,
        wholeWord: Bool,
        isRegex: Bool
    ) async throws -> [SearchResult] {
        let request = requestFactory.makeSearchVaultRequest(
            query: query,
            ignoreCase: ignoreCase,
            wholeWord: wholeWord,
            isRegex: isRegex
        )

        let searchResponse = try await client.run(request).value

        return searchResponse.map { response in
            SearchResult(path: response.filename, score: response.score)
        }
    }

    // MARK: - Private

    private func buildDirectoryPath(
        base: String,
        component: String
    ) -> String {
        if base.isEmpty {
            return component.hasSuffix("/") ? component : "\(component)/"
        }

        let basePath = base.hasSuffix("/") ? base : "\(base)/"
        let componentPath = component.hasSuffix("/") ? component : "\(component)/"
        return "\(basePath)\(componentPath)"
    }

    private func buildFilePath(
        directory: String,
        filename: String
    ) -> String {
        if directory.isEmpty {
            return filename
        }

        let directoryPath = directory.hasSuffix("/") ? directory : "\(directory)/"
        return "\(directoryPath)\(filename)"
    }
}
