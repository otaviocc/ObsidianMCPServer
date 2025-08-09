import Foundation
import MicroClient
import ObsidianNetworking

// swiftlint:disable file_length

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

// MARK: - ObsidianRepositoryBulkOperations

extension ObsidianRepository: ObsidianRepositoryBulkOperations {

    public func bulkApplyTagsFromSearch(
        query: String,
        tags: [String]
    ) async throws -> BulkOperationResult {
        let searchResults = try await searchVault(query: query)
        let filenames = searchResults.map(\.path)

        var successful: [String] = []
        var failed: [BulkOperationFailure] = []

        for filename in filenames {
            do {
                try await appendToVaultNoteFrontmatterArrayField(
                    filename: filename,
                    key: "tags",
                    value: tags
                )
                successful.append(filename)
            } catch {
                failed.append(.init(
                    filename: filename,
                    error: error.localizedDescription
                ))
            }
        }

        return .init(
            successful: successful,
            failed: failed,
            totalProcessed: filenames.count,
            query: query
        )
    }

    public func bulkReplaceFrontmatterStringFromSearch(
        query: String,
        key: String,
        value: String
    ) async throws -> BulkOperationResult {
        let searchResults = try await searchVault(query: query)
        let filenames = searchResults.map(\.path)

        var successful: [String] = []
        var failed: [BulkOperationFailure] = []

        for filename in filenames {
            do {
                try await setVaultNoteFrontmatterStringField(
                    filename: filename,
                    key: key,
                    value: value
                )
                successful.append(filename)
            } catch {
                failed.append(.init(
                    filename: filename,
                    error: error.localizedDescription
                ))
            }
        }

        return .init(
            successful: successful,
            failed: failed,
            totalProcessed: filenames.count,
            query: query
        )
    }

    public func bulkReplaceFrontmatterArrayFromSearch(
        query: String,
        key: String,
        value: [String]
    ) async throws -> BulkOperationResult {
        let searchResults = try await searchVault(query: query)
        let filenames = searchResults.map(\.path)

        var successful: [String] = []
        var failed: [BulkOperationFailure] = []

        for filename in filenames {
            do {
                try await setVaultNoteFrontmatterArrayField(
                    filename: filename,
                    key: key,
                    value: value
                )
                successful.append(filename)
            } catch {
                failed.append(.init(
                    filename: filename,
                    error: error.localizedDescription
                ))
            }
        }

        return .init(
            successful: successful,
            failed: failed,
            totalProcessed: filenames.count,
            query: query
        )
    }

    public func bulkAppendToFrontmatterStringFromSearch(
        query: String,
        key: String,
        value: String
    ) async throws -> BulkOperationResult {
        let searchResults = try await searchVault(query: query)
        let filenames = searchResults.map(\.path)

        var successful: [String] = []
        var failed: [BulkOperationFailure] = []

        for filename in filenames {
            do {
                try await appendToVaultNoteFrontmatterStringField(
                    filename: filename,
                    key: key,
                    value: value
                )
                successful.append(filename)
            } catch {
                failed.append(.init(
                    filename: filename,
                    error: error.localizedDescription
                ))
            }
        }

        return .init(
            successful: successful,
            failed: failed,
            totalProcessed: filenames.count,
            query: query
        )
    }

    public func bulkAppendToFrontmatterArrayFromSearch(
        query: String,
        key: String,
        value: [String]
    ) async throws -> BulkOperationResult {
        let searchResults = try await searchVault(query: query)
        let filenames = searchResults.map(\.path)

        var successful: [String] = []
        var failed: [BulkOperationFailure] = []

        for filename in filenames {
            do {
                try await appendToVaultNoteFrontmatterArrayField(
                    filename: filename,
                    key: key,
                    value: value
                )
                successful.append(filename)
            } catch {
                failed.append(.init(
                    filename: filename,
                    error: error.localizedDescription
                ))
            }
        }

        return .init(
            successful: successful,
            failed: failed,
            totalProcessed: filenames.count,
            query: query
        )
    }
}

// MARK: - ObsidianRepositoryPeriodicOperations

extension ObsidianRepository: ObsidianRepositoryPeriodicOperations {

    public func getPeriodicNote(period: String) async throws -> File {
        let request = requestFactory.makeGetPeriodicNoteRequest(period: period)
        let response = try await client.run(request)

        return .init(
            filename: response.value.path,
            content: response.value.content
        )
    }

    public func createOrUpdatePeriodicNote(
        period: String,
        content: String
    ) async throws {
        let request = requestFactory.makeCreateOrUpdatePeriodicNoteRequest(
            period: period,
            content: content
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func appendToPeriodicNote(
        period: String,
        content: String
    ) async throws {
        let request = requestFactory.makeAppendToPeriodicNoteRequest(
            period: period,
            content: content
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func deletePeriodicNote(period: String) async throws {
        let request = requestFactory.makeDeletePeriodicNoteRequest(
            period: period
        )
        let response = try await client.run(request)
        try response.validate()
    }
}

// MARK: - ObsidianRepositoryDatePeriodicOperations

extension ObsidianRepository: ObsidianRepositoryDatePeriodicOperations {

    public func deleteDailyNote(
        year: Int,
        month: Int,
        day: Int
    ) async throws {
        let request = requestFactory.makeDeleteDailyNoteRequest(
            year: year,
            month: month,
            day: day
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func deleteWeeklyNote(
        year: Int,
        month: Int,
        day: Int
    ) async throws {
        let request = requestFactory.makeDeleteWeeklyNoteRequest(
            year: year,
            month: month,
            day: day
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func deleteMonthlyNote(
        year: Int,
        month: Int,
        day: Int
    ) async throws {
        let request = requestFactory.makeDeleteMonthlyNoteRequest(
            year: year,
            month: month,
            day: day
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func deleteQuarterlyNote(
        year: Int,
        month: Int,
        day: Int
    ) async throws {
        let request = requestFactory.makeDeleteQuarterlyNoteRequest(
            year: year,
            month: month,
            day: day
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func deleteYearlyNote(
        year: Int,
        month: Int,
        day: Int
    ) async throws {
        let request = requestFactory.makeDeleteYearlyNoteRequest(
            year: year,
            month: month,
            day: day
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func appendToDailyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        let request = requestFactory.makeAppendToDailyNoteRequest(
            year: year,
            month: month,
            day: day,
            content: content
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func appendToWeeklyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        let request = requestFactory.makeAppendToWeeklyNoteRequest(
            year: year,
            month: month,
            day: day,
            content: content
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func appendToMonthlyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        let request = requestFactory.makeAppendToMonthlyNoteRequest(
            year: year,
            month: month,
            day: day,
            content: content
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func appendToQuarterlyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        let request = requestFactory.makeAppendToQuarterlyNoteRequest(
            year: year,
            month: month,
            day: day,
            content: content
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func appendToYearlyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        let request = requestFactory.makeAppendToYearlyNoteRequest(
            year: year,
            month: month,
            day: day,
            content: content
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func createOrUpdateDailyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        let request = requestFactory.makeCreateOrUpdateDailyNoteRequest(
            year: year,
            month: month,
            day: day,
            content: content
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func createOrUpdateWeeklyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        let request = requestFactory.makeCreateOrUpdateWeeklyNoteRequest(
            year: year,
            month: month,
            day: day,
            content: content
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func createOrUpdateMonthlyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        let request = requestFactory.makeCreateOrUpdateMonthlyNoteRequest(
            year: year,
            month: month,
            day: day,
            content: content
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func createOrUpdateQuarterlyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        let request = requestFactory.makeCreateOrUpdateQuarterlyNoteRequest(
            year: year,
            month: month,
            day: day,
            content: content
        )
        let response = try await client.run(request)
        try response.validate()
    }

    public func createOrUpdateYearlyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        let request = requestFactory.makeCreateOrUpdateYearlyNoteRequest(
            year: year,
            month: month,
            day: day,
            content: content
        )
        let response = try await client.run(request)
        try response.validate()
    }
}

// swiftlint:enable file_length
