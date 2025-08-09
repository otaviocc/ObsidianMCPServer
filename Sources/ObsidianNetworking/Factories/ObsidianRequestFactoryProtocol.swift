import Foundation
import MicroClient

public protocol ObsidianRequestFactoryProtocol {

    // MARK: - Server Info

    /// Creates a network request to retrieve server information from the Obsidian instance.
    /// - Returns: A `NetworkRequest` that fetches server information
    func makeServerInfoRequest() -> NetworkRequest<VoidRequest, ServerInfoResponse>

    // MARK: - Active File Operations

    /// Creates a network request to retrieve the currently active file in Obsidian.
    /// - Returns: A `NetworkRequest` that fetches the active file content
    func makeGetActiveFileRequest() -> NetworkRequest<VoidRequest, NoteJSONResponse>

    /// Creates a network request to retrieve the currently active file in JSON format.
    /// - Returns: A `NetworkRequest` that fetches the active file content as JSON
    func makeGetActiveFileJsonRequest() -> NetworkRequest<VoidRequest, NoteJSONResponse>

    /// Creates a network request to update the content of the currently active file.
    /// - Parameters:
    ///   - content: The new content to replace the entire active file
    /// - Returns: A `NetworkRequest` that updates the active file content
    func makeUpdateActiveFileRequest(
        content: String
    ) -> NetworkRequest<Data, VoidResponse>

    /// Creates a network request to delete the currently active file.
    /// - Returns: A `NetworkRequest` that deletes the active file
    func makeDeleteActiveFileRequest() -> NetworkRequest<VoidRequest, VoidResponse>

    /// Creates a network request to set a frontmatter field in the currently active file.
    /// - Parameters:
    ///   - content: The JSON value to set for the frontmatter field
    ///   - operation: The patch operation to perform (replace or append)
    ///   - key: The frontmatter field key to modify
    /// - Returns: A `NetworkRequest` that sets the frontmatter field in the active file
    func makeSetActiveFrontmatterRequest(
        content: String,
        operation: String,
        key: String
    ) -> NetworkRequest<Data, VoidResponse>

    // MARK: - Vault File Operations

    /// Creates a network request to retrieve a specific file from the vault by filename.
    /// - Parameters:
    ///   - filename: The name of the file to retrieve from the vault
    /// - Returns: A `NetworkRequest` that fetches the specified vault file
    func makeGetVaultFileRequest(
        filename: String
    ) -> NetworkRequest<VoidRequest, NoteJSONResponse>

    /// Creates a network request to create a new file or update an existing file in the vault.
    /// - Parameters:
    ///   - filename: The name of the file to create or update
    ///   - content: The content to write to the file
    /// - Returns: A `NetworkRequest` that creates or updates the vault file
    func makeCreateOrUpdateVaultFileRequest(
        filename: String,
        content: String
    ) -> NetworkRequest<Data, VoidResponse>

    /// Creates a network request to append content to an existing file in the vault.
    /// - Parameters:
    ///   - filename: The name of the file to append content to
    ///   - content: The content to append to the file
    /// - Returns: A `NetworkRequest` that appends content to the vault file
    func makeAppendToVaultFileRequest(
        filename: String,
        content: String
    ) -> NetworkRequest<Data, VoidResponse>

    /// Creates a network request to delete a specific file from the vault.
    /// - Parameters:
    ///   - filename: The name of the file to delete from the vault
    /// - Returns: A `NetworkRequest` that deletes the specified vault file
    func makeDeleteVaultFileRequest(
        filename: String
    ) -> NetworkRequest<VoidRequest, VoidResponse>

    /// Creates a network request to set a frontmatter field in a specific vault file.
    /// - Parameters:
    ///   - filename: The name of the file to modify in the vault
    ///   - content: The JSON value to set for the frontmatter field
    ///   - operation: The patch operation to perform (replace or append)
    ///   - key: The frontmatter field key to modify
    /// - Returns: A `NetworkRequest` that sets the frontmatter field in the vault file
    func makeSetVaultFrontmatterRequest(
        filename: String,
        content: String,
        operation: String,
        key: String
    ) -> NetworkRequest<Data, VoidResponse>

    // MARK: - Directory Operations

    /// Creates a network request to list the contents of a specific directory in the vault.
    /// - Parameters:
    ///   - directory: The directory path to list contents for
    /// - Returns: A `NetworkRequest` that fetches the directory listing
    func makeListVaultDirectoryRequest(
        directory: String
    ) -> NetworkRequest<VoidRequest, DirectoryListingResponse>

    // MARK: - Search Operations

    /// Creates a network request to search the vault for content matching specified criteria.
    /// - Parameters:
    ///   - query: The search term or pattern to find
    /// - Returns: A `NetworkRequest` that performs the vault search and returns matching results
    func makeSearchVaultRequest(
        query: String
    ) -> NetworkRequest<VoidRequest, [SimpleSearchResponse]>

    // MARK: - Periodic Notes Operations

    /// Creates a network request to retrieve a periodic note for the specified period.
    /// - Parameters:
    ///   - period: The periodic note period (daily, weekly, monthly, quarterly, yearly)
    /// - Returns: A `NetworkRequest` that fetches the periodic note
    func makeGetPeriodicNoteRequest(
        period: String
    ) -> NetworkRequest<VoidRequest, NoteJSONResponse>

    /// Creates a network request to create or update a periodic note for the specified period.
    /// - Parameters:
    ///   - period: The periodic note period (daily, weekly, monthly, quarterly, yearly)
    ///   - content: The content to write to the periodic note
    /// - Returns: A `NetworkRequest` that creates or updates the periodic note
    func makeCreateOrUpdatePeriodicNoteRequest(
        period: String,
        content: String
    ) -> NetworkRequest<Data, VoidResponse>

    /// Creates a network request to append content to a periodic note for the specified period.
    /// - Parameters:
    ///   - period: The periodic note period (daily, weekly, monthly, quarterly, yearly)
    ///   - content: The content to append to the periodic note
    /// - Returns: A `NetworkRequest` that appends content to the periodic note
    func makeAppendToPeriodicNoteRequest(
        period: String,
        content: String
    ) -> NetworkRequest<Data, VoidResponse>

    /// Creates a network request to delete a periodic note for the specified period.
    /// - Parameters:
    ///   - period: The periodic note period (daily, weekly, monthly, quarterly, yearly)
    /// - Returns: A `NetworkRequest` that deletes the periodic note
    func makeDeletePeriodicNoteRequest(
        period: String
    ) -> NetworkRequest<VoidRequest, VoidResponse>

    // MARK: - Date-Specific Periodic Notes Operations

    /// Creates a network request to delete a daily periodic note for the specified date.
    /// - Parameters:
    ///   - year: The year (e.g., 2024)
    ///   - month: The month (1-12)
    ///   - day: The day (1-31)
    /// - Returns: A `NetworkRequest` that deletes the daily periodic note
    func makeDeleteDailyNoteRequest(
        year: Int,
        month: Int,
        day: Int
    ) -> NetworkRequest<VoidRequest, VoidResponse>

    /// Creates a network request to delete a weekly periodic note for the specified date.
    /// - Parameters:
    ///   - year: The year (e.g., 2024)
    ///   - month: The month (1-12)
    ///   - day: The day (1-31)
    /// - Returns: A `NetworkRequest` that deletes the weekly periodic note
    func makeDeleteWeeklyNoteRequest(
        year: Int,
        month: Int,
        day: Int
    ) -> NetworkRequest<VoidRequest, VoidResponse>

    /// Creates a network request to delete a monthly periodic note for the specified date.
    /// - Parameters:
    ///   - year: The year (e.g., 2024)
    ///   - month: The month (1-12)
    ///   - day: The day (1-31)
    /// - Returns: A `NetworkRequest` that deletes the monthly periodic note
    func makeDeleteMonthlyNoteRequest(
        year: Int,
        month: Int,
        day: Int
    ) -> NetworkRequest<VoidRequest, VoidResponse>

    /// Creates a network request to delete a quarterly periodic note for the specified date.
    /// - Parameters:
    ///   - year: The year (e.g., 2024)
    ///   - month: The month (1-12)
    ///   - day: The day (1-31)
    /// - Returns: A `NetworkRequest` that deletes the quarterly periodic note
    func makeDeleteQuarterlyNoteRequest(
        year: Int,
        month: Int,
        day: Int
    ) -> NetworkRequest<VoidRequest, VoidResponse>

    /// Creates a network request to delete a yearly periodic note for the specified date.
    /// - Parameters:
    ///   - year: The year (e.g., 2024)
    ///   - month: The month (1-12)
    ///   - day: The day (1-31)
    /// - Returns: A `NetworkRequest` that deletes the yearly periodic note
    func makeDeleteYearlyNoteRequest(
        year: Int,
        month: Int,
        day: Int
    ) -> NetworkRequest<VoidRequest, VoidResponse>

    /// Creates a network request to append content to a daily periodic note for the specified date.
    /// - Parameters:
    ///   - year: The year (e.g., 2024)
    ///   - month: The month (1-12)
    ///   - day: The day (1-31)
    ///   - content: The content to append to the periodic note
    /// - Returns: A `NetworkRequest` that appends content to the daily periodic note
    func makeAppendToDailyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse>

    /// Creates a network request to append content to a weekly periodic note for the specified date.
    /// - Parameters:
    ///   - year: The year (e.g., 2024)
    ///   - month: The month (1-12)
    ///   - day: The day (1-31)
    ///   - content: The content to append to the periodic note
    /// - Returns: A `NetworkRequest` that appends content to the weekly periodic note
    func makeAppendToWeeklyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse>

    /// Creates a network request to append content to a monthly periodic note for the specified date.
    /// - Parameters:
    ///   - year: The year (e.g., 2024)
    ///   - month: The month (1-12)
    ///   - day: The day (1-31)
    ///   - content: The content to append to the periodic note
    /// - Returns: A `NetworkRequest` that appends content to the monthly periodic note
    func makeAppendToMonthlyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse>

    /// Creates a network request to append content to a quarterly periodic note for the specified date.
    /// - Parameters:
    ///   - year: The year (e.g., 2024)
    ///   - month: The month (1-12)
    ///   - day: The day (1-31)
    ///   - content: The content to append to the periodic note
    /// - Returns: A `NetworkRequest` that appends content to the quarterly periodic note
    func makeAppendToQuarterlyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse>

    /// Creates a network request to append content to a yearly periodic note for the specified date.
    /// - Parameters:
    ///   - year: The year (e.g., 2024)
    ///   - month: The month (1-12)
    ///   - day: The day (1-31)
    ///   - content: The content to append to the periodic note
    /// - Returns: A `NetworkRequest` that appends content to the yearly periodic note
    func makeAppendToYearlyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse>

    /// Creates a network request to create or update a daily periodic note for the specified date.
    /// - Parameters:
    ///   - year: The year (e.g., 2024)
    ///   - month: The month (1-12)
    ///   - day: The day (1-31)
    ///   - content: The content to set for the periodic note
    /// - Returns: A `NetworkRequest` that creates or updates the daily periodic note
    func makeCreateOrUpdateDailyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse>

    /// Creates a network request to create or update a weekly periodic note for the specified date.
    /// - Parameters:
    ///   - year: The year (e.g., 2024)
    ///   - month: The month (1-12)
    ///   - day: The day (1-31)
    ///   - content: The content to set for the periodic note
    /// - Returns: A `NetworkRequest` that creates or updates the weekly periodic note
    func makeCreateOrUpdateWeeklyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse>

    /// Creates a network request to create or update a monthly periodic note for the specified date.
    /// - Parameters:
    ///   - year: The year (e.g., 2024)
    ///   - month: The month (1-12)
    ///   - day: The day (1-31)
    ///   - content: The content to set for the periodic note
    /// - Returns: A `NetworkRequest` that creates or updates the monthly periodic note
    func makeCreateOrUpdateMonthlyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse>

    /// Creates a network request to create or update a quarterly periodic note for the specified date.
    /// - Parameters:
    ///   - year: The year (e.g., 2024)
    ///   - month: The month (1-12)
    ///   - day: The day (1-31)
    ///   - content: The content to set for the periodic note
    /// - Returns: A `NetworkRequest` that creates or updates the quarterly periodic note
    func makeCreateOrUpdateQuarterlyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse>

    /// Creates a network request to create or update a yearly periodic note for the specified date.
    /// - Parameters:
    ///   - year: The year (e.g., 2024)
    ///   - month: The month (1-12)
    ///   - day: The day (1-31)
    ///   - content: The content to set for the periodic note
    /// - Returns: A `NetworkRequest` that creates or updates the yearly periodic note
    func makeCreateOrUpdateYearlyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse>
}
