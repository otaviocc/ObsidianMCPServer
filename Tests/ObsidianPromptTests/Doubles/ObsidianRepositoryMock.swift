import Foundation
@testable import ObsidianRepository

final class ObsidianRepositoryMock: ObsidianRepositoryProtocol {

    // MARK: - Nested type

    enum MockError: Error {
        case someMockError
    }

    // MARK: - getVaultNote

    var getVaultNoteCallsCount = 0
    var getVaultNoteReceivedArguments: String?
    var getVaultNoteReturnValue: File!
    var getVaultNoteThrowableError: Error?

    func getVaultNote(filename: String) async throws -> File {
        getVaultNoteCallsCount += 1
        getVaultNoteReceivedArguments = filename

        if let error = getVaultNoteThrowableError {
            throw error
        }

        return getVaultNoteReturnValue
    }

    // MARK: - Unused Protocol Methods

    // swiftlint:disable unavailable_function
    func getServerInfo() async throws -> ServerInformation {
        fatalError("Not implemented for prompt tests")
    }

    func getActiveNote() async throws -> File {
        fatalError("Not implemented for prompt tests")
    }

    func updateActiveNote(content: String) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteActiveNote() async throws {
        fatalError("Not implemented for prompt tests")
    }

    func setActiveNoteFrontmatterField(
        key: String,
        value: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToActiveNoteFrontmatterField(
        key: String,
        value: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func createOrUpdateVaultNote(file: File) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToVaultNote(file: File) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func deleteVaultNote(filename: String) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func setVaultNoteFrontmatterField(
        filename: String,
        key: String,
        value: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func appendToVaultNoteFrontmatterField(
        filename: String,
        key: String,
        value: String
    ) async throws {
        fatalError("Not implemented for prompt tests")
    }

    func listVaultDirectory(directory: String) async throws -> [String] {
        fatalError("Not implemented for prompt tests")
    }

    func searchVault(query: String) async throws -> [SearchResult] {
        fatalError("Not implemented for prompt tests")
    }
    // swiftlint:enable unavailable_function
}
