import MicroClient
import Testing

@testable import ObsidianNetworking

@Suite("ObsidianRequestFactory Tests")
struct ObsidianRequestFactoryTests {

    let factory = ObsidianRequestFactory()

    // MARK: - Server Info Tests

    @Test("It should create server info request")
    func makeServerInfoRequest() {
        // When
        let request = factory.makeServerInfoRequest()

        // Then
        #expect(
            request.path == "/",
            "It should use root path"
        )
        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    // MARK: - Active File Tests

    @Test("It should create get active file request")
    func makeGetActiveFileRequest() {
        // When
        let request = factory.makeGetActiveFileRequest()

        // Then
        #expect(
            request.path == "/active/",
            "It should use active note path"
        )
        #expect(
            request.method == .get,
            "It should use GET method"
        )
        #expect(
            request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json",
            "It should set correct Accept header"
        )
    }

    @Test("It should create get active file JSON request")
    func makeGetActiveFileJsonRequest() {
        // When
        let request = factory.makeGetActiveFileJsonRequest()

        // Then
        #expect(
            request.path == "/active/",
            "It should use active note path"
        )
        #expect(
            request.method == .get,
            "It should use GET method"
        )
        #expect(
            request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json",
            "It should set correct Accept header"
        )
    }

    @Test("It should create update active file request")
    func makeUpdateActiveFileRequest() {
        // Given
        let content = "# Updated Note Content\nThis is the new content."

        // When
        let request = factory.makeUpdateActiveFileRequest(content: content)

        // Then
        #expect(
            request.path == "/active/",
            "It should use active note path"
        )
        #expect(
            request.method == .put,
            "It should use PUT method"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown; charset=utf-8",
            "It should set correct Content-Type header"
        )
    }

    @Test("It should create delete active file request")
    func makeDeleteActiveFileRequest() {
        // When
        let request = factory.makeDeleteActiveFileRequest()

        // Then
        #expect(
            request.path == "/active/",
            "It should use active note path"
        )
        #expect(
            request.method == .delete,
            "It should use DELETE method"
        )
    }

    @Test("It should create set active frontmatter request with replace operation")
    func makeSetActiveFrontmatterRequestReplace() {
        // Given
        let content = "important"
        let operation = "replace"
        let key = "tags"

        // When
        let request = factory.makeSetActiveFrontmatterRequest(
            content: content,
            operation: operation,
            key: key
        )

        // Then
        #expect(
            request.path == "/active/",
            "It should use active note path"
        )
        #expect(
            request.method == .patch
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "application/json",
            "It should set correct Content-Type"
        )
        #expect(
            request.additionalHeaders?["Operation"] == operation,
            "It should set operation header"
        )
        #expect(
            request.additionalHeaders?["Target-Type"] == "frontmatter",
            "It should set target type header"
        )
    }

    @Test("It should create set active frontmatter request with append operation")
    func makeSetActiveFrontmatterRequestAppend() {
        // Given
        let content = "project"
        let operation = "append"
        let key = "categories"

        // When
        let request = factory.makeSetActiveFrontmatterRequest(
            content: content,
            operation: operation,
            key: key
        )

        // Then
        #expect(
            request.path == "/active/",
            "It should use active note path"
        )
        #expect(
            request.method == .patch
        )
        #expect(
            request.additionalHeaders?["Operation"] == operation,
            "It should set operation header"
        )
    }

    @Test("It should create set active frontmatter request with special characters")
    func makeSetActiveFrontmatterRequestWithSpecialCharacters() {
        // Given
        let content = "test value"
        let operation = "replace"
        let key = "field with spaces & symbols!"

        // When
        let request = factory.makeSetActiveFrontmatterRequest(
            content: content,
            operation: operation,
            key: key
        )

        // Then
        #expect(
            request.method == .patch
        )
        #expect(
            request.additionalHeaders?["Target"] != nil,
            "It should URL encode the target key"
        )
    }

    // MARK: - Vault File Tests

    @Test("It should create get vault file request")
    func makeGetVaultFileRequest() {
        // Given
        let filename = "notes/project.md"

        // When
        let request = factory.makeGetVaultFileRequest(filename: filename)

        // Then
        #expect(
            request.path == "/vault/notes/project.md",
            "It should use correct vault path"
        )
        #expect(
            request.method == .get,
            "It should use GET method"
        )
        #expect(
            request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json",
            "It should set correct Accept header"
        )
    }

    @Test("It should create or update vault file request")
    func makeCreateOrUpdateVaultFileRequest() {
        // Given
        let filename = "new-note.md"
        let content = "# New Note\n\nThis is a new note."

        // When
        let request = factory.makeCreateOrUpdateVaultFileRequest(
            filename: filename,
            content: content
        )

        // Then
        #expect(
            request.path == "/vault/new-note.md",
            "It should use correct vault path"
        )
        #expect(
            request.method == .put,
            "It should use PUT method"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown",
            "It should set correct Content-Type header"
        )
    }

    @Test("It should create append to vault file request")
    func makeAppendToVaultFileRequest() {
        // Given
        let filename = "existing-note.md"
        let content = "\n\n## Additional Section\n\nAppended content."

        // When
        let request = factory.makeAppendToVaultFileRequest(
            filename: filename,
            content: content
        )

        // Then
        #expect(
            request.path == "/vault/existing-note.md",
            "It should use correct vault path"
        )
        #expect(
            request.method == .post,
            "It should use POST method"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown",
            "It should set correct Content-Type header"
        )
    }

    @Test("It should create delete vault file request")
    func makeDeleteVaultFileRequest() {
        // Given
        let filename = "old/deprecated.md"

        // When
        let request = factory.makeDeleteVaultFileRequest(filename: filename)

        // Then
        #expect(
            request.path == "/vault/old/deprecated.md",
            "It should use correct vault path"
        )
        #expect(
            request.method == .delete,
            "It should use DELETE method"
        )
    }

    @Test("It should handle empty filename for vault operations")
    func makeGetVaultFileRequestEmptyFilename() {
        // Given
        let filename = ""

        // When
        let request = factory.makeGetVaultFileRequest(filename: filename)

        // Then
        #expect(
            request.path == "/vault",
            "It should handle empty filename correctly"
        )
    }

    @Test("It should handle special characters in vault filename")
    func makeGetVaultFileRequestSpecialCharacters() {
        // Given
        let filename = "folder with spaces/file & name.md"

        // When
        let request = factory.makeGetVaultFileRequest(filename: filename)

        // Then
        #expect(
            request.path?.contains("folder with spaces") == true,
            "It should preserve spaces in path"
        )
    }

    @Test("It should create set vault frontmatter request")
    func makeSetVaultFrontmatterRequest() {
        // Given
        let filename = "note.md"
        let content = "completed"
        let operation = "replace"
        let key = "status"

        // When
        let request = factory.makeSetVaultFrontmatterRequest(
            filename: filename,
            content: content,
            operation: operation,
            key: key
        )

        // Then
        #expect(
            request.path == "/vault/note.md",
            "It should use correct vault path"
        )
        #expect(
            request.method == .patch
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "application/json",
            "It should set correct Content-Type"
        )
        #expect(
            request.additionalHeaders?["Operation"] == operation,
            "It should set operation header"
        )
        #expect(
            request.additionalHeaders?["Target-Type"] == "frontmatter",
            "It should set target type header"
        )
    }

    @Test("It should create append vault frontmatter request")
    func makeAppendVaultFrontmatterRequest() {
        // Given
        let filename = "research.md"
        let content = "literature-review"
        let operation = "append"
        let key = "tags"

        // When
        let request = factory.makeSetVaultFrontmatterRequest(
            filename: filename,
            content: content,
            operation: operation,
            key: key
        )

        // Then
        #expect(
            request.additionalHeaders?["Operation"] == "append",
            "It should set append operation"
        )
    }

    // MARK: - Directory Listing Tests

    @Test("It should create list vault directory request for root")
    func makeListVaultDirectoryRequestRoot() {
        // Given
        let directory = ""

        // When
        let request = factory.makeListVaultDirectoryRequest(directory: directory)

        // Then
        #expect(
            request.path == "/vault/",
            "It should use vault root path for empty directory"
        )
        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    @Test("It should create list vault directory request for subdirectory")
    func makeListVaultDirectoryRequestSubdirectory() {
        // Given
        let directory = "projects/obsidian"

        // When
        let request = factory.makeListVaultDirectoryRequest(directory: directory)

        // Then
        #expect(
            request.path == "/vault/projects/obsidian/",
            "It should use correct subdirectory path"
        )
        #expect(
            request.method == .get,
            "It should use GET method"
        )
    }

    // MARK: - Search Tests

    @Test("It should create search vault request")
    func makeSearchVaultRequest() {
        // Given
        let query = "test query"

        // When
        let request = factory.makeSearchVaultRequest(
            query: query
        )

        // Then
        #expect(
            request.path == "/search/simple/",
            "It should use search path"
        )
        #expect(
            request.method == .post,
            "It should use POST method"
        )
        #expect(
            request.additionalHeaders?["Accept"] == "application/json",
            "It should set correct Accept header"
        )
        #expect(
            request.queryItems.contains { $0.name == "query" && $0.value == query },
            "It should include query parameter"
        )
        #expect(
            request.queryItems.contains { $0.name == "contextLength" && $0.value == "100" },
            "It should include context length parameter"
        )
    }

    @Test("It should create search vault request with special characters")
    func makeSearchVaultRequestSpecialCharacters() {
        // Given
        let query = "regex.*pattern & test"

        // When
        let request = factory.makeSearchVaultRequest(
            query: query
        )

        // Then
        #expect(
            request.queryItems.contains { $0.name == "query" && $0.value == query },
            "It should handle special characters in query"
        )
    }

    // MARK: - URL Encoding Tests

    @Test("It should URL encode frontmatter target key")
    func urlEncodeFrontmatterTarget() {
        // Given
        let key = "field with spaces & symbols!"

        // When
        let request = factory.makeSetActiveFrontmatterRequest(
            content: "value",
            operation: "replace",
            key: key
        )

        // Then
        #expect(
            request.additionalHeaders?["Target"]?.contains("%20") == true ||
            request.additionalHeaders?["Target"]?.contains("+") == true,
            "It should URL encode spaces in target key"
        )
    }

    // MARK: - Periodic Notes Tests

    @Test("It should create get periodic note request")
    func makeGetPeriodicNoteRequest() {
        // Given
        let period = "daily"

        // When
        let request = factory.makeGetPeriodicNoteRequest(period: period)

        // Then
        #expect(
            request.path == "/periodic/daily/",
            "It should use correct periodic note path"
        )
        #expect(
            request.method == .get,
            "It should use GET method"
        )
        #expect(
            request.additionalHeaders?["Accept"] == "application/vnd.olrapi.note+json",
            "It should set correct Accept header"
        )
    }

    @Test("It should create periodic note request for different periods")
    func makeGetPeriodicNoteRequestDifferentPeriods() {
        // Test all periodic note periods
        let periods = ["daily", "weekly", "monthly", "quarterly", "yearly"]

        for period in periods {
            // When
            let request = factory.makeGetPeriodicNoteRequest(period: period)

            // Then
            #expect(
                request.path == "/periodic/\(period)/",
                "It should use correct path for \(period) period"
            )
        }
    }

    @Test("It should create update periodic note request")
    func makeCreateOrUpdatePeriodicNoteRequest() {
        // Given
        let period = "weekly"
        let content = "# Week 1\n\nGoals for this week..."

        // When
        let request = factory.makeCreateOrUpdatePeriodicNoteRequest(
            period: period,
            content: content
        )

        // Then
        #expect(
            request.path == "/periodic/weekly/",
            "It should use correct periodic note path"
        )
        #expect(
            request.method == .put,
            "It should use PUT method"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown",
            "It should set correct Content-Type header"
        )
        #expect(
            request.body == content.data(using: .utf8),
            "It should set request body with content"
        )
    }

    @Test("It should create append to periodic note request")
    func makeAppendToPeriodicNoteRequest() {
        // Given
        let period = "monthly"
        let content = "\n\n## New Achievement\n- Completed project X"

        // When
        let request = factory.makeAppendToPeriodicNoteRequest(
            period: period,
            content: content
        )

        // Then
        #expect(
            request.path == "/periodic/monthly/",
            "It should use correct periodic note path"
        )
        #expect(
            request.method == .post,
            "It should use POST method"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown",
            "It should set correct Content-Type header"
        )
        #expect(
            request.body == content.data(using: .utf8),
            "It should set request body with content"
        )
    }

    @Test("It should create delete periodic note request")
    func makeDeletePeriodicNoteRequest() {
        // Given
        let period = "quarterly"

        // When
        let request = factory.makeDeletePeriodicNoteRequest(period: period)

        // Then
        #expect(
            request.path == "/periodic/quarterly/",
            "It should use correct periodic note path"
        )
        #expect(
            request.method == .delete,
            "It should use DELETE method"
        )
    }

    // MARK: - Date-Specific Periodic Notes Tests

    @Test("It should create delete daily note request for a specific date")
    func makeDeleteDailyNoteRequest() {
        // When
        let request = factory.makeDeleteDailyNoteRequest(
            year: 2024,
            month: 1,
            day: 15
        )

        // Then
        #expect(
            request.path == "/periodic/daily/2024/1/15/",
            "It should use correct path for daily delete by date"
        )
        #expect(
            request.method == .delete,
            "It should use DELETE method"
        )
    }

    @Test("It should create delete weekly note request for a specific date")
    func makeDeleteWeeklyNoteRequest() {
        // When
        let request = factory.makeDeleteWeeklyNoteRequest(
            year: 2024,
            month: 2,
            day: 3
        )

        // Then
        #expect(
            request.path == "/periodic/weekly/2024/2/3/",
            "It should use correct path for weekly delete by date"
        )
        #expect(
            request.method == .delete,
            "It should use DELETE method"
        )
    }

    @Test("It should create delete monthly note request for a specific date")
    func makeDeleteMonthlyNoteRequest() {
        // When
        let request = factory.makeDeleteMonthlyNoteRequest(
            year: 2024,
            month: 3,
            day: 20
        )

        // Then
        #expect(
            request.path == "/periodic/monthly/2024/3/20/",
            "It should use correct path for monthly delete by date"
        )
        #expect(
            request.method == .delete,
            "It should use DELETE method"
        )
    }

    @Test("It should create delete quarterly note request for a specific date")
    func makeDeleteQuarterlyNoteRequest() {
        // When
        let request = factory.makeDeleteQuarterlyNoteRequest(
            year: 2024,
            month: 4,
            day: 10
        )

        // Then
        #expect(
            request.path == "/periodic/quarterly/2024/4/10/",
            "It should use correct path for quarterly delete by date"
        )
        #expect(
            request.method == .delete,
            "It should use DELETE method"
        )
    }

    @Test("It should create delete yearly note request for a specific date")
    func makeDeleteYearlyNoteRequest() {
        // When
        let request = factory.makeDeleteYearlyNoteRequest(
            year: 2024,
            month: 12,
            day: 31
        )

        // Then
        #expect(
            request.path == "/periodic/yearly/2024/12/31/",
            "It should use correct path for yearly delete by date"
        )
        #expect(
            request.method == .delete,
            "It should use DELETE method"
        )
    }

    @Test("It should create append to daily note request for a specific date")
    func makeAppendToDailyNoteRequestByDate() {
        // When
        let request = factory.makeAppendToDailyNoteRequest(
            year: 2024,
            month: 1,
            day: 15,
            content: "Append"
        )

        // Then
        #expect(
            request.path == "/periodic/daily/2024/1/15/",
            "It should use correct path"
        )
        #expect(
            request.method == .post,
            "It should use POST method"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown",
            "It should set Content-Type"
        )
    }

    @Test("It should create append to monthly note request for a specific date")
    func makeAppendToMonthlyNoteRequestByDate() {
        // When
        let request = factory.makeAppendToMonthlyNoteRequest(
            year: 2024,
            month: 3,
            day: 20,
            content: "Append"
        )

        // Then
        #expect(
            request.path == "/periodic/monthly/2024/3/20/",
            "It should use correct path"
        )
        #expect(
            request.method == .post,
            "It should use POST method"
        )
    }

    @Test("It should create create/update yearly note request for a specific date")
    func makeCreateOrUpdateYearlyNoteRequestByDate() {
        // When
        let request = factory.makeCreateOrUpdateYearlyNoteRequest(
            year: 2024,
            month: 12,
            day: 31,
            content: "# Year"
        )

        // Then
        #expect(
            request.path == "/periodic/yearly/2024/12/31/",
            "It should use correct path"
        )
        #expect(
            request.method == .put,
            "It should use PUT method"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown",
            "It should set Content-Type"
        )
    }

    @Test("It should create append to weekly note request for a specific date")
    func makeAppendToWeeklyNoteRequestByDate() {
        // When
        let request = factory.makeAppendToWeeklyNoteRequest(
            year: 2024,
            month: 2,
            day: 3,
            content: "Append"
        )

        // Then
        #expect(
            request.path == "/periodic/weekly/2024/2/3/",
            "It should use correct path"
        )
        #expect(
            request.method == .post,
            "It should use POST method"
        )
    }

    @Test("It should create append to quarterly note request for a specific date")
    func makeAppendToQuarterlyNoteRequestByDate() {
        // When
        let request = factory.makeAppendToQuarterlyNoteRequest(
            year: 2024,
            month: 4,
            day: 10,
            content: "Append"
        )

        // Then
        #expect(
            request.path == "/periodic/quarterly/2024/4/10/",
            "It should use correct path"
        )
        #expect(
            request.method == .post,
            "It should use POST method"
        )
    }

    @Test("It should create append to yearly note request for a specific date")
    func makeAppendToYearlyNoteRequestByDate() {
        // When
        let request = factory.makeAppendToYearlyNoteRequest(
            year: 2024,
            month: 12,
            day: 31,
            content: "Append"
        )

        // Then
        #expect(
            request.path == "/periodic/yearly/2024/12/31/",
            "It should use correct path"
        )
        #expect(
            request.method == .post,
            "It should use POST method"
        )
    }

    @Test("It should create create/update daily note request for a specific date")
    func makeCreateOrUpdateDailyNoteRequestByDate() {
        // When
        let request = factory.makeCreateOrUpdateDailyNoteRequest(
            year: 2024,
            month: 1,
            day: 15,
            content: "# Daily"
        )

        // Then
        #expect(
            request.path == "/periodic/daily/2024/1/15/",
            "It should use correct path"
        )
        #expect(
            request.method == .put,
            "It should use PUT method"
        )
        #expect(
            request.additionalHeaders?["Content-Type"] == "text/markdown",
            "It should set Content-Type"
        )
    }

    @Test("It should create create/update weekly note request for a specific date")
    func makeCreateOrUpdateWeeklyNoteRequestByDate() {
        // When
        let request = factory.makeCreateOrUpdateWeeklyNoteRequest(
            year: 2024,
            month: 2,
            day: 3,
            content: "# Weekly"
        )

        // Then
        #expect(
            request.path == "/periodic/weekly/2024/2/3/",
            "It should use correct path"
        )
        #expect(
            request.method == .put,
            "It should use PUT method"
        )
    }

    @Test("It should create create/update monthly note request for a specific date")
    func makeCreateOrUpdateMonthlyNoteRequestByDate() {
        // When
        let request = factory.makeCreateOrUpdateMonthlyNoteRequest(
            year: 2024,
            month: 3,
            day: 20,
            content: "# Monthly"
        )

        // Then
        #expect(
            request.path == "/periodic/monthly/2024/3/20/",
            "It should use correct path"
        )
        #expect(
            request.method == .put,
            "It should use PUT method"
        )
    }

    @Test("It should create create/update quarterly note request for a specific date")
    func makeCreateOrUpdateQuarterlyNoteRequestByDate() {
        // When
        let request = factory.makeCreateOrUpdateQuarterlyNoteRequest(
            year: 2024,
            month: 4,
            day: 10,
            content: "# Quarterly"
        )

        // Then
        #expect(
            request.path == "/periodic/quarterly/2024/4/10/",
            "It should use correct path"
        )
        #expect(
            request.method == .put,
            "It should use PUT method"
        )
    }
}
