import Foundation
@testable import ObsidianMCPServer

// swiftlint:disable discouraged_optional_boolean identifier_name

final class ObsidianRepositoryMock: ObsidianRepositoryProtocol {

    // MARK: - Call Tracking

    var getServerInfoCallCount = 0
    var getActiveNoteCallCount = 0
    var updateActiveNoteCallCount = 0
    var deleteActiveNoteCallCount = 0
    var patchActiveNoteCallCount = 0
    var getVaultNoteCallCount = 0
    var createOrUpdateVaultNoteCallCount = 0
    var appendToVaultNoteCallCount = 0
    var deleteVaultNoteCallCount = 0
    var patchVaultNoteCallCount = 0
    var listVaultDirectoryCallCount = 0
    var searchVaultCallCount = 0
    var searchVaultInPathCallCount = 0

    // MARK: - Parameter Tracking

    var lastUpdateActiveNoteContent: String?
    var lastPatchActiveNoteContent: String?
    var lastPatchActiveNoteParameters: PatchParameters?
    var lastGetVaultNoteFilename: String?
    var lastCreateOrUpdateVaultNoteFile: File?
    var lastAppendToVaultNoteFile: File?
    var lastDeleteVaultNoteFilename: String?
    var lastPatchVaultNoteFile: File?
    var lastPatchVaultNoteParameters: PatchParameters?
    var lastListVaultDirectoryPath: String?
    var lastSearchVaultQuery: String?
    var lastSearchVaultIgnoreCase: Bool?
    var lastSearchVaultWholeWord: Bool?
    var lastSearchVaultIsRegex: Bool?
    var lastSearchVaultInPathQuery: String?
    var lastSearchVaultInPathPath: String?
    var lastSearchVaultInPathIgnoreCase: Bool?
    var lastSearchVaultInPathWholeWord: Bool?
    var lastSearchVaultInPathIsRegex: Bool?

    // MARK: - Response Configuration

    var serverInfoResult: Result<ServerInformation, Error> = .success(
        ServerInformation(service: "mock-obsidian-api", version: "1.0.0")
    )

    var activeNoteResult: Result<File, Error> = .success(
        File(filename: "MockNote.md", content: "# Mock Note Content")
    )

    var vaultNoteResult: Result<File, Error> = .success(
        File(filename: "MockVaultNote.md", content: "# Mock Vault Note Content")
    )

    var vaultDirectoryResult: Result<[URL], Error> = .success([
        URL(fileURLWithPath: "/vault/note1.md"),
        URL(fileURLWithPath: "/vault/note2.md"),
        URL(fileURLWithPath: "/vault/folder/note3.md")
    ])

    var searchVaultResult: Result<[SearchResult], Error> = .success([
        SearchResult(path: "note1.md", score: 0.95),
        SearchResult(path: "note2.md", score: 0.80),
        SearchResult(path: "folder/note3.md", score: 0.60)
    ])

    var searchVaultInPathResult: Result<[SearchResult], Error> = .success([
        SearchResult(path: "folder/note3.md", score: 0.85),
        SearchResult(path: "folder/note4.md", score: 0.70)
    ])

    // MARK: - Error Configuration

    var shouldThrowErrorOnUpdateActiveNote = false
    var shouldThrowErrorOnDeleteActiveNote = false
    var shouldThrowErrorOnPatchActiveNote = false
    var shouldThrowErrorOnCreateOrUpdateVaultNote = false
    var shouldThrowErrorOnAppendToVaultNote = false
    var shouldThrowErrorOnDeleteVaultNote = false
    var shouldThrowErrorOnPatchVaultNote = false

    // MARK: - ObsidianRepositoryServerOperations

    func getServerInfo() async throws -> ServerInformation {
        getServerInfoCallCount += 1
        return try serverInfoResult.get()
    }

    // MARK: - ObsidianRepositoryActiveNoteOperations

    func getActiveNote() async throws -> File {
        getActiveNoteCallCount += 1
        return try activeNoteResult.get()
    }

    func updateActiveNote(content: String) async throws {
        updateActiveNoteCallCount += 1
        lastUpdateActiveNoteContent = content

        if shouldThrowErrorOnUpdateActiveNote {
            throw MockError.updateFailed
        }
    }

    func deleteActiveNote() async throws {
        deleteActiveNoteCallCount += 1

        if shouldThrowErrorOnDeleteActiveNote {
            throw MockError.deleteFailed
        }
    }

    func patchActiveNote(
        content: String,
        parameters: PatchParameters
    ) async throws {
        patchActiveNoteCallCount += 1
        lastPatchActiveNoteContent = content
        lastPatchActiveNoteParameters = parameters

        if shouldThrowErrorOnPatchActiveNote {
            throw MockError.patchFailed
        }
    }

    // MARK: - ObsidianRepositoryVaultNoteOperations

    func getVaultNote(filename: String) async throws -> File {
        getVaultNoteCallCount += 1
        lastGetVaultNoteFilename = filename
        return try vaultNoteResult.get()
    }

    func createOrUpdateVaultNote(file: File) async throws {
        createOrUpdateVaultNoteCallCount += 1
        lastCreateOrUpdateVaultNoteFile = file

        if shouldThrowErrorOnCreateOrUpdateVaultNote {
            throw MockError.createOrUpdateFailed
        }
    }

    func appendToVaultNote(file: File) async throws {
        appendToVaultNoteCallCount += 1
        lastAppendToVaultNoteFile = file

        if shouldThrowErrorOnAppendToVaultNote {
            throw MockError.appendFailed
        }
    }

    func deleteVaultNote(filename: String) async throws {
        deleteVaultNoteCallCount += 1
        lastDeleteVaultNoteFilename = filename

        if shouldThrowErrorOnDeleteVaultNote {
            throw MockError.deleteFailed
        }
    }

    func patchVaultNote(
        file: File,
        parameters: PatchParameters
    ) async throws {
        patchVaultNoteCallCount += 1
        lastPatchVaultNoteFile = file
        lastPatchVaultNoteParameters = parameters

        if shouldThrowErrorOnPatchVaultNote {
            throw MockError.patchFailed
        }
    }

    // MARK: - ObsidianRepositoryVaultOperations

    func listVaultDirectory(directory: String) async throws -> [URL] {
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
        searchVaultCallCount += 1
        lastSearchVaultQuery = query
        lastSearchVaultIgnoreCase = ignoreCase
        lastSearchVaultWholeWord = wholeWord
        lastSearchVaultIsRegex = isRegex
        return try searchVaultResult.get()
    }

    func searchVaultInPath(
        query: String,
        path: String,
        ignoreCase: Bool,
        wholeWord: Bool,
        isRegex: Bool
    ) async throws -> [SearchResult] {
        searchVaultInPathCallCount += 1
        lastSearchVaultInPathQuery = query
        lastSearchVaultInPathPath = path
        lastSearchVaultInPathIgnoreCase = ignoreCase
        lastSearchVaultInPathWholeWord = wholeWord
        lastSearchVaultInPathIsRegex = isRegex
        return try searchVaultInPathResult.get()
    }

    // MARK: - Helper Methods

    func reset() {
        getServerInfoCallCount = 0
        getActiveNoteCallCount = 0
        updateActiveNoteCallCount = 0
        deleteActiveNoteCallCount = 0
        patchActiveNoteCallCount = 0
        getVaultNoteCallCount = 0
        createOrUpdateVaultNoteCallCount = 0
        appendToVaultNoteCallCount = 0
        deleteVaultNoteCallCount = 0
        patchVaultNoteCallCount = 0
        listVaultDirectoryCallCount = 0
        searchVaultCallCount = 0
        searchVaultInPathCallCount = 0

        lastUpdateActiveNoteContent = nil
        lastPatchActiveNoteContent = nil
        lastPatchActiveNoteParameters = nil
        lastGetVaultNoteFilename = nil
        lastCreateOrUpdateVaultNoteFile = nil
        lastAppendToVaultNoteFile = nil
        lastDeleteVaultNoteFilename = nil
        lastPatchVaultNoteFile = nil
        lastPatchVaultNoteParameters = nil
        lastListVaultDirectoryPath = nil
        lastSearchVaultQuery = nil
        lastSearchVaultIgnoreCase = nil
        lastSearchVaultWholeWord = nil
        lastSearchVaultIsRegex = nil
        lastSearchVaultInPathQuery = nil
        lastSearchVaultInPathPath = nil
        lastSearchVaultInPathIgnoreCase = nil
        lastSearchVaultInPathWholeWord = nil
        lastSearchVaultInPathIsRegex = nil

        shouldThrowErrorOnUpdateActiveNote = false
        shouldThrowErrorOnDeleteActiveNote = false
        shouldThrowErrorOnPatchActiveNote = false
        shouldThrowErrorOnCreateOrUpdateVaultNote = false
        shouldThrowErrorOnAppendToVaultNote = false
        shouldThrowErrorOnDeleteVaultNote = false
        shouldThrowErrorOnPatchVaultNote = false
    }
}

enum MockError: Error {
    case updateFailed
    case deleteFailed
    case patchFailed
    case createOrUpdateFailed
    case appendFailed
}

// swiftlint:enable discouraged_optional_boolean identifier_name
