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

    func bulkReplaceFrontmatterStringFromSearch(
        query: String,
        key: String,
        value: String
    ) async throws -> BulkOperationResult {
        fatalError("Not implemented for prompt tests")
    }

    func bulkReplaceFrontmatterArrayFromSearch(
        query: String,
        key: String,
        value: [String]
    ) async throws -> BulkOperationResult {
        fatalError("Not implemented for prompt tests")
    }

    func bulkAppendToFrontmatterStringFromSearch(
        query: String,
        key: String,
        value: String
    ) async throws -> BulkOperationResult {
        fatalError("Not implemented for prompt tests")
    }

    func bulkAppendToFrontmatterArrayFromSearch(
        query: String,
        key: String,
        value: [String]
    ) async throws -> BulkOperationResult {
        fatalError("Not implemented for prompt tests")
    }

    func getPeriodicNote(period: String) async throws -> File {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdatePeriodicNote(
        period: String,
        content: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToPeriodicNote(
        period: String,
        content: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deletePeriodicNote(period: String) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteDailyNote(
        year: Int,
        month: Int,
        day: Int
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteWeeklyNote(
        year: Int,
        month: Int,
        day: Int
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteMonthlyNote(
        year: Int,
        month: Int,
        day: Int
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteQuarterlyNote(
        year: Int,
        month: Int,
        day: Int
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteYearlyNote(
        year: Int,
        month: Int,
        day: Int
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToDailyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToWeeklyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToMonthlyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToQuarterlyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToYearlyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdateDailyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdateWeeklyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdateMonthlyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdateQuarterlyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdateYearlyNote(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }
    // swiftlint:enable unavailable_function
}
