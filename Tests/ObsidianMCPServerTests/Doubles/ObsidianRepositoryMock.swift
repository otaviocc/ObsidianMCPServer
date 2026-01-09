import Foundation
@testable import ObsidianRepository

// swiftlint:disable force_unwrapping

final class ObsidianRepositoryMock: ObsidianRepositoryProtocol {

    // MARK: - Properties

    var serverInfoToReturn: ServerInformation = .init(service: "mock-obsidian-api", version: "1.0.0")
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
        if case let .success(results) = searchVaultResult, !results.isEmpty {
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

    // MARK: - Periodic Notes Operations

    var getPeriodicNoteCalled = false
    var getPeriodicNoteCallCount = 0
    var lastPeriodicNotePeriod: String?
    var periodicNoteFileToReturn: File?

    var createOrUpdatePeriodicNoteCalled = false
    var createOrUpdatePeriodicNoteCallCount = 0
    var lastCreateOrUpdatePeriodicNotePeriod: String?
    var lastCreateOrUpdatePeriodicNoteContent: String?

    var appendToPeriodicNoteCalled = false
    var appendToPeriodicNoteCallCount = 0
    var lastAppendToPeriodicNotePeriod: String?
    var lastAppendToPeriodicNoteContent: String?

    var deletePeriodicNoteCalled = false
    var deletePeriodicNoteCallCount = 0
    var lastDeletePeriodicNotePeriod: String?

    func getPeriodicNote(period: String) async throws -> File {
        getPeriodicNoteCalled = true
        getPeriodicNoteCallCount += 1
        lastPeriodicNotePeriod = period

        if let error = errorToThrow {
            throw error
        }

        return periodicNoteFileToReturn!
    }

    func createOrUpdatePeriodicNote(
        period: String,
        content: String
    ) async throws {
        createOrUpdatePeriodicNoteCalled = true
        createOrUpdatePeriodicNoteCallCount += 1
        lastCreateOrUpdatePeriodicNotePeriod = period
        lastCreateOrUpdatePeriodicNoteContent = content

        if let error = errorToThrow {
            throw error
        }
    }

    func appendToPeriodicNote(
        period: String,
        content: String
    ) async throws {
        appendToPeriodicNoteCalled = true
        appendToPeriodicNoteCallCount += 1
        lastAppendToPeriodicNotePeriod = period
        lastAppendToPeriodicNoteContent = content

        if let error = errorToThrow {
            throw error
        }
    }

    func deletePeriodicNote(period: String) async throws {
        deletePeriodicNoteCalled = true
        deletePeriodicNoteCallCount += 1
        lastDeletePeriodicNotePeriod = period

        if let error = errorToThrow {
            throw error
        }
    }

    // MARK: - Parametrized Periodic Notes Operations

    // Additional properties for tracking date-specific calls
    var getPeriodicNoteWithDateCalled = false
    var getPeriodicNoteWithDateCallCount = 0
    var lastPeriodicNoteWithDatePeriod: String?
    var lastPeriodicNoteWithDateYear: Int?
    var lastPeriodicNoteWithDateMonth: Int?
    var lastPeriodicNoteWithDateDay: Int?

    // Properties for tracking specific period type calls (for test compatibility)
    var deleteDailyNoteCallCount = 0
    var deleteWeeklyNoteCallCount = 0
    var deleteMonthlyNoteCallCount = 0
    var deleteQuarterlyNoteCallCount = 0
    var deleteYearlyNoteCallCount = 0

    var lastDeleteYear: Int?
    var lastDeleteMonth: Int?
    var lastDeleteDay: Int?

    var appendToDailyNoteCallCount = 0
    var appendToWeeklyNoteCallCount = 0
    var appendToMonthlyNoteCallCount = 0
    var appendToQuarterlyNoteCallCount = 0
    var appendToYearlyNoteCallCount = 0

    var lastAppendYear: Int?
    var lastAppendMonth: Int?
    var lastAppendDay: Int?
    var lastAppendContent: String?

    var createOrUpdateDailyNoteCallCount = 0
    var createOrUpdateWeeklyNoteCallCount = 0
    var createOrUpdateMonthlyNoteCallCount = 0
    var createOrUpdateQuarterlyNoteCallCount = 0
    var createOrUpdateYearlyNoteCallCount = 0

    var lastCreateOrUpdateYear: Int?
    var lastCreateOrUpdateMonth: Int?
    var lastCreateOrUpdateDay: Int?
    var lastCreateOrUpdateContent: String?

    var createOrUpdatePeriodicNoteWithDateCalled = false
    var createOrUpdatePeriodicNoteWithDateCallCount = 0
    var lastCreateOrUpdatePeriodicNoteWithDatePeriod: String?
    var lastCreateOrUpdatePeriodicNoteWithDateContent: String?
    var lastCreateOrUpdatePeriodicNoteWithDateYear: Int?
    var lastCreateOrUpdatePeriodicNoteWithDateMonth: Int?
    var lastCreateOrUpdatePeriodicNoteWithDateDay: Int?

    var appendToPeriodicNoteWithDateCalled = false
    var appendToPeriodicNoteWithDateCallCount = 0
    var lastAppendToPeriodicNoteWithDatePeriod: String?
    var lastAppendToPeriodicNoteWithDateContent: String?
    var lastAppendToPeriodicNoteWithDateYear: Int?
    var lastAppendToPeriodicNoteWithDateMonth: Int?
    var lastAppendToPeriodicNoteWithDateDay: Int?

    var deletePeriodicNoteWithDateCalled = false
    var deletePeriodicNoteWithDateCallCount = 0
    var lastDeletePeriodicNoteWithDatePeriod: String?
    var lastDeletePeriodicNoteWithDateYear: Int?
    var lastDeletePeriodicNoteWithDateMonth: Int?
    var lastDeletePeriodicNoteWithDateDay: Int?

    func getPeriodicNote(
        period: String,
        year: Int,
        month: Int,
        day: Int
    ) async throws -> File {
        getPeriodicNoteWithDateCalled = true
        getPeriodicNoteWithDateCallCount += 1
        lastPeriodicNoteWithDatePeriod = period
        lastPeriodicNoteWithDateYear = year
        lastPeriodicNoteWithDateMonth = month
        lastPeriodicNoteWithDateDay = day

        if let error = errorToThrow {
            throw error
        }

        return periodicNoteFileToReturn!
    }

    func createOrUpdatePeriodicNote(
        period: String,
        content: String,
        year: Int,
        month: Int,
        day: Int
    ) async throws {
        createOrUpdatePeriodicNoteWithDateCalled = true
        createOrUpdatePeriodicNoteWithDateCallCount += 1
        lastCreateOrUpdatePeriodicNoteWithDatePeriod = period
        lastCreateOrUpdatePeriodicNoteWithDateContent = content
        lastCreateOrUpdatePeriodicNoteWithDateYear = year
        lastCreateOrUpdatePeriodicNoteWithDateMonth = month
        lastCreateOrUpdatePeriodicNoteWithDateDay = day

        lastCreateOrUpdateYear = year
        lastCreateOrUpdateMonth = month
        lastCreateOrUpdateDay = day
        lastCreateOrUpdateContent = content

        switch period.lowercased() {
        case "daily": createOrUpdateDailyNoteCallCount += 1
        case "weekly": createOrUpdateWeeklyNoteCallCount += 1
        case "monthly": createOrUpdateMonthlyNoteCallCount += 1
        case "quarterly": createOrUpdateQuarterlyNoteCallCount += 1
        case "yearly": createOrUpdateYearlyNoteCallCount += 1
        default: break
        }

        if let error = errorToThrow {
            throw error
        }
    }

    func appendToPeriodicNote(
        period: String,
        content: String,
        year: Int,
        month: Int,
        day: Int
    ) async throws {
        appendToPeriodicNoteWithDateCalled = true
        appendToPeriodicNoteWithDateCallCount += 1
        lastAppendToPeriodicNoteWithDatePeriod = period
        lastAppendToPeriodicNoteWithDateContent = content
        lastAppendToPeriodicNoteWithDateYear = year
        lastAppendToPeriodicNoteWithDateMonth = month
        lastAppendToPeriodicNoteWithDateDay = day

        lastAppendYear = year
        lastAppendMonth = month
        lastAppendDay = day
        lastAppendContent = content

        switch period.lowercased() {
        case "daily": appendToDailyNoteCallCount += 1
        case "weekly": appendToWeeklyNoteCallCount += 1
        case "monthly": appendToMonthlyNoteCallCount += 1
        case "quarterly": appendToQuarterlyNoteCallCount += 1
        case "yearly": appendToYearlyNoteCallCount += 1
        default: break
        }

        if let error = errorToThrow {
            throw error
        }
    }

    func deletePeriodicNote(
        period: String,
        year: Int,
        month: Int,
        day: Int
    ) async throws {
        deletePeriodicNoteWithDateCalled = true
        deletePeriodicNoteWithDateCallCount += 1
        lastDeletePeriodicNoteWithDatePeriod = period
        lastDeletePeriodicNoteWithDateYear = year
        lastDeletePeriodicNoteWithDateMonth = month
        lastDeletePeriodicNoteWithDateDay = day

        lastDeleteYear = year
        lastDeleteMonth = month
        lastDeleteDay = day

        switch period.lowercased() {
        case "daily": deleteDailyNoteCallCount += 1
        case "weekly": deleteWeeklyNoteCallCount += 1
        case "monthly": deleteMonthlyNoteCallCount += 1
        case "quarterly": deleteQuarterlyNoteCallCount += 1
        case "yearly": deleteYearlyNoteCallCount += 1
        default: break
        }

        if let error = errorToThrow {
            throw error
        }
    }
}

enum MockError: Error {

    case updateFailed
    case deleteFailed
    case patchFailed
    case createOrUpdateFailed
    case appendFailed
}

// swiftlint:enable force_unwrapping
