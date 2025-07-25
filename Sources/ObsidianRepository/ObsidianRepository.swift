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
        let response = try await client.run(request)
        try validateResponse(response)
    }

    public func deleteActiveNote() async throws {
        let request = requestFactory.makeDeleteActiveFileRequest()
        let response = try await client.run(request)
        try validateResponse(response)
    }

    public func setActiveNoteFrontmatterStringField(
        key: String,
        value: String
    ) async throws {
        let request = requestFactory.makeSetActiveFrontmatterRequest(
            content: value,
            operation: "replace",
            key: key
        )
        let response = try await client.run(request)
        try validateResponse(response)
    }

    public func setActiveNoteFrontmatterArrayField(
        key: String,
        value: [String]
    ) async throws {
        // TODO: Implement array field handling for frontmatter
    }

    public func appendToActiveNoteFrontmatterStringField(
        key: String,
        value: String
    ) async throws {
        let request = requestFactory.makeSetActiveFrontmatterRequest(
            content: value,
            operation: "append",
            key: key
        )
        let response = try await client.run(request)
        try validateResponse(response)
    }

    public func appendToActiveNoteFrontmatterArrayField(
        key: String,
        value: [String]
    ) async throws {
        // TODO: Implement array field appending for frontmatter
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
        let response = try await client.run(request)
        try validateResponse(response)
    }

    public func appendToVaultNote(file: File) async throws {
        let request = requestFactory.makeAppendToVaultFileRequest(
            filename: file.filename,
            content: file.content
        )
        let response = try await client.run(request)
        try validateResponse(response)
    }

    public func deleteVaultNote(filename: String) async throws {
        let request = requestFactory.makeDeleteVaultFileRequest(filename: filename)
        let response = try await client.run(request)
        try validateResponse(response)
    }

    public func setVaultNoteFrontmatterStringField(
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
        let response = try await client.run(request)
        try validateResponse(response)
    }

    public func setVaultNoteFrontmatterArrayField(
        filename: String,
        key: String,
        value: [String]
    ) async throws {
        // TODO: Implement array field handling for vault note frontmatter
    }

    public func appendToVaultNoteFrontmatterStringField(
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
        let response = try await client.run(request)
        try validateResponse(response)
    }

    public func appendToVaultNoteFrontmatterArrayField(
        filename: String,
        key: String,
        value: [String]
    ) async throws {
        // TODO: Implement array field appending for vault note frontmatter
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

    // MARK: - Private

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

    private func validateResponse<T>(
        _ response: NetworkResponse<T>
    ) throws(RepositoryError) {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            throw .invalidResponse
        }

        let statusCode = httpResponse.statusCode

        guard 200..<300 ~= statusCode else {
            let message = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            throw .operationFailed(statusCode: statusCode, message: message)
        }
    }
}
