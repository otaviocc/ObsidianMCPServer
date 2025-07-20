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
    ///   - ignoreCase: Whether to perform a case-insensitive search
    ///   - wholeWord: Whether to match only whole words
    ///   - isRegex: Whether the query should be interpreted as a regular expression
    /// - Returns: A `NetworkRequest` that performs the vault search and returns matching results
    func makeSearchVaultRequest(
        query: String,
        ignoreCase: Bool,
        wholeWord: Bool,
        isRegex: Bool
    ) -> NetworkRequest<VoidRequest, [SimpleSearchResponse]>
}
