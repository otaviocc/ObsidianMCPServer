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
    func getPeriodicNote(
        period _: String,
        year _: Int,
        month _: Int,
        day _: Int
    ) async throws -> File {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdatePeriodicNote(
        period _: String,
        content _: String,
        year _: Int,
        month _: Int,
        day _: Int
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToPeriodicNote(
        period _: String,
        content _: String,
        year _: Int,
        month _: Int,
        day _: Int
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deletePeriodicNote(
        period _: String,
        year _: Int,
        month _: Int,
        day _: Int
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func getServerInfo() async throws -> ServerInformation {
        fatalError("Not implemented for prompt tests")
    }

    func updateActiveNote(content _: String) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteActiveNote() async throws {
        fatalError("Not implemented for prompt tests")
    }

    func setActiveNoteFrontmatterStringField(
        key _: String,
        value _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func setActiveNoteFrontmatterArrayField(
        key _: String,
        value _: [String]
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToActiveNoteFrontmatterStringField(
        key _: String,
        value _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToActiveNoteFrontmatterArrayField(
        key _: String,
        value _: [String]
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdateVaultNote(file _: File) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToVaultNote(file _: File) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteVaultNote(filename _: String) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func setVaultNoteFrontmatterStringField(
        filename _: String,
        key _: String,
        value _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func setVaultNoteFrontmatterArrayField(
        filename _: String,
        key _: String,
        value _: [String]
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToVaultNoteFrontmatterStringField(
        filename _: String,
        key _: String,
        value _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToVaultNoteFrontmatterArrayField(
        filename _: String,
        key _: String,
        value _: [String]
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func listVaultDirectory(directory _: String) async throws -> [String] {
        fatalError("Not implemented for prompt tests")
    }

    func searchVault(query _: String) async throws -> [SearchResult] {
        fatalError("Not implemented for prompt tests")
    }

    func bulkApplyTagsFromSearch(
        query _: String,
        tags _: [String]
    ) async throws -> BulkOperationResult {
        fatalError("Not implemented for prompt tests")
    }

    func bulkReplaceFrontmatterStringFromSearch(
        query _: String,
        key _: String,
        value _: String
    ) async throws -> BulkOperationResult {
        fatalError("Not implemented for prompt tests")
    }

    func bulkReplaceFrontmatterArrayFromSearch(
        query _: String,
        key _: String,
        value _: [String]
    ) async throws -> BulkOperationResult {
        fatalError("Not implemented for prompt tests")
    }

    func bulkAppendToFrontmatterStringFromSearch(
        query _: String,
        key _: String,
        value _: String
    ) async throws -> BulkOperationResult {
        fatalError("Not implemented for prompt tests")
    }

    func bulkAppendToFrontmatterArrayFromSearch(
        query _: String,
        key _: String,
        value _: [String]
    ) async throws -> BulkOperationResult {
        fatalError("Not implemented for prompt tests")
    }

    func getPeriodicNote(period _: String) async throws -> File {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdatePeriodicNote(
        period _: String,
        content _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToPeriodicNote(
        period _: String,
        content _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deletePeriodicNote(period _: String) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteDailyNote(
        year _: Int,
        month _: Int,
        day _: Int
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteWeeklyNote(
        year _: Int,
        month _: Int,
        day _: Int
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteMonthlyNote(
        year _: Int,
        month _: Int,
        day _: Int
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteQuarterlyNote(
        year _: Int,
        month _: Int,
        day _: Int
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteYearlyNote(
        year _: Int,
        month _: Int,
        day _: Int
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToDailyNote(
        year _: Int,
        month _: Int,
        day _: Int,
        content _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToWeeklyNote(
        year _: Int,
        month _: Int,
        day _: Int,
        content _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToMonthlyNote(
        year _: Int,
        month _: Int,
        day _: Int,
        content _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToQuarterlyNote(
        year _: Int,
        month _: Int,
        day _: Int,
        content _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToYearlyNote(
        year _: Int,
        month _: Int,
        day _: Int,
        content _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdateDailyNote(
        year _: Int,
        month _: Int,
        day _: Int,
        content _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdateWeeklyNote(
        year _: Int,
        month _: Int,
        day _: Int,
        content _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdateMonthlyNote(
        year _: Int,
        month _: Int,
        day _: Int,
        content _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdateQuarterlyNote(
        year _: Int,
        month _: Int,
        day _: Int,
        content _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdateYearlyNote(
        year _: Int,
        month _: Int,
        day _: Int,
        content _: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }
    // swiftlint:enable unavailable_function
}
