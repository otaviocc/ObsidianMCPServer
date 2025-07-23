import Foundation
import SwiftMCP
import ObsidianRepository
import ObsidianNetworking
import ObsidianPrompt

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
    }

    init(repository: ObsidianRepositoryProtocol) {
        self.repository = repository
        self.prompt = ObsidianPrompt(repository: repository)
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
     Sets a frontmatter field in the currently active note.

     This tool allows you to set or replace a specific frontmatter field in the active note.
     The value will be properly JSON-encoded and the field will be created if it doesn't exist.
     Useful for setting metadata like tags, dates, categories, or any custom frontmatter properties.

     - Parameter key: The frontmatter field name to set
     - Parameter value: The value to set (will be JSON-encoded automatically)
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Set a frontmatter field in the active note")
    func setActiveNoteFrontmatter(
        key: String,
        value: String
    ) async throws -> String {
        try await repository.setActiveNoteFrontmatterField(key: key, value: value)
        return "Active note frontmatter field '\(key)' set successfully."
    }

    /**
     Appends a value to a frontmatter field array in the currently active note.

     This tool allows you to add values to existing frontmatter arrays (like tags lists)
     or create a new array if the field doesn't exist. The value will be properly
     JSON-encoded and appended to the array.

     - Parameter key: The frontmatter field name to append to
     - Parameter value: The value to append to the array (will be JSON-encoded automatically)
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Append a value to a frontmatter field array in the active note")
    func appendToActiveNoteFrontmatter(
        key: String,
        value: String
    ) async throws -> String {
        try await repository.appendToActiveNoteFrontmatterField(key: key, value: value)
        return "Value appended to active note frontmatter field '\(key)' successfully."
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
     Sets a frontmatter field in a specific vault note.

     This tool allows you to set or replace a specific frontmatter field in any note
     in the vault. The value will be properly JSON-encoded and the field will be
     created if it doesn't exist. Useful for setting metadata like tags, dates,
     categories, or any custom frontmatter properties.

     - Parameter filename: The filename or path of the note to modify
     - Parameter key: The frontmatter field name to set
     - Parameter value: The value to set (will be JSON-encoded automatically)
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Set a frontmatter field in a specific vault note")
    func setNoteFrontmatter(
        filename: String,
        key: String,
        value: String
    ) async throws -> String {
        try await repository.setVaultNoteFrontmatterField(filename: filename, key: key, value: value)
        return "Note '\(filename)' frontmatter field '\(key)' set successfully."
    }

    /**
     Appends a value to a frontmatter field array in a specific vault note.

     This tool allows you to add values to existing frontmatter arrays (like tags lists)
     in any vault note, or create a new array if the field doesn't exist. The value
     will be properly JSON-encoded and appended to the array.

     - Parameter filename: The filename or path of the note to modify
     - Parameter key: The frontmatter field name to append to
     - Parameter value: The value to append to the array (will be JSON-encoded automatically)
     - Returns: Success confirmation message
     */
    @MCPTool(description: "Append a value to a frontmatter field array in a specific vault note")
    func appendToNoteFrontmatter(
        filename: String,
        key: String,
        value: String
    ) async throws -> String {
        try await repository.appendToVaultNoteFrontmatterField(filename: filename, key: key, value: value)
        return "Value appended to note '\(filename)' frontmatter field '\(key)' successfully."
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

    // MARK: - MCP Prompts

    /**
     Generate a prompt to analyze and summarize an Obsidian note with various focus types.

     This prompt provides a structured template for analyzing Obsidian note content,
     making it easy for LLMs to provide consistent and useful analysis based on specific needs.

     - Parameter filename: The filename of the note to analyze
     - Parameter focus: The type of analysis to perform (default: .general)
     - Returns: A formatted prompt for note analysis
     */
    @MCPPrompt(description: "Generate a structured prompt to analyze and summarize an Obsidian note")
    func summarizeNote(
        filename: String,
        focus: AnalysisFocus = .general
    ) async throws -> String {
        try await prompt.summarizeNote(filename: filename, focus: focus)
    }
}
