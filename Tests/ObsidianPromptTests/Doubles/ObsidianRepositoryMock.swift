import Foundation
@testable import ObsidianRepository

final class ObsidianRepositoryMock: ObsidianRepositoryProtocol {

    // MARK: - Nested type

    enum MockError: Error {
        case someMockError
    }

    // MARK: - getVaultNote

    var getVaultNoteCallsCount = 0
    var getVaultNoteReceivedArguments: String?
    var getVaultNoteReturnValue: File!
    var getVaultNoteThrowableError: Error?

    func getVaultNote(filename: String) async throws -> File {
        getVaultNoteCallsCount += 1
        getVaultNoteReceivedArguments = filename

        if let error = getVaultNoteThrowableError {
            throw error
        }

        return getVaultNoteReturnValue
    }

    // MARK: - getActiveNote

    var getActiveNoteCallsCount = 0
    var getActiveNoteReturnValue: File!
    var getActiveNoteThrowableError: Error?

    func getActiveNote() async throws -> File {
        getActiveNoteCallsCount += 1

        if let error = getActiveNoteThrowableError {
            throw error
        }

        return getActiveNoteReturnValue
    }

    // MARK: - Unused Protocol Methods

    // swiftlint:disable unavailable_function
    func getServerInfo() async throws -> ServerInformation {
        fatalError("Not implemented for prompt tests")
    }

    func updateActiveNote(content: String) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteActiveNote() async throws {
        fatalError("Not implemented for prompt tests")
    }

    func setActiveNoteFrontmatterStringField(
        key: String,
        value: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func setActiveNoteFrontmatterArrayField(
        key: String,
        value: [String]
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToActiveNoteFrontmatterStringField(
        key: String,
        value: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToActiveNoteFrontmatterArrayField(
        key: String,
        value: [String]
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdateVaultNote(file: File) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToVaultNote(file: File) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteVaultNote(filename: String) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func setVaultNoteFrontmatterStringField(
        filename: String,
        key: String,
        value: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func setVaultNoteFrontmatterArrayField(
        filename: String,
        key: String,
        value: [String]
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToVaultNoteFrontmatterStringField(
        filename: String,
        key: String,
        value: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToVaultNoteFrontmatterArrayField(
        filename: String,
        key: String,
        value: [String]
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func listVaultDirectory(directory: String) async throws -> [String] {
        fatalError("Not implemented for prompt tests")
    }

    func searchVault(query: String) async throws -> [SearchResult] {
        fatalError("Not implemented for prompt tests")
    }

    func bulkApplyTagsFromSearch(
        query: String,
        tags: [String]
    ) async throws -> BulkOperationResult {
        fatalError("Not implemented for prompt tests")
    }

    func bulkReplaceFrontmatterFromSearch(
        query: String,
        key: String,
        value: [String]
    ) async throws -> BulkOperationResult {
        fatalError("Not implemented for prompt tests")
    }

    func bulkAppendToFrontmatterFromSearch(
        query: String,
        key: String,
        value: [String]
    ) async throws -> BulkOperationResult {
        fatalError("Not implemented for prompt tests")
    }
    // swiftlint:enable unavailable_function
}
