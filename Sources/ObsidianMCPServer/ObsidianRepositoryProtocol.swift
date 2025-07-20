import Foundation
import ObsidianNetworking

protocol ObsidianRepositoryProtocol: ObsidianRepositoryServerOperations,
                                     ObsidianRepositoryActiveNoteOperations,
                                     ObsidianRepositoryVaultNoteOperations,
                                     ObsidianRepositoryVaultOperations,
                                     ObsidianRepositorySearchOperations {}

protocol ObsidianRepositoryServerOperations {
    func getServerInfo() async throws -> ServerInformation
}

protocol ObsidianRepositoryActiveNoteOperations {
    func getActiveNote() async throws -> File
    func updateActiveNote(content: String) async throws
    func deleteActiveNote() async throws
    func patchActiveNote(
        content: String,
        parameters: PatchParameters
    ) async throws
}

protocol ObsidianRepositoryVaultNoteOperations {
    func getVaultNote(filename: String) async throws -> File
    func createOrUpdateVaultNote(file: File) async throws
    func appendToVaultNote(file: File) async throws
    func deleteVaultNote(filename: String) async throws
    func patchVaultNote(
        file: File,
        parameters: PatchParameters
    ) async throws
}

protocol ObsidianRepositoryVaultOperations {
    func listVaultDirectory(directory: String) async throws -> [URL]
}

protocol ObsidianRepositorySearchOperations {
    func searchVault(
        query: String,
        ignoreCase: Bool,
        wholeWord: Bool,
        isRegex: Bool
    ) async throws -> [SearchResult]

    func searchVaultInPath(
        query: String,
        path: String,
        ignoreCase: Bool,
        wholeWord: Bool,
        isRegex: Bool
    ) async throws -> [SearchResult]
}
