import Foundation
import SwiftMCP
import ObsidianRepository
import ObsidianNetworking
import ObsidianPrompt

// swiftlint:disable file_length

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
}

// swiftlint:enable file_length
