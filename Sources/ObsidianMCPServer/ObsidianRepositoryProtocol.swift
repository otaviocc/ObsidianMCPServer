import Foundation
import ObsidianNetworking

protocol ObsidianRepositoryProtocol: ObsidianRepositoryServerOperations,
                                     ObsidianRepositoryActiveNoteOperations,
                                     ObsidianRepositoryVaultNoteOperations,
                                     ObsidianRepositoryVaultOperations,
                                     ObsidianRepositorySearchOperations {}

// MARK: - Server Operations

protocol ObsidianRepositoryServerOperations {

    /// Retrieves server information from the Obsidian instance.
    /// - Returns: A `ServerInformation` object containing details about the server
    /// - Throws: An error if the server information cannot be retrieved
    func getServerInfo() async throws -> ServerInformation
}

// MARK: - Active Note Operations

protocol ObsidianRepositoryActiveNoteOperations {

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

    /// Applies a patch to the currently active note with specific parameters.
    /// - Parameters:
    ///   - content: The content to be patched into the note
    ///   - parameters: Configuration parameters for the patch operation
    /// - Throws: An error if no note is active or the patch operation fails
    func patchActiveNote(
        content: String,
        parameters: PatchParameters
    ) async throws
}

// MARK: - Vault Note Operations

protocol ObsidianRepositoryVaultNoteOperations {

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

    /// Applies a patch to a specific note in the vault with configuration parameters.
    /// - Parameters:
    ///   - file: The `File` object containing the patch content and target information
    ///   - parameters: Configuration parameters for the patch operation
    /// - Throws: An error if the target file doesn't exist or the patch operation fails
    func patchVaultNote(
        file: File,
        parameters: PatchParameters
    ) async throws
}

// MARK: - Vault Operations

protocol ObsidianRepositoryVaultOperations {

    /// Lists all files and subdirectories in a specified vault directory.
    /// - Parameter directory: The directory path to list contents for
    /// - Returns: An array of `URL` objects representing the directory contents
    /// - Throws: An error if the directory doesn't exist or cannot be accessed
    func listVaultDirectory(directory: String) async throws -> [URL]
}

// MARK: - Search Operations

protocol ObsidianRepositorySearchOperations {

    /// Searches the entire vault for content matching the specified query and options.
    /// - Parameters:
    ///   - query: The search term or pattern to find
    ///   - ignoreCase: Whether to perform a case-insensitive search
    ///   - wholeWord: Whether to match only whole words
    ///   - isRegex: Whether the query should be interpreted as a regular expression
    /// - Returns: An array of `SearchResult` objects containing matching content
    /// - Throws: An error if the search operation fails
    func searchVault(
        query: String,
        ignoreCase: Bool,
        wholeWord: Bool,
        isRegex: Bool
    ) async throws -> [SearchResult]

    /// Searches within a specific path in the vault for content matching the query and options.
    /// - Parameters:
    ///   - query: The search term or pattern to find
    ///   - path: The specific path within the vault to search
    ///   - ignoreCase: Whether to perform a case-insensitive search
    ///   - wholeWord: Whether to match only whole words
    ///   - isRegex: Whether the query should be interpreted as a regular expression
    /// - Returns: An array of `SearchResult` objects containing matching content within the specified path
    /// - Throws: An error if the path doesn't exist or the search operation fails
    func searchVaultInPath(
        query: String,
        path: String,
        ignoreCase: Bool,
        wholeWord: Bool,
        isRegex: Bool
    ) async throws -> [SearchResult]
}
