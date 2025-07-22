import Foundation
@testable import ObsidianRepository

final class ObsidianRepositoryMock: ObsidianRepositoryProtocol {

    // MARK: - Properties

    var serverInfoToReturn: ServerInformation = ServerInformation(service: "mock-obsidian-api", version: "1.0.0")
    var errorToThrow: Error?

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
    var lastSearchVaultQuery: String?
    var lastSearchIgnoreCase: Bool?
    var lastSearchVaultIgnoreCase: Bool?
    var lastSearchWholeWord: Bool?
    var lastSearchVaultWholeWord: Bool?
    var lastSearchIsRegex: Bool?
    var lastSearchVaultIsRegex: Bool?
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
        return .success(File(filename: "MockNote.md", content: "# Mock Note Content"))
    }

    private var vaultNoteResult: Result<File, Error> {
        if let error = errorToThrow {
            return .failure(error)
        }
        return .success(File(filename: "MockVaultNote.md", content: "# Mock Vault Note Content"))
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

    func setActiveNoteFrontmatterField(
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

    func appendToActiveNoteFrontmatterField(
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

    func setVaultNoteFrontmatterField(
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

    func appendToVaultNoteFrontmatterField(
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

    // MARK: - ObsidianRepositoryVaultOperations

    func listVaultDirectory(directory: String) async throws -> [String] {
        listVaultDirectoryCalled = true
        listVaultDirectoryCallCount += 1
        lastListVaultDirectoryPath = directory

        return try vaultDirectoryResult.get()
    }

    // MARK: - ObsidianRepositorySearchOperations

    func searchVault(
        query: String,
        ignoreCase: Bool,
        wholeWord: Bool,
        isRegex: Bool
    ) async throws -> [SearchResult] {
        searchVaultCalled = true
        searchVaultCallCount += 1
        lastSearchQuery = query
        lastSearchVaultQuery = query
        lastSearchIgnoreCase = ignoreCase
        lastSearchVaultIgnoreCase = ignoreCase
        lastSearchWholeWord = wholeWord
        lastSearchVaultWholeWord = wholeWord
        lastSearchIsRegex = isRegex
        lastSearchVaultIsRegex = isRegex
        return try searchVaultResultComputed.get()
    }
}

enum MockError: Error {
    case updateFailed
    case deleteFailed
    case patchFailed
    case createOrUpdateFailed
    case appendFailed
}
