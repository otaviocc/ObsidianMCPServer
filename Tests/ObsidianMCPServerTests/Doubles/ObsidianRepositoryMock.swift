import Foundation
@testable import ObsidianRepository

final class ObsidianRepositoryMock: ObsidianRepositoryProtocol {

    // MARK: - Properties

    var serverInfoToReturn: ServerInformation = ServerInformation(service: "mock-obsidian-api", version: "1.0.0")
    var errorToThrow: Error?

    // Custom return values for prompts
    var vaultNoteToReturn: File?
    var activeNoteToReturn: File?

    var getServerInfoCallCount = 0
    var getActiveNoteCalled = false
    var getActiveNoteCallCount = 0
    var updateActiveNoteCalled = false
    var updateActiveNoteCallCount = 0
    var deleteActiveNoteCalled = false
    var deleteActiveNoteCallCount = 0

    var lastUpdateActiveNoteContent: String?

    var getVaultNoteCalled = false
    var getVaultNoteCallCount = 0
    var lastGetVaultNoteFilename: String?
    var createOrUpdateVaultNoteCalled = false
    var createOrUpdateVaultNoteCallCount = 0
    var appendToVaultNoteCalled = false
    var appendToVaultNoteCallCount = 0
    var deleteVaultNoteCalled = false
    var deleteVaultNoteCallCount = 0

    var lastCreateOrUpdateVaultNoteFile: File?
    var lastAppendToVaultNoteFile: File?
    var lastDeleteVaultNoteFilename: String?

    var listVaultDirectoryCalled = false
    var listVaultDirectoryCallCount = 0
    var lastListVaultDirectoryPath: String?
    var pathsToReturn: [String] = [
        "/vault/note1.md",
        "/vault/note2.md",
        "/vault/folder/note3.md"
    ]

    var searchVaultCalled = false
    var searchVaultCallCount = 0
    var lastSearchQuery: String?
    var searchResultsToReturn: [SearchResult] = [
        .init(path: "note1.md", score: 0.95),
        .init(path: "note2.md", score: 0.85),
        .init(path: "note3.md", score: 0.75)
    ]

    var lastSearchPath: String?

    // Frontmatter tracking
    var setActiveNoteFrontmatterCalled = false
    var appendToActiveNoteFrontmatterCalled = false
    var setVaultNoteFrontmatterCalled = false
    var appendToVaultNoteFrontmatterCalled = false

    var lastActiveNoteFrontmatterKey: String?
    var lastActiveNoteFrontmatterValue: String?
    var lastVaultNoteFrontmatterFilename: String?
    var lastVaultNoteFrontmatterKey: String?
    var lastVaultNoteFrontmatterValue: String?

    // Bulk operations tracking
    var bulkApplyTagsFromSearchCalled = false
    var bulkApplyTagsFromSearchCallCount = 0
    var lastBulkApplyTagsQuery: String?
    var lastBulkApplyTags: [String]?
    
    var bulkReplaceFrontmatterStringFromSearchCalled = false
    var bulkReplaceFrontmatterStringFromSearchCallCount = 0
    var lastBulkReplaceFrontmatterStringQuery: String?
    var lastBulkReplaceFrontmatterStringKey: String?
    var lastBulkReplaceFrontmatterStringValue: String?
    
    var bulkReplaceFrontmatterArrayFromSearchCalled = false
    var bulkReplaceFrontmatterArrayFromSearchCallCount = 0
    var lastBulkReplaceFrontmatterArrayQuery: String?
    var lastBulkReplaceFrontmatterArrayKey: String?
    var lastBulkReplaceFrontmatterArrayValue: [String]?
    
    var bulkAppendToFrontmatterStringFromSearchCalled = false
    var bulkAppendToFrontmatterStringFromSearchCallCount = 0
    var lastBulkAppendFrontmatterStringQuery: String?
    var lastBulkAppendFrontmatterStringKey: String?
    var lastBulkAppendFrontmatterStringValue: String?
    
    var bulkAppendToFrontmatterArrayFromSearchCalled = false
    var bulkAppendToFrontmatterArrayFromSearchCallCount = 0
    var lastBulkAppendFrontmatterArrayQuery: String?
    var lastBulkAppendFrontmatterArrayKey: String?
    var lastBulkAppendFrontmatterArrayValue: [String]?

    // Bulk operations result configuration
    var bulkOperationResultToReturn: BulkOperationResult?

    // MARK: - Response Configuration

    var searchVaultResult: Result<[SearchResult], Error> = .success([])

    private var serverInfoResult: Result<ServerInformation, Error> {
        if let error = errorToThrow {
            return .failure(error)
        }
        return .success(serverInfoToReturn)
    }

    private var activeNoteResult: Result<File, Error> {
        if let error = errorToThrow {
            return .failure(error)
        }
        return .success(activeNoteToReturn ?? File(filename: "MockNote.md", content: "# Mock Note Content"))
    }

    private var vaultNoteResult: Result<File, Error> {
        if let error = errorToThrow {
            return .failure(error)
        }
        return .success(vaultNoteToReturn ?? File(filename: "MockVaultNote.md", content: "# Mock Vault Note Content"))
    }

    private var vaultDirectoryResult: Result<[String], Error> {
        if let error = errorToThrow {
            return .failure(error)
        }
        return .success(pathsToReturn)
    }

    private var searchVaultResultComputed: Result<[SearchResult], Error> {
        // If searchVaultResult was explicitly set, use it, otherwise fall back to default behavior
        if case .success(let results) = searchVaultResult, !results.isEmpty {
            return searchVaultResult
        }
        if case .failure = searchVaultResult {
            return searchVaultResult
        }

        if let error = errorToThrow {
            return .failure(error)
        }
        return .success(searchResultsToReturn)
    }

    // MARK: - Error Configuration

    var shouldThrowErrorOnUpdateActiveNote = false
    var shouldThrowErrorOnDeleteActiveNote = false
    var shouldThrowErrorOnCreateOrUpdateVaultNote = false
    var shouldThrowErrorOnAppendToVaultNote = false
    var shouldThrowErrorOnDeleteVaultNote = false

    // MARK: - ObsidianRepositoryServerOperations

    func getServerInfo() async throws -> ServerInformation {
        getServerInfoCallCount += 1
        return try serverInfoResult.get()
    }

    // MARK: - ObsidianRepositoryActiveNoteOperations

    func getActiveNote() async throws -> File {
        getActiveNoteCalled = true
        getActiveNoteCallCount += 1
        return try activeNoteResult.get()
    }

    func updateActiveNote(content: String) async throws {
        updateActiveNoteCalled = true
        updateActiveNoteCallCount += 1
        lastUpdateActiveNoteContent = content

        if shouldThrowErrorOnUpdateActiveNote {
            throw MockError.updateFailed
        }
    }

    func deleteActiveNote() async throws {
        deleteActiveNoteCalled = true
        deleteActiveNoteCallCount += 1
        if let error = errorToThrow {
            throw error
        }
    }

    func setActiveNoteFrontmatterStringField(
        key: String,
        value: String
    ) async throws {
        setActiveNoteFrontmatterCalled = true
        lastActiveNoteFrontmatterKey = key
        lastActiveNoteFrontmatterValue = value
        if let error = errorToThrow {
            throw error
        }
    }

    func setActiveNoteFrontmatterArrayField(
        key: String,
        value: [String]
    ) async throws {
        setActiveNoteFrontmatterCalled = true
        lastActiveNoteFrontmatterKey = key
        lastActiveNoteFrontmatterValue = value.joined(separator: ",")
        if let error = errorToThrow {
            throw error
        }
    }

    func appendToActiveNoteFrontmatterStringField(
        key: String,
        value: String
    ) async throws {
        appendToActiveNoteFrontmatterCalled = true
        lastActiveNoteFrontmatterKey = key
        lastActiveNoteFrontmatterValue = value
        if let error = errorToThrow {
            throw error
        }
    }

    func appendToActiveNoteFrontmatterArrayField(
        key: String,
        value: [String]
    ) async throws {
        appendToActiveNoteFrontmatterCalled = true
        lastActiveNoteFrontmatterKey = key
        lastActiveNoteFrontmatterValue = value.joined(separator: ",")
        if let error = errorToThrow {
            throw error
        }
    }

    // MARK: - ObsidianRepositoryVaultNoteOperations

    func getVaultNote(filename: String) async throws -> File {
        getVaultNoteCalled = true
        getVaultNoteCallCount += 1
        lastGetVaultNoteFilename = filename
        return try vaultNoteResult.get()
    }

    func createOrUpdateVaultNote(file: File) async throws {
        createOrUpdateVaultNoteCalled = true
        createOrUpdateVaultNoteCallCount += 1
        lastCreateOrUpdateVaultNoteFile = file

        if shouldThrowErrorOnCreateOrUpdateVaultNote {
            throw MockError.createOrUpdateFailed
        }
    }

    func appendToVaultNote(file: File) async throws {
        appendToVaultNoteCalled = true
        appendToVaultNoteCallCount += 1
        lastAppendToVaultNoteFile = file

        if shouldThrowErrorOnAppendToVaultNote {
            throw MockError.appendFailed
        }
    }

    func deleteVaultNote(filename: String) async throws {
        deleteVaultNoteCalled = true
        deleteVaultNoteCallCount += 1
        lastDeleteVaultNoteFilename = filename
        if shouldThrowErrorOnDeleteVaultNote || errorToThrow != nil {
            throw errorToThrow ?? MockError.deleteFailed
        }
    }

    func setVaultNoteFrontmatterStringField(
        filename: String,
        key: String,
        value: String
    ) async throws {
        setVaultNoteFrontmatterCalled = true
        lastVaultNoteFrontmatterFilename = filename
        lastVaultNoteFrontmatterKey = key
        lastVaultNoteFrontmatterValue = value
        if let error = errorToThrow {
            throw error
        }
    }

    func setVaultNoteFrontmatterArrayField(
        filename: String,
        key: String,
        value: [String]
    ) async throws {
        setVaultNoteFrontmatterCalled = true
        lastVaultNoteFrontmatterFilename = filename
        lastVaultNoteFrontmatterKey = key
        lastVaultNoteFrontmatterValue = value.joined(separator: ",")
        if let error = errorToThrow {
            throw error
        }
    }

    func appendToVaultNoteFrontmatterStringField(
        filename: String,
        key: String,
        value: String
    ) async throws {
        appendToVaultNoteFrontmatterCalled = true
        lastVaultNoteFrontmatterFilename = filename
        lastVaultNoteFrontmatterKey = key
        lastVaultNoteFrontmatterValue = value
        if let error = errorToThrow {
            throw error
        }
    }

    func appendToVaultNoteFrontmatterArrayField(
        filename: String,
        key: String,
        value: [String]
    ) async throws {
        appendToVaultNoteFrontmatterCalled = true
        lastVaultNoteFrontmatterFilename = filename
        lastVaultNoteFrontmatterKey = key
        lastVaultNoteFrontmatterValue = value.joined(separator: ",")
        if let error = errorToThrow {
            throw error
        }
    }

    // MARK: - ObsidianRepositoryVaultOperations

    func listVaultDirectory(directory: String) async throws -> [String] {
        listVaultDirectoryCalled = true
        listVaultDirectoryCallCount += 1
        lastListVaultDirectoryPath = directory

        return try vaultDirectoryResult.get()
    }

    // MARK: - ObsidianRepositorySearchOperations

    func searchVault(
        query: String
    ) async throws -> [SearchResult] {
        searchVaultCalled = true
        searchVaultCallCount += 1
        lastSearchQuery = query
        return try searchVaultResultComputed.get()
    }

    // MARK: - ObsidianRepositoryBulkOperations

    func bulkApplyTagsFromSearch(
        query: String,
        tags: [String]
    ) async throws -> BulkOperationResult {
        bulkApplyTagsFromSearchCalled = true
        bulkApplyTagsFromSearchCallCount += 1
        lastBulkApplyTagsQuery = query
        lastBulkApplyTags = tags
        
        if let error = errorToThrow {
            throw error
        }
        
        return bulkOperationResultToReturn!
    }

    func bulkReplaceFrontmatterStringFromSearch(
        query: String,
        key: String,
        value: String
    ) async throws -> BulkOperationResult {
        bulkReplaceFrontmatterStringFromSearchCalled = true
        bulkReplaceFrontmatterStringFromSearchCallCount += 1
        lastBulkReplaceFrontmatterStringQuery = query
        lastBulkReplaceFrontmatterStringKey = key
        lastBulkReplaceFrontmatterStringValue = value
        
        if let error = errorToThrow {
            throw error
        }
        
        return bulkOperationResultToReturn!
    }

    func bulkReplaceFrontmatterArrayFromSearch(
        query: String,
        key: String,
        value: [String]
    ) async throws -> BulkOperationResult {
        bulkReplaceFrontmatterArrayFromSearchCalled = true
        bulkReplaceFrontmatterArrayFromSearchCallCount += 1
        lastBulkReplaceFrontmatterArrayQuery = query
        lastBulkReplaceFrontmatterArrayKey = key
        lastBulkReplaceFrontmatterArrayValue = value
        
        if let error = errorToThrow {
            throw error
        }
        
        return bulkOperationResultToReturn!
    }

    func bulkAppendToFrontmatterStringFromSearch(
        query: String,
        key: String,
        value: String
    ) async throws -> BulkOperationResult {
        bulkAppendToFrontmatterStringFromSearchCalled = true
        bulkAppendToFrontmatterStringFromSearchCallCount += 1
        lastBulkAppendFrontmatterStringQuery = query
        lastBulkAppendFrontmatterStringKey = key
        lastBulkAppendFrontmatterStringValue = value
        
        if let error = errorToThrow {
            throw error
        }
        
        return bulkOperationResultToReturn!
    }

    func bulkAppendToFrontmatterArrayFromSearch(
        query: String,
        key: String,
        value: [String]
    ) async throws -> BulkOperationResult {
        bulkAppendToFrontmatterArrayFromSearchCalled = true
        bulkAppendToFrontmatterArrayFromSearchCallCount += 1
        lastBulkAppendFrontmatterArrayQuery = query
        lastBulkAppendFrontmatterArrayKey = key
        lastBulkAppendFrontmatterArrayValue = value
        
        if let error = errorToThrow {
            throw error
        }
        
        return bulkOperationResultToReturn!
    }
}

enum MockError: Error {
    case updateFailed
    case deleteFailed
    case patchFailed
    case createOrUpdateFailed
    case appendFailed
}
