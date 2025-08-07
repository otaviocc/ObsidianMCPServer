import Foundation
import ObsidianNetworking

public protocol ObsidianRepositoryProtocol: ObsidianRepositoryServerOperations,
                                            ObsidianRepositoryActiveNoteOperations,
                                            ObsidianRepositoryVaultNoteOperations,
                                            ObsidianRepositoryVaultOperations,
                                            ObsidianRepositorySearchOperations,
                                            ObsidianRepositoryBulkOperations,
                                            ObsidianRepositoryPeriodicOperations {}

// MARK: - Server Operations

public protocol ObsidianRepositoryServerOperations {

    /// Retrieves server information from the Obsidian instance.
    /// - Returns: A `ServerInformation` object containing details about the server
    /// - Throws: An error if the server information cannot be retrieved
    func getServerInfo() async throws -> ServerInformation
}

// MARK: - Active Note Operations

public protocol ObsidianRepositoryActiveNoteOperations {

    /// Retrieves the currently active note in Obsidian.
    /// - Returns: A `File` object representing the active note
    /// - Throws: An error if no note is active or the note cannot be retrieved
    func getActiveNote() async throws -> File

    /// Updates the content of the currently active note.
    /// - Parameter content: The new content to replace the entire note
    /// - Throws: An error if no note is active or the update fails
    func updateActiveNote(content: String) async throws

    /// Deletes the currently active note from the vault.
    /// - Throws: An error if no note is active or the deletion fails
    func deleteActiveNote() async throws

    /// Sets a frontmatter string field in the currently active note.
    /// - Parameters:
    ///   - key: The frontmatter field key to set
    ///   - value: The string value to set for the field
    /// - Throws: An error if no note is active or the operation fails
    func setActiveNoteFrontmatterStringField(
        key: String,
        value: String
    ) async throws

    /// Sets a frontmatter array field in the currently active note.
    /// - Parameters:
    ///   - key: The frontmatter field key to set
    ///   - value: The array values to set for the field
    /// - Throws: An error if no note is active or the operation fails
    func setActiveNoteFrontmatterArrayField(
        key: String,
        value: [String]
    ) async throws

    /// Appends a string value to a frontmatter field in the currently active note.
    /// - Parameters:
    ///   - key: The frontmatter field key to append to
    ///   - value: The string value to append to the field
    /// - Throws: An error if no note is active or the operation fails
    func appendToActiveNoteFrontmatterStringField(
        key: String,
        value: String
    ) async throws

    /// Appends an array of values to a frontmatter field in the currently active note.
    /// - Parameters:
    ///   - key: The frontmatter field key to append to
    ///   - value: The array values to append to the field
    /// - Throws: An error if no note is active or the operation fails
    func appendToActiveNoteFrontmatterArrayField(
        key: String,
        value: [String]
    ) async throws
}

// MARK: - Vault Note Operations

public protocol ObsidianRepositoryVaultNoteOperations {

    /// Retrieves a specific note from the vault by filename.
    /// - Parameter filename: The name of the file to retrieve
    /// - Returns: A `File` object representing the requested note
    /// - Throws: An error if the file doesn't exist or cannot be retrieved
    func getVaultNote(filename: String) async throws -> File

    /// Creates a new note or updates an existing note in the vault.
    /// - Parameter file: The `File` object containing the note data to create or update
    /// - Throws: An error if the operation fails
    func createOrUpdateVaultNote(file: File) async throws

    /// Appends content to an existing note in the vault.
    /// - Parameter file: The `File` object containing the content to append
    /// - Throws: An error if the target file doesn't exist or the append operation fails
    func appendToVaultNote(file: File) async throws

    /// Deletes a specific note from the vault.
    /// - Parameter filename: The name of the file to delete
    /// - Throws: An error if the file doesn't exist or cannot be deleted
    func deleteVaultNote(filename: String) async throws

    /// Sets a frontmatter string field in a specific vault note.
    /// - Parameters:
    ///   - filename: The name of the note to modify
    ///   - key: The frontmatter field key to set
    ///   - value: The string value to set for the field
    /// - Throws: An error if the file doesn't exist or the operation fails
    func setVaultNoteFrontmatterStringField(
        filename: String,
        key: String,
        value: String
    ) async throws

    /// Sets a frontmatter array field in a specific vault note.
    /// - Parameters:
    ///   - filename: The name of the note to modify
    ///   - key: The frontmatter field key to set
    ///   - value: The array values to set for the field
    /// - Throws: An error if the file doesn't exist or the operation fails
    func setVaultNoteFrontmatterArrayField(
        filename: String,
        key: String,
        value: [String]
    ) async throws

    /// Appends a string value to a frontmatter field in a specific vault note.
    /// - Parameters:
    ///   - filename: The name of the note to modify
    ///   - key: The frontmatter field key to append to
    ///   - value: The string value to append to the field
    /// - Throws: An error if the file doesn't exist or the operation fails
    func appendToVaultNoteFrontmatterStringField(
        filename: String,
        key: String,
        value: String
    ) async throws

    /// Appends an array of values to a frontmatter field in a specific vault note.
    /// - Parameters:
    ///   - filename: The name of the note to modify
    ///   - key: The frontmatter field key to append to
    ///   - value: The array values to append to the field
    /// - Throws: An error if the file doesn't exist or the operation fails
    func appendToVaultNoteFrontmatterArrayField(
        filename: String,
        key: String,
        value: [String]
    ) async throws
}

// MARK: - Vault Operations

public protocol ObsidianRepositoryVaultOperations {

    /// Lists all files and subdirectories in a specified vault directory.
    /// - Parameter directory: The directory path to list contents for
    /// - Returns: An array of `String` objects representing the directory contents
    /// - Throws: An error if the directory doesn't exist or cannot be accessed
    func listVaultDirectory(directory: String) async throws -> [String]
}

// MARK: - Search Operations

public protocol ObsidianRepositorySearchOperations {

    /// Searches the entire vault for content matching the specified query and options.
    /// - Parameters:
    ///   - query: The search term or pattern to find
    /// - Returns: An array of `SearchResult` objects containing matching content
    /// - Throws: An error if the search operation fails
    func searchVault(
        query: String
    ) async throws -> [SearchResult]
}

// MARK: - Bulk Operations

public protocol ObsidianRepositoryBulkOperations {

    /// Applies tags to all notes matching the specified search query.
    /// - Parameters:
    ///   - query: The search query to find target notes
    ///   - tags: The array of tags to apply to matching notes
    /// - Returns: A `BulkOperationResult` containing success and failure details
    /// - Throws: An error if the search operation fails
    func bulkApplyTagsFromSearch(
        query: String,
        tags: [String]
    ) async throws -> BulkOperationResult

    /// Replaces a frontmatter field with a string value for all notes matching the specified search query.
    /// - Parameters:
    ///   - query: The search query to find target notes
    ///   - key: The frontmatter field key to replace
    ///   - value: The string value to set for the field
    /// - Returns: A `BulkOperationResult` containing success and failure details
    /// - Throws: An error if the search operation fails
    func bulkReplaceFrontmatterStringFromSearch(
        query: String,
        key: String,
        value: String
    ) async throws -> BulkOperationResult

    /// Replaces a frontmatter field with array values for all notes matching the specified search query.
    /// - Parameters:
    ///   - query: The search query to find target notes
    ///   - key: The frontmatter field key to replace
    ///   - value: The array values to set for the field
    /// - Returns: A `BulkOperationResult` containing success and failure details
    /// - Throws: An error if the search operation fails
    func bulkReplaceFrontmatterArrayFromSearch(
        query: String,
        key: String,
        value: [String]
    ) async throws -> BulkOperationResult

    /// Appends to a frontmatter string field for all notes matching the specified search query.
    /// - Parameters:
    ///   - query: The search query to find target notes
    ///   - key: The frontmatter field key to append to
    ///   - value: The string value to append to the field
    /// - Returns: A `BulkOperationResult` containing success and failure details
    /// - Throws: An error if the search operation fails
    func bulkAppendToFrontmatterStringFromSearch(
        query: String,
        key: String,
        value: String
    ) async throws -> BulkOperationResult

    /// Appends to a frontmatter array field for all notes matching the specified search query.
    /// - Parameters:
    ///   - query: The search query to find target notes
    ///   - key: The frontmatter field key to append to
    ///   - value: The array values to append to the field
    /// - Returns: A `BulkOperationResult` containing success and failure details
    /// - Throws: An error if the search operation fails
    func bulkAppendToFrontmatterArrayFromSearch(
        query: String,
        key: String,
        value: [String]
    ) async throws -> BulkOperationResult
}

// MARK: - Periodic Notes Operations

public protocol ObsidianRepositoryPeriodicOperations {

    /// Retrieves the periodic note for the specified time period.
    /// - Parameters:
    ///   - period: The time period for the periodic note (daily, weekly, monthly, quarterly, yearly)
    /// - Returns: The File object representing the periodic note
    /// - Throws: An error if the periodic note cannot be retrieved or doesn't exist
    func getPeriodicNote(period: String) async throws -> File

    /// Creates or updates the periodic note for the specified time period with the given content.
    /// - Parameters:
    ///   - period: The time period for the periodic note
    ///   - content: The complete content to set for the periodic note
    /// - Throws: An error if the periodic note cannot be created or updated
    func createOrUpdatePeriodicNote(
        period: String,
        content: String
    ) async throws

    /// Appends content to the existing periodic note for the specified time period.
    /// - Parameters:
    ///   - period: The time period for the periodic note
    ///   - content: The content to append to the existing periodic note
    /// - Throws: An error if the content cannot be appended to the periodic note
    func appendToPeriodicNote(
        period: String,
        content: String
    ) async throws

    /// Deletes the periodic note for the specified time period.
    /// - Parameters:
    ///   - period: The time period for the periodic note to delete
    /// - Throws: An error if the periodic note cannot be deleted
    func deletePeriodicNote(period: String) async throws
}
