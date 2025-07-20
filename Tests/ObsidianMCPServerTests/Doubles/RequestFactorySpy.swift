import Foundation
import MicroClient
import ObsidianNetworking

final class RequestFactorySpy: ObsidianRequestFactoryProtocol {
    var serverInfoCallCount = 0
    var activeFileCallCount = 0
    var updateActiveFileCallCount = 0
    var deleteActiveFileCallCount = 0
    var vaultFileCallCount = 0
    var frontmatterCallCount = 0
    var searchVaultCallCount = 0

    // Tracking properties for method arguments
    var lastQuery: String?
    var lastContent: String?
    var lastFilename: String?
    var lastHeaders: [String: String] = [:]

    func makeServerInfoRequest() -> NetworkRequest<VoidRequest, ServerInfoResponse> {
        serverInfoCallCount += 1
        return NetworkRequest<VoidRequest, ServerInfoResponse>(
            path: "/spy-server-info",
            method: .get,
            additionalHeaders: [:]
        )
    }

    func makeGetActiveFileRequest() -> NetworkRequest<VoidRequest, NoteJSONResponse> {
        activeFileCallCount += 1
        return NetworkRequest<VoidRequest, NoteJSONResponse>(
            path: "/spy-active",
            method: .get,
            additionalHeaders: [:]
        )
    }

    func makeGetActiveFileJsonRequest() -> NetworkRequest<VoidRequest, NoteJSONResponse> {
        activeFileCallCount += 1
        return NetworkRequest<VoidRequest, NoteJSONResponse>(
            path: "/spy-active-json",
            method: .get,
            additionalHeaders: [:]
        )
    }

    func makeUpdateActiveFileRequest(
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        activeFileCallCount += 1
        updateActiveFileCallCount += 1
        lastContent = content
        return NetworkRequest<Data, VoidResponse>(
            path: "/spy-active-update",
            method: .put,
            body: content.data(using: .utf8),
            additionalHeaders: [:]
        )
    }

    func makeDeleteActiveFileRequest() -> NetworkRequest<VoidRequest, VoidResponse> {
        activeFileCallCount += 1
        deleteActiveFileCallCount += 1
        return NetworkRequest<VoidRequest, VoidResponse>(
            path: "/spy-active-delete",
            method: .delete,
            additionalHeaders: [:]
        )
    }

    func makeSetActiveFrontmatterRequest(
        content: String,
        operation: String,
        key: String
    ) -> NetworkRequest<Data, VoidResponse> {
        frontmatterCallCount += 1
        return NetworkRequest<Data, VoidResponse>(
            path: "/spy-active-frontmatter",
            method: .patch,
            body: content.data(using: .utf8),
            additionalHeaders: [:]
        )
    }

    func makeGetVaultFileRequest(
        filename: String
    ) -> NetworkRequest<VoidRequest, NoteJSONResponse> {
        vaultFileCallCount += 1
        lastFilename = filename
        return NetworkRequest<VoidRequest, NoteJSONResponse>(
            path: "/spy-vault/\(filename)",
            method: .get,
            additionalHeaders: [:]
        )
    }

    func makeCreateOrUpdateVaultFileRequest(
        filename: String,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        vaultFileCallCount += 1
        return NetworkRequest<Data, VoidResponse>(
            path: "/spy-vault/\(filename)",
            method: .put,
            body: content.data(using: .utf8),
            additionalHeaders: [:]
        )
    }

    func makeAppendToVaultFileRequest(
        filename: String,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        vaultFileCallCount += 1
        return NetworkRequest<Data, VoidResponse>(
            path: "/spy-vault-append/\(filename)",
            method: .post,
            body: content.data(using: .utf8),
            additionalHeaders: [:]
        )
    }

    func makeDeleteVaultFileRequest(
        filename: String
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        vaultFileCallCount += 1
        return NetworkRequest<VoidRequest, VoidResponse>(
            path: "/spy-vault-delete/\(filename)",
            method: .delete,
            additionalHeaders: [:]
        )
    }

    func makeSetVaultFrontmatterRequest(
        filename: String,
        content: String,
        operation: String,
        key: String
    ) -> NetworkRequest<Data, VoidResponse> {
        frontmatterCallCount += 1
        return NetworkRequest<Data, VoidResponse>(
            path: "/spy-vault-frontmatter/\(filename)",
            method: .patch,
            body: content.data(using: .utf8),
            additionalHeaders: [:]
        )
    }

    func makeListVaultDirectoryRequest(
        directory: String
    ) -> NetworkRequest<VoidRequest, DirectoryListingResponse> {
        NetworkRequest<VoidRequest, DirectoryListingResponse>(
            path: "/spy-directory",
            method: .get,
            additionalHeaders: [:]
        )
    }

    func makeSearchVaultRequest(
        query: String,
        ignoreCase: Bool,
        wholeWord: Bool,
        isRegex: Bool
    ) -> NetworkRequest<VoidRequest, [SimpleSearchResponse]> {
        searchVaultCallCount += 1
        lastQuery = query
        return NetworkRequest<VoidRequest, [SimpleSearchResponse]>(
            path: "/spy-search/",
            method: .post,
            additionalHeaders: [:]
        )
    }
}
