import Foundation
import ObsidianModels
import ObsidianNetworking
import ObsidianPrompt
import ObsidianRepository
import ObsidianResource
import SwiftMCP

// swiftlint:disable file_length type_body_length

/**
 An Obsidian MCP Server for accessing Obsidian vault operations via REST API.

 This Model Context Protocol server provides tools to interact with Obsidian vaults through
 the Obsidian Local REST API plugin. It enables LLMs to perform various operations including:

 - Retrieving server information and status
 - Managing active notes (get, update, delete, patch)
 - Managing vault notes (get, create, update, append, delete, patch)
 - Searching across vault content with customizable options
 - Listing vault directory contents

 The server acts as a bridge between MCP clients and the Obsidian REST API, providing
 a clean, type-safe interface for vault operations while maintaining proper separation
 between network and domain models.
 */
@MCPServer
final class ObsidianMCPServer {

    // MARK: - Properties

    private let repository: ObsidianRepositoryProtocol
    private let prompt: ObsidianPromptProtocol
    private let resource: ObsidianResourceProtocol

    // MARK: - Life cycle

    init(
        baseURL: URL,
        userToken: @escaping () -> String? = { nil },
        apiFactory: ObsidianAPIFactoryProtocol = ObsidianAPIFactory(),
        requestFactory: ObsidianRequestFactoryProtocol = ObsidianRequestFactory()
    ) {
        let client = apiFactory.makeObsidianAPIClient(
            baseURL: baseURL,
            userToken: userToken
        )
        self.repository = ObsidianRepository(
            client: client,
            requestFactory: requestFactory
        )
        self.prompt = ObsidianPrompt(repository: self.repository)
        self.resource = ObsidianResource()
    }

    init(repository: ObsidianRepositoryProtocol) {
        self.repository = repository
        self.prompt = ObsidianPrompt(repository: repository)
        self.resource = ObsidianResource()
    }

    // MARK: - MCP Tools

    /**
     Retrieves general information about the Obsidian server.

     This tool provides basic server identification including the service name
     and version, helping clients understand what Obsidian API they are connected to.

     - Returns: Server information containing service name and version
     */
    @MCPTool(description: "Get general server information")
    func getServerInfo() async throws -> ServerInformation {
        try await repository.getServerInfo()
    }

    /**
     Retrieves the currently active note in Obsidian.

     This tool fetches the note that is currently open and active in the Obsidian interface.
     The note content can be returned either as plain text or with additional metadata
     including creation/modification times, tags, and frontmatter.

     - Parameter includeMetadata: Whether to include metadata (timestamps, tags, frontmatter) with the note content
     - Returns: The active note as a string
     */
    @MCPTool(description: "Get the active note with optional metadata")
    func getActiveNote() async throws -> File {
        try await repository.getActiveNote()
    }

    /**
     Updates the content of the currently active note in Obsidian.

     This tool replaces the entire content of the active note with the provided text.
     Use this when you need to completely rewrite a note's content.

     - Parameter content: The new content to set for the active note
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Update the content of the active note")
    func updateActiveNote(content: String) async throws -> String {
        try await repository.updateActiveNote(content: content)
        return "Active note updated successfully."
    }

    /**
     Deletes the currently active note from the Obsidian vault.

     This tool permanently removes the active note from the vault. Use with caution
     as this operation cannot be undone through the API.

     - Returns: Success confirmation message
     */
    @MCPTool(description: "Delete the active note")
    func deleteActiveNote() async throws -> String {
        try await repository.deleteActiveNote()
        return "Active note deleted successfully."
    }

    /**
     Sets a frontmatter string field in the currently active note.

     This tool allows you to set or replace a specific frontmatter string field in the active note.
     The string value will be properly handled and the field will be created if it doesn't exist.
     Useful for setting metadata like titles, dates, categories, or any custom frontmatter string properties.

     - Parameter key: The frontmatter field name to set
     - Parameter value: The string value to set
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Set a frontmatter string field in the active note")
    func setActiveNoteFrontmatterString(
        key: String,
        value: String
    ) async throws -> String {
        try await repository.setActiveNoteFrontmatterStringField(key: key, value: value)
        return "Active note frontmatter string field '\(key)' set successfully."
    }

    /**
     Appends a string value to a frontmatter field in the currently active note.

     This tool allows you to add a string value to an existing frontmatter field
     or create a new field if it doesn't exist. The string value will be properly
     handled and appended to the field.

     - Parameter key: The frontmatter field name to append to
     - Parameter value: The string value to append to the field
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Append a string value to a frontmatter field in the active note")
    func appendToActiveNoteFrontmatterString(
        key: String,
        value: String
    ) async throws -> String {
        try await repository.appendToActiveNoteFrontmatterStringField(key: key, value: value)
        return "String value appended to active note frontmatter field '\(key)' successfully."
    }

    /**
     Sets a frontmatter array field in the currently active note.

     This tool allows you to set or replace an entire frontmatter array field with
     multiple values at once. The array values will be properly handled and the field
     will be created if it doesn't exist. Useful for setting multiple tags, categories,
     or any custom frontmatter array properties in one operation.

     - Parameter key: The frontmatter field name to set
     - Parameter values: The array of values to set for the field
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Set a frontmatter array field in the active note")
    func setActiveNoteFrontmatterArray(
        key: String,
        values: [String]
    ) async throws -> String {
        try await repository.setActiveNoteFrontmatterArrayField(key: key, value: values)
        return "Active note frontmatter array field '\(key)' set successfully with \(values.count) values."
    }

    /**
     Appends multiple values to a frontmatter field array in the currently active note.

     This tool allows you to add multiple values to existing frontmatter arrays
     (like tags lists) or create a new array if the field doesn't exist. All values
     will be properly handled and appended to the array.

     - Parameter key: The frontmatter field name to append to
     - Parameter values: The array of values to append to the field
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Append multiple values to a frontmatter field array in the active note")
    func appendToActiveNoteFrontmatterArray(
        key: String,
        values: [String]
    ) async throws -> String {
        try await repository.appendToActiveNoteFrontmatterArrayField(key: key, value: values)
        return "\(values.count) values appended to active note frontmatter field '\(key)' successfully."
    }

    /**
     Retrieves a specific note from the Obsidian vault by filename.

     This tool fetches any note in the vault by its filename/path. The note content
     can be returned either as plain text or with additional metadata including
     creation/modification times, tags, and frontmatter.

     - Parameter filename: The filename or path of the note to retrieve
     - Parameter includeMetadata: Whether to include metadata (timestamps, tags, frontmatter) with the note content
     - Returns: The requested note with filename and content (optionally including metadata)
     */
    @MCPTool(description: "Get a specific vault note with optional metadata")
    func getNote(filename: String) async throws -> File {
        try await repository.getVaultNote(filename: filename)
    }

    /**
     Creates a new note or updates an existing note in the Obsidian vault.

     This tool will create a new note if the filename doesn't exist, or completely
     replace the content of an existing note. The filename can include subdirectory
     paths to organize notes within the vault structure.

     - Parameter filename: The filename or path where the note should be created/updated
     - Parameter content: The content to write to the note
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Create or update a specific vault note")
    func createOrUpdateNote(
        filename: String,
        content: String
    ) async throws -> String {
        let file = File(filename: filename, content: content)
        try await repository.createOrUpdateVaultNote(file: file)
        return "Note '\(filename)' created/updated successfully."
    }

    /**
     Appends content to the end of an existing vault note.

     This tool adds the provided content to the end of an existing note without
     modifying the existing content. Useful for adding new sections, updates,
     or log entries to existing notes.

     - Parameter filename: The filename or path of the note to append to
     - Parameter content: The content to append to the note
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Append content to a specific vault note")
    func appendToNote(
        filename: String,
        content: String
    ) async throws -> String {
        let file = File(filename: filename, content: content)
        try await repository.appendToVaultNote(file: file)
        return "Content appended to '\(filename)' successfully."
    }

    /**
     Deletes a specific note from the Obsidian vault.

     This tool permanently removes the specified note from the vault. Use with caution
     as this operation cannot be undone through the API.

     - Parameter filename: The filename or path of the note to delete
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Delete a specific vault note")
    func deleteNote(filename: String) async throws -> String {
        try await repository.deleteVaultNote(filename: filename)
        return "Note '\(filename)' deleted successfully."
    }

    /**
     Sets a frontmatter string field in a specific vault note.

     This tool allows you to set or replace a specific frontmatter string field in any note
     in the vault. The string value will be properly handled and the field will be
     created if it doesn't exist. Useful for setting metadata like titles, dates,
     categories, or any custom frontmatter string properties.

     - Parameter filename: The filename or path of the note to modify
     - Parameter key: The frontmatter field name to set
     - Parameter value: The string value to set
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Set a frontmatter string field in a specific vault note")
    func setNoteFrontmatterString(
        filename: String,
        key: String,
        value: String
    ) async throws -> String {
        try await repository.setVaultNoteFrontmatterStringField(filename: filename, key: key, value: value)
        return "Note '\(filename)' frontmatter string field '\(key)' set successfully."
    }

    /**
     Appends a string value to a frontmatter field in a specific vault note.

     This tool allows you to add a string value to an existing frontmatter field
     in any vault note, or create a new field if it doesn't exist. The string
     value will be properly handled and appended to the field.

     - Parameter filename: The filename or path of the note to modify
     - Parameter key: The frontmatter field name to append to
     - Parameter value: The string value to append to the field
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Append a string value to a frontmatter field in a specific vault note")
    func appendToNoteFrontmatterString(
        filename: String,
        key: String,
        value: String
    ) async throws -> String {
        try await repository.appendToVaultNoteFrontmatterStringField(filename: filename, key: key, value: value)
        return "String value appended to note '\(filename)' frontmatter field '\(key)' successfully."
    }

    /**
     Sets a frontmatter array field in a specific vault note.

     This tool allows you to set or replace an entire frontmatter array field with
     multiple values at once in any vault note. The array values will be properly
     handled and the field will be created if it doesn't exist. Useful for setting
     multiple tags, categories, or any custom frontmatter array properties in one operation.

     - Parameter filename: The filename or path of the note to modify
     - Parameter key: The frontmatter field name to set
     - Parameter values: The array of values to set for the field
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Set a frontmatter array field in a specific vault note")
    func setNoteFrontmatterArray(
        filename: String,
        key: String,
        values: [String]
    ) async throws -> String {
        try await repository.setVaultNoteFrontmatterArrayField(filename: filename, key: key, value: values)
        return "Note '\(filename)' frontmatter array field '\(key)' set successfully with \(values.count) values."
    }

    /**
     Appends multiple values to a frontmatter field array in a specific vault note.

     This tool allows you to add multiple values to existing frontmatter arrays
     (like tags lists) in any vault note, or create a new array if the field doesn't exist.
     All values will be properly handled and appended to the array.

     - Parameter filename: The filename or path of the note to modify
     - Parameter key: The frontmatter field name to append to
     - Parameter values: The array of values to append to the field
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Append multiple values to a frontmatter field array in a specific vault note")
    func appendToNoteFrontmatterArray(
        filename: String,
        key: String,
        values: [String]
    ) async throws -> String {
        try await repository.appendToVaultNoteFrontmatterArrayField(filename: filename, key: key, value: values)
        return "\(values.count) values appended to note '\(filename)' frontmatter field '\(key)' successfully."
    }

    /**
     Lists all files and directories within a vault directory.

     This tool provides directory browsing capabilities for the Obsidian vault.
     It recursively lists files and subdirectories up to a maximum depth,
     helping to understand the vault structure and locate specific notes.

     - Parameter directory: The directory path to list (empty string for vault root)
     - Returns: Newline-separated list of file and directory paths
     */
    @MCPTool(description: "List files and directories in a vault directory")
    func listDirectory(directory: String = "") async throws -> String {
        let paths = try await repository.listVaultDirectory(directory: directory)
        return paths.joined(separator: "\n")
    }

    // MARK: - Search Tools

    /**
     Searches for text across all notes in the Obsidian vault.

     This tool provides powerful search capabilities across the entire vault content.
     It supports various search options including case sensitivity, whole word matching,
     and regular expression patterns. Results include file paths and relevance scores.

     - Parameter query: The text or pattern to search for
     - Returns: Array of search results with file paths and relevance scores
     */
    @MCPTool(description: "Search for text across all notes in the vault with various options")
    func search(
        query: String
    ) async throws -> [SearchResult] {
        try await repository.searchVault(
            query: query
        )
    }

    // MARK: - Bulk Operations Tools

    /**
     Applies tags to all notes matching a search query.

     This tool performs a vault search and then applies the specified tags to all
     matching notes' frontmatter. It provides detailed feedback about which operations
     succeeded and which failed, making it easy to track bulk changes.

     - Parameter query: The search query to find target notes
     - Parameter tags: Array of tags to apply to matching notes
     - Returns: Detailed results showing successful and failed operations
     */
    @MCPTool(description: "Apply tags to all notes matching a search query")
    func bulkApplyTagsFromSearch(
        query: String,
        tags: [String]
    ) async throws -> BulkOperationResult {
        try await repository.bulkApplyTagsFromSearch(
            query: query,
            tags: tags
        )
    }

    /**
     Replaces a frontmatter field with a string value for all notes matching a search query.

     This tool performs a vault search and then replaces the specified frontmatter
     field with a string value across all matching notes. The operation completely
     replaces existing field values.

     - Parameter query: The search query to find target notes
     - Parameter key: The frontmatter field key to replace
     - Parameter value: String value to set for the field
     - Returns: Detailed results showing successful and failed operations
     */
    @MCPTool(description: "Replace frontmatter string field for all notes matching a search query")
    func bulkReplaceFrontmatterStringFromSearch(
        query: String,
        key: String,
        value: String
    ) async throws -> BulkOperationResult {
        try await repository.bulkReplaceFrontmatterStringFromSearch(
            query: query,
            key: key,
            value: value
        )
    }

    /**
     Replaces a frontmatter field with array values for all notes matching a search query.

     This tool performs a vault search and then replaces the specified frontmatter
     field with array values across all matching notes. The operation completely
     replaces existing field values.

     - Parameter query: The search query to find target notes
     - Parameter key: The frontmatter field key to replace
     - Parameter value: Array of values to set for the field
     - Returns: Detailed results showing successful and failed operations
     */
    @MCPTool(description: "Replace frontmatter array field for all notes matching a search query")
    func bulkReplaceFrontmatterArrayFromSearch(
        query: String,
        key: String,
        value: [String]
    ) async throws -> BulkOperationResult {
        try await repository.bulkReplaceFrontmatterArrayFromSearch(
            query: query,
            key: key,
            value: value
        )
    }

    /**
     Appends to a frontmatter string field for all notes matching a search query.

     This tool performs a vault search and then appends a value to the specified
     frontmatter string field across all matching notes. The operation adds to existing
     field values rather than replacing them.

     - Parameter query: The search query to find target notes
     - Parameter key: The frontmatter field key to append to
     - Parameter value: String value to append to the field
     - Returns: Detailed results showing successful and failed operations
     */
    @MCPTool(description: "Append to frontmatter string field for all notes matching a search query")
    func bulkAppendToFrontmatterStringFromSearch(
        query: String,
        key: String,
        value: String
    ) async throws -> BulkOperationResult {
        try await repository.bulkAppendToFrontmatterStringFromSearch(
            query: query,
            key: key,
            value: value
        )
    }

    /**
     Appends to a frontmatter array field for all notes matching a search query.

     This tool performs a vault search and then appends values to the specified
     frontmatter array field across all matching notes. The operation adds to existing
     field values rather than replacing them.

     - Parameter query: The search query to find target notes
     - Parameter key: The frontmatter field key to append to
     - Parameter value: Array of values to append to the field
     - Returns: Detailed results showing successful and failed operations
     */
    @MCPTool(description: "Append to frontmatter array field for all notes matching a search query")
    func bulkAppendToFrontmatterArrayFromSearch(
        query: String,
        key: String,
        value: [String]
    ) async throws -> BulkOperationResult {
        try await repository.bulkAppendToFrontmatterArrayFromSearch(
            query: query,
            key: key,
            value: value
        )
    }

    // MARK: - Periodic Notes Operations

    /**
     Retrieve the daily periodic note.

     Daily notes are commonly used for journaling, daily task tracking, and daily reflections.
     This tool requires the Periodic Notes plugin to be installed and configured in Obsidian.

     - Returns: The File object representing the daily periodic note
     - Throws: An error if the daily note cannot be retrieved or the Periodic Notes plugin is not available
     */
    @MCPTool(description: "Get the daily periodic note")
    func getDailyNote() async throws -> File {
        try await repository.getPeriodicNote(period: "daily")
    }

    /**
     Retrieve the weekly periodic note.

     Weekly notes are commonly used for weekly reviews, planning, and weekly summaries.
     This tool requires the Periodic Notes plugin to be installed and configured in Obsidian.

     - Returns: The File object representing the weekly periodic note
     - Throws: An error if the weekly note cannot be retrieved or the Periodic Notes plugin is not available
     */
    @MCPTool(description: "Get the weekly periodic note")
    func getWeeklyNote() async throws -> File {
        try await repository.getPeriodicNote(period: "weekly")
    }

    /**
     Retrieve the monthly periodic note.

     Monthly notes are commonly used for monthly reviews, goal tracking, and progress summaries.
     This tool requires the Periodic Notes plugin to be installed and configured in Obsidian.

     - Returns: The File object representing the monthly periodic note
     - Throws: An error if the monthly note cannot be retrieved or the Periodic Notes plugin is not available
     */
    @MCPTool(description: "Get the monthly periodic note")
    func getMonthlyNote() async throws -> File {
        try await repository.getPeriodicNote(period: "monthly")
    }

    /**
     Retrieve the quarterly periodic note.

     Quarterly notes are commonly used for quarterly OKRs, strategic reviews, and quarterly planning.
     This tool requires the Periodic Notes plugin to be installed and configured in Obsidian.

     - Returns: The File object representing the quarterly periodic note
     - Throws: An error if the quarterly note cannot be retrieved or the Periodic Notes plugin is not available
     */
    @MCPTool(description: "Get the quarterly periodic note")
    func getQuarterlyNote() async throws -> File {
        try await repository.getPeriodicNote(period: "quarterly")
    }

    /**
     Retrieve the yearly periodic note.

     Yearly notes are commonly used for annual reviews, year-end summaries, and yearly goal setting.
     This tool requires the Periodic Notes plugin to be installed and configured in Obsidian.

     - Returns: The File object representing the yearly periodic note
     - Throws: An error if the yearly note cannot be retrieved or the Periodic Notes plugin is not available
     */
    @MCPTool(description: "Get the yearly periodic note")
    func getYearlyNote() async throws -> File {
        try await repository.getPeriodicNote(period: "yearly")
    }

    /**
     Create or update the daily periodic note with the given content.

     This completely replaces the content of the daily note. Use appendToDailyNote() if you
     want to add content without replacing existing content.

     - Parameter content: The complete content to set for the daily note
     - Returns: A success message
     - Throws: An error if the daily note cannot be created or updated
     */
    @MCPTool(description: "Create or update the daily periodic note")
    func createOrUpdateDailyNote(content: String) async throws -> String {
        try await repository.createOrUpdatePeriodicNote(period: "daily", content: content)
        return "Successfully updated daily periodic note"
    }

    /**
     Create or update the weekly periodic note with the given content.

     This completely replaces the content of the weekly note. Use appendToWeeklyNote() if you
     want to add content without replacing existing content.

     - Parameter content: The complete content to set for the weekly note
     - Returns: A success message
     - Throws: An error if the weekly note cannot be created or updated
     */
    @MCPTool(description: "Create or update the weekly periodic note")
    func createOrUpdateWeeklyNote(content: String) async throws -> String {
        try await repository.createOrUpdatePeriodicNote(period: "weekly", content: content)
        return "Successfully updated weekly periodic note"
    }

    /**
     Create or update the monthly periodic note with the given content.

     This completely replaces the content of the monthly note. Use appendToMonthlyNote() if you
     want to add content without replacing existing content.

     - Parameter content: The complete content to set for the monthly note
     - Returns: A success message
     - Throws: An error if the monthly note cannot be created or updated
     */
    @MCPTool(description: "Create or update the monthly periodic note")
    func createOrUpdateMonthlyNote(content: String) async throws -> String {
        try await repository.createOrUpdatePeriodicNote(period: "monthly", content: content)
        return "Successfully updated monthly periodic note"
    }

    /**
     Create or update the quarterly periodic note with the given content.

     This completely replaces the content of the quarterly note. Use appendToQuarterlyNote() if you
     want to add content without replacing existing content.

     - Parameter content: The complete content to set for the quarterly note
     - Returns: A success message
     - Throws: An error if the quarterly note cannot be created or updated
     */
    @MCPTool(description: "Create or update the quarterly periodic note")
    func createOrUpdateQuarterlyNote(content: String) async throws -> String {
        try await repository.createOrUpdatePeriodicNote(period: "quarterly", content: content)
        return "Successfully updated quarterly periodic note"
    }

    /**
     Create or update the yearly periodic note with the given content.

     This completely replaces the content of the yearly note. Use appendToYearlyNote() if you
     want to add content without replacing existing content.

     - Parameter content: The complete content to set for the yearly note
     - Returns: A success message
     - Throws: An error if the yearly note cannot be created or updated
     */
    @MCPTool(description: "Create or update the yearly periodic note")
    func createOrUpdateYearlyNote(content: String) async throws -> String {
        try await repository.createOrUpdatePeriodicNote(period: "yearly", content: content)
        return "Successfully updated yearly periodic note"
    }

    /**
     Append content to the existing daily periodic note.

     This adds new content to the end of the existing daily note without replacing
     existing content. Ideal for adding new entries to daily logs.

     - Parameter content: The content to append to the existing daily note
     - Returns: A success message
     - Throws: An error if the content cannot be appended to the daily note
     */
    @MCPTool(description: "Append content to the daily periodic note")
    func appendToDailyNote(content: String) async throws -> String {
        try await repository.appendToPeriodicNote(period: "daily", content: content)
        return "Successfully appended content to daily periodic note"
    }

    /**
     Append content to the existing weekly periodic note.

     This adds new content to the end of the existing weekly note without replacing
     existing content. Ideal for adding new entries to weekly summaries.

     - Parameter content: The content to append to the existing weekly note
     - Returns: A success message
     - Throws: An error if the content cannot be appended to the weekly note
     */
    @MCPTool(description: "Append content to the weekly periodic note")
    func appendToWeeklyNote(content: String) async throws -> String {
        try await repository.appendToPeriodicNote(period: "weekly", content: content)
        return "Successfully appended content to weekly periodic note"
    }

    /**
     Append content to the existing monthly periodic note.

     This adds new content to the end of the existing monthly note without replacing
     existing content. Ideal for adding new entries to monthly reviews.

     - Parameter content: The content to append to the existing monthly note
     - Returns: A success message
     - Throws: An error if the content cannot be appended to the monthly note
     */
    @MCPTool(description: "Append content to the monthly periodic note")
    func appendToMonthlyNote(content: String) async throws -> String {
        try await repository.appendToPeriodicNote(period: "monthly", content: content)
        return "Successfully appended content to monthly periodic note"
    }

    /**
     Append content to the existing quarterly periodic note.

     This adds new content to the end of the existing quarterly note without replacing
     existing content. Ideal for adding new entries to quarterly reviews.

     - Parameter content: The content to append to the existing quarterly note
     - Returns: A success message
     - Throws: An error if the content cannot be appended to the quarterly note
     */
    @MCPTool(description: "Append content to the quarterly periodic note")
    func appendToQuarterlyNote(content: String) async throws -> String {
        try await repository.appendToPeriodicNote(period: "quarterly", content: content)
        return "Successfully appended content to quarterly periodic note"
    }

    /**
     Append content to the existing yearly periodic note.

     This adds new content to the end of the existing yearly note without replacing
     existing content. Ideal for adding new entries to yearly summaries.

     - Parameter content: The content to append to the existing yearly note
     - Returns: A success message
     - Throws: An error if the content cannot be appended to the yearly note
     */
    @MCPTool(description: "Append content to the yearly periodic note")
    func appendToYearlyNote(content: String) async throws -> String {
        try await repository.appendToPeriodicNote(period: "yearly", content: content)
        return "Successfully appended content to yearly periodic note"
    }

    /**
     Delete the daily periodic note.

     This permanently removes the daily note file. Use with caution as this operation
     cannot be undone.

     - Returns: A success message
     - Throws: An error if the daily note cannot be deleted
     */
    @MCPTool(description: "Delete the daily periodic note")
    func deleteDailyNote() async throws -> String {
        try await repository.deletePeriodicNote(period: "daily")
        return "Successfully deleted daily periodic note"
    }

    /**
     Delete the weekly periodic note.

     This permanently removes the weekly note file. Use with caution as this operation
     cannot be undone.

     - Returns: A success message
     - Throws: An error if the weekly note cannot be deleted
     */
    @MCPTool(description: "Delete the weekly periodic note")
    func deleteWeeklyNote() async throws -> String {
        try await repository.deletePeriodicNote(period: "weekly")
        return "Successfully deleted weekly periodic note"
    }

    /**
     Delete the monthly periodic note.

     This permanently removes the monthly note file. Use with caution as this operation
     cannot be undone.

     - Returns: A success message
     - Throws: An error if the monthly note cannot be deleted
     */
    @MCPTool(description: "Delete the monthly periodic note")
    func deleteMonthlyNote() async throws -> String {
        try await repository.deletePeriodicNote(period: "monthly")
        return "Successfully deleted monthly periodic note"
    }

    /**
     Delete the quarterly periodic note.

     This permanently removes the quarterly note file. Use with caution as this operation
     cannot be undone.

     - Returns: A success message
     - Throws: An error if the quarterly note cannot be deleted
     */
    @MCPTool(description: "Delete the quarterly periodic note")
    func deleteQuarterlyNote() async throws -> String {
        try await repository.deletePeriodicNote(period: "quarterly")
        return "Successfully deleted quarterly periodic note"
    }

    /**
     Delete the yearly periodic note.

     This permanently removes the yearly note file. Use with caution as this operation
     cannot be undone.

     - Returns: A success message
     - Throws: An error if the yearly note cannot be deleted
     */
    @MCPTool(description: "Delete the yearly periodic note")
    func deleteYearlyNote() async throws -> String {
        try await repository.deletePeriodicNote(period: "yearly")
        return "Successfully deleted yearly periodic note"
    }

    /**
     Get a daily periodic note for a specific date.

     This retrieves the daily note file for the specified date.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Returns: The File object representing the daily periodic note
     - Throws: An error if the daily note cannot be retrieved
     */
    @MCPTool(description: "Get a daily periodic note for a specific date")
    func getDailyNoteForDate(
        year: Int,
        month: Int,
        day: Int
    ) async throws -> File {
        try await repository.getPeriodicNote(
            period: "daily",
            year: year,
            month: month,
            day: day
        )
    }

    /**
     Get a weekly periodic note for a specific date.

     This retrieves the weekly note file for the specified date.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Returns: The File object representing the weekly periodic note
     - Throws: An error if the weekly note cannot be retrieved
     */
    @MCPTool(description: "Get a weekly periodic note for a specific date")
    func getWeeklyNoteForDate(
        year: Int,
        month: Int,
        day: Int
    ) async throws -> File {
        try await repository.getPeriodicNote(
            period: "weekly",
            year: year,
            month: month,
            day: day
        )
    }

    /**
     Get a monthly periodic note for a specific date.

     This retrieves the monthly note file for the specified date.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Returns: The File object representing the monthly periodic note
     - Throws: An error if the monthly note cannot be retrieved
     */
    @MCPTool(description: "Get a monthly periodic note for a specific date")
    func getMonthlyNoteForDate(
        year: Int,
        month: Int,
        day: Int
    ) async throws -> File {
        try await repository.getPeriodicNote(
            period: "monthly",
            year: year,
            month: month,
            day: day
        )
    }

    /**
     Get a quarterly periodic note for a specific date.

     This retrieves the quarterly note file for the specified date.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Returns: The File object representing the quarterly periodic note
     - Throws: An error if the quarterly note cannot be retrieved
     */
    @MCPTool(description: "Get a quarterly periodic note for a specific date")
    func getQuarterlyNoteForDate(
        year: Int,
        month: Int,
        day: Int
    ) async throws -> File {
        try await repository.getPeriodicNote(
            period: "quarterly",
            year: year,
            month: month,
            day: day
        )
    }

    /**
     Get a yearly periodic note for a specific date.

     This retrieves the yearly note file for the specified date.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Returns: The File object representing the yearly periodic note
     - Throws: An error if the yearly note cannot be retrieved
     */
    @MCPTool(description: "Get a yearly periodic note for a specific date")
    func getYearlyNoteForDate(
        year: Int,
        month: Int,
        day: Int
    ) async throws -> File {
        try await repository.getPeriodicNote(
            period: "yearly",
            year: year,
            month: month,
            day: day
        )
    }

    /**
     Delete a daily periodic note for a specific date.

     This permanently removes the daily note file for the specified date. Use with caution
     as this operation cannot be undone.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Returns: A success message
     - Throws: An error if the daily note cannot be deleted
     */
    @MCPTool(description: "Delete a daily periodic note for a specific date")
    func deleteDailyNoteForDate(
        year: Int,
        month: Int,
        day: Int
    ) async throws -> String {
        try await repository.deletePeriodicNote(
            period: "daily",
            year: year,
            month: month,
            day: day
        )
        return "Successfully deleted daily periodic note for \(year)-\(month)-\(day)"
    }

    /**
     Delete a weekly periodic note for a specific date.

     This permanently removes the weekly note file for the specified date. Use with caution
     as this operation cannot be undone.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Returns: A success message
     - Throws: An error if the weekly note cannot be deleted
     */
    @MCPTool(description: "Delete a weekly periodic note for a specific date")
    func deleteWeeklyNoteForDate(
        year: Int,
        month: Int,
        day: Int
    ) async throws -> String {
        try await repository.deletePeriodicNote(
            period: "weekly",
            year: year,
            month: month,
            day: day
        )
        return "Successfully deleted weekly periodic note for \(year)-\(month)-\(day)"
    }

    /**
     Delete a monthly periodic note for a specific date.

     This permanently removes the monthly note file for the specified date. Use with caution
     as this operation cannot be undone.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Returns: A success message
     - Throws: An error if the monthly note cannot be deleted
     */
    @MCPTool(description: "Delete a monthly periodic note for a specific date")
    func deleteMonthlyNoteForDate(
        year: Int,
        month: Int,
        day: Int
    ) async throws -> String {
        try await repository.deletePeriodicNote(
            period: "monthly",
            year: year,
            month: month,
            day: day
        )
        return "Successfully deleted monthly periodic note for \(year)-\(month)-\(day)"
    }

    /**
     Delete a quarterly periodic note for a specific date.

     This permanently removes the quarterly note file for the specified date. Use with caution
     as this operation cannot be undone.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Returns: A success message
     - Throws: An error if the quarterly note cannot be deleted
     */
    @MCPTool(description: "Delete a quarterly periodic note for a specific date")
    func deleteQuarterlyNoteForDate(
        year: Int,
        month: Int,
        day: Int
    ) async throws -> String {
        try await repository.deletePeriodicNote(
            period: "quarterly",
            year: year,
            month: month,
            day: day
        )
        return "Successfully deleted quarterly periodic note for \(year)-\(month)-\(day)"
    }

    /**
     Delete a yearly periodic note for a specific date.

     This permanently removes the yearly note file for the specified date. Use with caution
     as this operation cannot be undone.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Returns: A success message
     - Throws: An error if the yearly note cannot be deleted
     */
    @MCPTool(description: "Delete a yearly periodic note for a specific date")
    func deleteYearlyNoteForDate(
        year: Int,
        month: Int,
        day: Int
    ) async throws -> String {
        try await repository.deletePeriodicNote(
            period: "yearly",
            year: year,
            month: month,
            day: day
        )
        return "Successfully deleted yearly periodic note for \(year)-\(month)-\(day)"
    }

    /**
     Append content to a daily periodic note for a specific date.

     This adds new content to the end of the existing daily note for the specified date.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Parameter content: The content to append to the existing periodic note
     - Returns: A success message
     - Throws: An error if the content cannot be appended to the daily note
     */
    @MCPTool(description: "Append content to a daily periodic note for a specific date")
    func appendToDailyNoteForDate(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws -> String {
        try await repository.appendToPeriodicNote(
            period: "daily",
            content: content,
            year: year,
            month: month,
            day: day
        )
        return "Successfully appended content to daily periodic note for \(year)-\(month)-\(day)"
    }

    /**
     Append content to a weekly periodic note for a specific date.

     This adds new content to the end of the existing weekly note for the specified date.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Parameter content: The content to append to the existing periodic note
     - Returns: A success message
     - Throws: An error if the content cannot be appended to the weekly note
     */
    @MCPTool(description: "Append content to a weekly periodic note for a specific date")
    func appendToWeeklyNoteForDate(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws -> String {
        try await repository.appendToPeriodicNote(
            period: "weekly",
            content: content,
            year: year,
            month: month,
            day: day
        )
        return "Successfully appended content to weekly periodic note for \(year)-\(month)-\(day)"
    }

    /**
     Append content to a monthly periodic note for a specific date.

     This adds new content to the end of the existing monthly note for the specified date.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Parameter content: The content to append to the existing periodic note
     - Returns: A success message
     - Throws: An error if the content cannot be appended to the monthly note
     */
    @MCPTool(description: "Append content to a monthly periodic note for a specific date")
    func appendToMonthlyNoteForDate(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws -> String {
        try await repository.appendToPeriodicNote(
            period: "monthly",
            content: content,
            year: year,
            month: month,
            day: day
        )
        return "Successfully appended content to monthly periodic note for \(year)-\(month)-\(day)"
    }

    /**
     Append content to a quarterly periodic note for a specific date.

     This adds new content to the end of the existing quarterly note for the specified date.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Parameter content: The content to append to the existing periodic note
     - Returns: A success message
     - Throws: An error if the content cannot be appended to the quarterly note
     */
    @MCPTool(description: "Append content to a quarterly periodic note for a specific date")
    func appendToQuarterlyNoteForDate(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws -> String {
        try await repository.appendToPeriodicNote(
            period: "quarterly",
            content: content,
            year: year,
            month: month,
            day: day
        )
        return "Successfully appended content to quarterly periodic note for \(year)-\(month)-\(day)"
    }

    /**
     Append content to a yearly periodic note for a specific date.

     This adds new content to the end of the existing yearly note for the specified date.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Parameter content: The content to append to the existing periodic note
     - Returns: A success message
     - Throws: An error if the content cannot be appended to the yearly note
     */
    @MCPTool(description: "Append content to a yearly periodic note for a specific date")
    func appendToYearlyNoteForDate(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws -> String {
        try await repository.appendToPeriodicNote(
            period: "yearly",
            content: content,
            year: year,
            month: month,
            day: day
        )
        return "Successfully appended content to yearly periodic note for \(year)-\(month)-\(day)"
    }

    /**
     Create or update a daily periodic note for a specific date.

     This replaces the entire content of the daily note for the specified date, creating the
     note if it doesn't exist.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Parameter content: The complete content to set for the periodic note
     - Returns: A success message
     - Throws: An error if the daily note cannot be created or updated
     */
    @MCPTool(description: "Create or update a daily periodic note for a specific date")
    func createOrUpdateDailyNoteForDate(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws -> String {
        try await repository.createOrUpdatePeriodicNote(
            period: "daily",
            content: content,
            year: year,
            month: month,
            day: day
        )
        return "Successfully created/updated daily periodic note for \(year)-\(month)-\(day)"
    }

    /**
     Create or update a weekly periodic note for a specific date.

     This replaces the entire content of the weekly note for the specified date, creating the
     note if it doesn't exist.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Parameter content: The complete content to set for the periodic note
     - Returns: A success message
     - Throws: An error if the weekly note cannot be created or updated
     */
    @MCPTool(description: "Create or update a weekly periodic note for a specific date")
    func createOrUpdateWeeklyNoteForDate(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws -> String {
        try await repository.createOrUpdatePeriodicNote(
            period: "weekly",
            content: content,
            year: year,
            month: month,
            day: day
        )
        return "Successfully created/updated weekly periodic note for \(year)-\(month)-\(day)"
    }

    /**
     Create or update a monthly periodic note for a specific date.

     This replaces the entire content of the monthly note for the specified date, creating the
     note if it doesn't exist.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Parameter content: The complete content to set for the periodic note
     - Returns: A success message
     - Throws: An error if the monthly note cannot be created or updated
     */
    @MCPTool(description: "Create or update a monthly periodic note for a specific date")
    func createOrUpdateMonthlyNoteForDate(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws -> String {
        try await repository.createOrUpdatePeriodicNote(
            period: "monthly",
            content: content,
            year: year,
            month: month,
            day: day
        )
        return "Successfully created/updated monthly periodic note for \(year)-\(month)-\(day)"
    }

    /**
     Create or update a quarterly periodic note for a specific date.

     This replaces the entire content of the quarterly note for the specified date, creating the
     note if it doesn't exist.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Parameter content: The complete content to set for the periodic note
     - Returns: A success message
     - Throws: An error if the quarterly note cannot be created or updated
     */
    @MCPTool(description: "Create or update a quarterly periodic note for a specific date")
    func createOrUpdateQuarterlyNoteForDate(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws -> String {
        try await repository.createOrUpdatePeriodicNote(
            period: "quarterly",
            content: content,
            year: year,
            month: month,
            day: day
        )
        return "Successfully created/updated quarterly periodic note for \(year)-\(month)-\(day)"
    }

    /**
     Create or update a yearly periodic note for a specific date.

     This replaces the entire content of the yearly note for the specified date, creating the
     note if it doesn't exist.

     - Parameter year: The year (e.g., 2024)
     - Parameter month: The month (1-12)
     - Parameter day: The day (1-31)
     - Parameter content: The complete content to set for the periodic note
     - Returns: A success message
     - Throws: An error if the yearly note cannot be created or updated
     */
    @MCPTool(description: "Create or update a yearly periodic note for a specific date")
    func createOrUpdateYearlyNoteForDate(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) async throws -> String {
        try await repository.createOrUpdatePeriodicNote(
            period: "yearly",
            content: content,
            year: year,
            month: month,
            day: day
        )
        return "Successfully created/updated yearly periodic note for \(year)-\(month)-\(day)"
    }

    // MARK: - MCP Prompts

    /**
     Generate a prompt to analyze and summarize an Obsidian note with various focus types.

     This prompt provides a structured template for analyzing Obsidian note content,
     making it easy for LLMs to provide consistent and useful analysis based on specific needs.

     - Parameter filename: The filename of the note to analyze
     - Parameter focus: The type of analysis to perform (default: .general)
     - Returns: A formatted prompt for note analysis
     */
    @MCPPrompt(description: "Generate a structured prompt to analyze an Obsidian note")
    func analyzeNote(
        filename: String,
        focus: AnalysisFocus = .general
    ) async throws -> String {
        try await prompt.analyzeNote(filename: filename, focus: focus)
    }

    /**
     Generate a prompt to analyze the currently active note in Obsidian with various focus types.

     This prompt provides analysis of the note currently open in Obsidian without requiring
     the user to specify a filename, making it convenient for quick analysis workflows.

     - Parameter focus: The type of analysis to perform (default: .general)
     - Returns: A formatted prompt for active note analysis
     */
    @MCPPrompt(description: "Generate a structured prompt to analyze the currently active Obsidian note")
    func analyzeActiveNote(focus: AnalysisFocus = .general) async throws -> String {
        try await prompt.analyzeActiveNote(focus: focus)
    }

    /**
     Generate thought-provoking follow-up questions based on note content.

     This prompt creates engaging questions that encourage deeper thinking and exploration
     of the topics discussed in the note, perfect for research and learning workflows.

     - Parameter filename: The filename of the note to analyze
     - Parameter questionCount: The number of questions to generate (default: 5)
     - Returns: A formatted prompt with follow-up questions
     */
    @MCPPrompt(description: "Generate thought-provoking follow-up questions based on note content")
    func generateFollowUpQuestions(
        filename: String,
        questionCount: Int = 5
    ) async throws -> String {
        try await prompt.generateFollowUpQuestions(filename: filename, questionCount: questionCount)
    }

    /**
     Analyze note content and suggest relevant tags for frontmatter.

     This prompt examines the note content to identify key topics, themes, and concepts,
     then suggests appropriate tags that would be useful for organization and discovery.

     - Parameter filename: The filename of the note to analyze
     - Parameter maxTags: The maximum number of tags to suggest (default: 8)
     - Returns: A formatted prompt with tag suggestions and MCP commands to apply them
     */
    @MCPPrompt(description: "Analyze note content and suggest relevant tags for frontmatter")
    func suggestTags(
        filename: String,
        maxTags: Int = 8
    ) async throws -> String {
        try await prompt.suggestTags(filename: filename, maxTags: maxTags)
    }

    /**
     Generate a complete frontmatter structure based on note content.

     This prompt analyzes the note content to suggest a comprehensive frontmatter structure
     including tags, status, category, dates, and other relevant metadata fields.

     - Parameter filename: The filename of the note to analyze
     - Returns: A formatted prompt with complete frontmatter suggestions
     */
    @MCPPrompt(description: "Generate a complete frontmatter structure based on note content")
    func generateFrontmatter(filename: String) async throws -> String {
        try await prompt.generateFrontmatter(filename: filename)
    }

    /**
     Suggest tags for the currently active note in Obsidian.

     This prompt provides tag suggestions for the note currently open in Obsidian without
     requiring the user to specify a filename, making it convenient for quick tagging workflows.

     - Parameter maxTags: The maximum number of tags to suggest (default: 8)
     - Returns: A formatted prompt with tag suggestions and MCP commands to apply them
     */
    @MCPPrompt(description: "Suggest tags for the currently active note in Obsidian")
    func suggestActiveNoteTags(maxTags: Int = 8) async throws -> String {
        try await prompt.suggestActiveNoteTags(maxTags: maxTags)
    }

    /**
     Extract key metadata from note content for frontmatter usage.

     This prompt analyzes the note content to identify important metadata such as dates,
     people, projects, locations, and other structured information that would be valuable
     in frontmatter fields for organization and querying.

     - Parameter filename: The filename of the note to analyze
     - Returns: A formatted prompt with extracted metadata suggestions
     */
    @MCPPrompt(description: "Extract key metadata from note content for frontmatter usage")
    func extractMetadata(filename: String) async throws -> String {
        try await prompt.extractMetadata(filename: filename)
    }

    /**
     Rewrite the currently active note in a specific writing style.

     This prompt allows the user to transform the note currently open in Obsidian
     into different writing styles such as formal, informal, technical, scientific,
     emoji-filled, or "explain like I'm 5" format while preserving the core content
     and Obsidian formatting.

     - Parameter style: The desired writing style for the note
     - Returns: A formatted prompt to rewrite the active note in the specified style
     */
    @MCPPrompt(description: "Rewrite the currently active note in a specific writing style")
    func rewriteActiveNote(style: WritingStyle) async throws -> String {
        try await prompt.rewriteActiveNote(style: style)
    }

    /**
     Translate the currently active note to a specified language.

     This prompt allows the user to translate the note currently open in Obsidian
     into different languages while preserving Obsidian-specific formatting,
     structure, and maintaining appropriate technical terminology. The translation
     is designed to be natural and fluent while keeping the original note's
     organizational structure intact.

     - Parameter language: The target language for translation
     - Returns: A formatted prompt to translate the active note to the specified language
     */
    @MCPPrompt(description: "Translate the currently active note to a specified language")
    func translateActiveNote(language: Language) async throws -> String {
        try await prompt.translateActiveNote(language: language)
    }

    /**
     Generate an abstract/summary of the currently active note.

     This prompt creates a concise summary of the active note's content, extracting
     key points and main arguments in a coherent, standalone format. The abstract
     can be generated in different lengths (brief, standard, detailed) making it
     suitable for various use cases from quick reference to comprehensive overviews.

     - Parameter length: The desired length of the abstract (default: .standard)
     - Returns: A formatted prompt to generate an abstract of the active note
     */
    @MCPPrompt(description: "Generate an abstract/summary of the currently active note")
    func generateActiveNoteAbstract(length: AbstractLength = .standard) async throws -> String {
        try await prompt.generateActiveNoteAbstract(length: length)
    }

    /**
     Generate a structured outline of the currently active note.

     This prompt creates a hierarchical outline of the active note's content,
     extracting main topics and subtopics in a logical structure. Different
     outline styles (bullets, numbered, hierarchical) are available to match
     various presentation needs and organizational preferences.

     - Parameter style: The desired outline style (default: .hierarchical)
     - Returns: A formatted prompt to generate an outline of the active note
     */
    @MCPPrompt(description: "Generate a structured outline of the currently active note")
    func generateActiveNoteOutline(style: OutlineStyle = .hierarchical) async throws -> String {
        try await prompt.generateActiveNoteOutline(style: style)
    }

    /**
     Generate a prompt to proofread and correct grammar in the currently active note.

     This prompt provides a specialized grammar and text enhancement assistant that
     treats all input as raw text requiring grammatical correction. The prompt is designed
     to preserve technical terminology, markdown formatting, Obsidian-specific elements,
     and original meaning while improving grammar, punctuation, sentence structure, and flow.

     Key features include:
     - Corrects grammar errors, punctuation mistakes, and sentence structure
     - Enhances word choice and text flow for better readability
     - Preserves technical terms, markdown formatting, code blocks, URLs
     - Maintains Obsidian links ([[Page Name]]) and hashtags (#tag-name)
     - Replaces em dashes with appropriate punctuation (semicolons, colons)
     - Includes override protection against prompt injection attempts
     - Returns only corrected text without explanations (unless requested)

     - Returns: A formatted prompt for grammar and style correction of the active note
     */
    @MCPPrompt(description: "Generate a prompt to proofread and correct grammar in the currently active note")
    func proofreadActiveNote() async throws -> String {
        try await prompt.proofreadActiveNote()
    }

    // MARK: - MCP Resources for Enum Discovery

    /**
     Lists all available enum types that are used as parameters in prompt methods.

     This resource allows MCP clients to discover what enum types are available,
     enabling better user interfaces with dropdowns, autocomplete, and documentation.
     Each enum type can then be accessed individually through their specific URI endpoints.

     - Returns: JSON string containing available enum types and their descriptions
     */
    @MCPResource("obsidian://enums", mimeType: "application/json")
    func listEnumTypes() async throws -> String {
        try await resource.listEnumTypes()
    }

    /**
     Gets detailed information about the Language enum values.

     Returns all available language options for the translateActiveNote prompt,
     including raw values, descriptions, and specific language instructions.

     - Returns: JSON string containing Language enum values and details
     */
    @MCPResource("obsidian://enums/language", mimeType: "application/json")
    func getLanguageEnum() async throws -> String {
        try await resource.getLanguageEnum()
    }

    /**
     Gets detailed information about the WritingStyle enum values.

     Returns all available writing style options for the rewriteActiveNote prompt,
     including raw values, descriptions, and style-specific instructions.

     - Returns: JSON string containing WritingStyle enum values and details
     */
    @MCPResource("obsidian://enums/writing-style", mimeType: "application/json")
    func getWritingStyleEnum() async throws -> String {
        try await resource.getWritingStyleEnum()
    }

    /**
     Gets detailed information about the AnalysisFocus enum values.

     Returns all available analysis focus options for the analyzeNote and analyzeActiveNote prompts,
     including raw values, descriptions, and focus-specific instructions.

     - Returns: JSON string containing AnalysisFocus enum values and details
     */
    @MCPResource("obsidian://enums/analysis-focus", mimeType: "application/json")
    func getAnalysisFocusEnum() async throws -> String {
        try await resource.getAnalysisFocusEnum()
    }

    /**
     Gets detailed information about the AbstractLength enum values.

     Returns all available length options for the generateActiveNoteAbstract prompt,
     including raw values, descriptions, and length-specific instructions.

     - Returns: JSON string containing AbstractLength enum values and details
     */
    @MCPResource("obsidian://enums/abstract-length", mimeType: "application/json")
    func getAbstractLengthEnum() async throws -> String {
        try await resource.getAbstractLengthEnum()
    }

    /**
     Gets detailed information about the OutlineStyle enum values.

     Returns all available style options for the generateActiveNoteOutline prompt,
     including raw values, descriptions, and style-specific instructions.

     - Returns: JSON string containing OutlineStyle enum values and details
     */
    @MCPResource("obsidian://enums/outline-style", mimeType: "application/json")
    func getOutlineStyleEnum() async throws -> String {
        try await resource.getOutlineStyleEnum()
    }
}

// swiftlint:enable file_length type_body_length
