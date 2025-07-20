import Foundation
import ObsidianNetworking
import MicroClient

final class ObsidianRepository: ObsidianRepositoryProtocol {

    // MARK: - Properties

    private let client: NetworkClientProtocol
    private let requestFactory: ObsidianRequestFactoryProtocol

    // MARK: - Life cycle

    init(
        client: NetworkClientProtocol,
        requestFactory: ObsidianRequestFactoryProtocol = ObsidianRequestFactory()
    ) {
        self.client = client
        self.requestFactory = requestFactory
    }

    // MARK: - Server Operations

    func getServerInfo() async throws -> ServerInformation {
        let request = requestFactory.makeServerInfoRequest()
        let response = try await client.run(request)
        let serverInfo = response.value

        return ServerInformation(
            service: serverInfo.service,
            version: serverInfo.versions.`self`
        )
    }

    // MARK: - Active Note Operations

    func getActiveNote() async throws -> File {
        let request = requestFactory.makeGetActiveFileRequest(headers: [:])
        let response = try await client.run(request)

        return File(filename: response.value.path, content: response.value.content)
    }

    func updateActiveNote(content: String) async throws {
        let request = requestFactory.makeUpdateActiveFileRequest(content: content, headers: [:])
        _ = try await client.run(request)
    }

    func deleteActiveNote() async throws {
        let request = requestFactory.makeDeleteActiveFileRequest(headers: [:])
        _ = try await client.run(request)
    }

    func patchActiveNote(
        content: String,
        parameters: PatchParameters
    ) async throws {
        let headers = buildPatchHeaders(for: parameters)
        let request = requestFactory.makePatchActiveFileRequest(content: content, headers: headers)
        _ = try await client.run(request)
    }

    // MARK: - Note Operations

    func getVaultNote(filename: String) async throws -> File {
        let request = requestFactory.makeGetVaultFileRequest(filename: filename, headers: [:])
        let response = try await client.run(request)

        return File(filename: response.value.path, content: response.value.content)
    }

    func createOrUpdateVaultNote(file: File) async throws {
        let request = requestFactory.makeCreateOrUpdateVaultFileRequest(
            filename: file.filename,
            content: file.content,
            headers: [:]
        )
        _ = try await client.run(request)
    }

    func appendToVaultNote(file: File) async throws {
        let request = requestFactory.makeAppendToVaultFileRequest(
            filename: file.filename,
            content: file.content,
            headers: [:]
        )
        _ = try await client.run(request)
    }

    func deleteVaultNote(filename: String) async throws {
        let request = requestFactory.makeDeleteVaultFileRequest(filename: filename, headers: [:])
        _ = try await client.run(request)
    }

    func patchVaultNote(
        file: File,
        parameters: PatchParameters
    ) async throws {
        let headers = buildPatchHeaders(for: parameters)
        let request = requestFactory.makePatchVaultFileRequest(
            filename: file.filename,
            content: file.content,
            headers: headers
        )
        _ = try await client.run(request)
    }

    // MARK: - Directory Operations

    func listVaultDirectory(directory: String = "") async throws -> [URL] {
        try await listVaultDirectoryRecursive(directory: directory, currentDepth: 0, maxDepth: 2)
    }

    private func listVaultDirectoryRecursive(
        directory: String,
        currentDepth: Int,
        maxDepth: Int
    ) async throws -> [URL] {
        let request = requestFactory.makeListVaultDirectoryRequest(directory: directory, headers: [:])
        let response = try await client.run(request)
        let files = response.value.files

        var allFiles: [URL] = []

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

    func searchVault(
        query: String,
        ignoreCase: Bool,
        wholeWord: Bool,
        isRegex: Bool
    ) async throws -> [SearchResult] {
        let request = requestFactory.makeSearchVaultRequest(
            query: query,
            ignoreCase: ignoreCase,
            wholeWord: wholeWord,
            isRegex: isRegex,
            headers: [:]
        )

        let searchResponse = try await client.run(request).value

        return searchResponse.map { response in
            SearchResult(path: response.filename, score: response.score)
        }
    }

    func searchVaultInPath(
        query: String,
        path: String,
        ignoreCase: Bool,
        wholeWord: Bool,
        isRegex: Bool
    ) async throws -> [SearchResult] {
        let queryInPath = "path:\"\(path)\" \(query)"

        return try await searchVault(
            query: queryInPath,
            ignoreCase: ignoreCase,
            wholeWord: wholeWord,
            isRegex: isRegex
        )
    }

    // MARK: - Private

    private func buildPatchHeaders(
        for params: PatchParameters,
        additionalHeaders: [String: String] = [:]
    ) -> [String: String] {
        var headers: [String: String] = [:]
        headers["Operation"] = params.operation.rawValue
        headers["Target-Type"] = params.targetType.rawValue
        headers["Target-Delimiter"] = "::"
        headers["Trim-Target-Whitespace"] = "true"
        headers["Create-Target-If-Missing"] = "true"
        headers["Target"] = params.target.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? params.target

        for (key, value) in additionalHeaders {
            headers[key] = value
        }

        return headers
    }

    private func buildDirectoryPath(
        base: String,
        component: String
    ) -> URL {
        if base.isEmpty {
            return URL(fileURLWithPath: component, isDirectory: true)
        }

        let baseURL = URL(fileURLWithPath: base, isDirectory: true)
        return baseURL.appendingPathComponent(component, isDirectory: true)
    }

    private func buildFilePath(
        directory: String,
        filename: String
    ) -> URL {
        if directory.isEmpty {
            return URL(fileURLWithPath: filename)
        }

        let directoryURL = URL(fileURLWithPath: directory, isDirectory: true)
        return directoryURL.appendingPathComponent(filename)
    }
}
