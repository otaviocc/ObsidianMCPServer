import Foundation
import MicroClient
import ObsidianNetworking

final class RequestFactorySpy: ObsidianRequestFactoryProtocol {
    var serverInfoCallCount = 0
    var activeFileCallCount = 0
    var updateActiveFileCallCount = 0
    var deleteActiveFileCallCount = 0
    var patchActiveFileCallCount = 0
    var vaultFileCallCount = 0
    var createOrUpdateVaultFileCallCount = 0
    var appendToVaultFileCallCount = 0
    var deleteVaultFileCallCount = 0
    var patchVaultFileCallCount = 0
    var listVaultDirectoryCallCount = 0
    var searchVaultCallCount = 0

    var lastHeaders: [String: String] = [:]
    var lastContent: String = ""
    var lastFilename: String = ""
    var lastDirectory: String = ""
    var lastQuery: String = ""

    func makeServerInfoRequest() -> NetworkRequest<VoidRequest, ServerInfoResponse> {
        serverInfoCallCount += 1
        return NetworkRequest<VoidRequest, ServerInfoResponse>(
            path: "/spy-server-info",
            method: .get,
            additionalHeaders: [:]
        )
    }

    func makeGetActiveFileRequest(headers: [String: String]) -> NetworkRequest<VoidRequest, NoteJSONResponse> {
        activeFileCallCount += 1
        lastHeaders = headers
        return NetworkRequest<VoidRequest, NoteJSONResponse>(
            path: "/spy-active",
            method: .get,
            additionalHeaders: headers
        )
    }

    func makeGetActiveFileJsonRequest(headers: [String: String]) -> NetworkRequest<VoidRequest, NoteJSONResponse> {
        activeFileCallCount += 1
        lastHeaders = headers
        return NetworkRequest<VoidRequest, NoteJSONResponse>(
            path: "/spy-active-json",
            method: .get,
            additionalHeaders: headers
        )
    }

    func makeUpdateActiveFileRequest(
        content: String,
        headers: [String: String]
    ) -> NetworkRequest<Data, VoidResponse> {
        updateActiveFileCallCount += 1
        lastContent = content
        lastHeaders = headers
        return NetworkRequest<Data, VoidResponse>(
            path: "/spy-update-active",
            method: .put,
            body: content.data(using: .utf8),
            additionalHeaders: headers
        )
    }

    func makeDeleteActiveFileRequest(headers: [String: String]) -> NetworkRequest<VoidRequest, VoidResponse> {
        deleteActiveFileCallCount += 1
        lastHeaders = headers
        return NetworkRequest<VoidRequest, VoidResponse>(
            path: "/spy-delete-active",
            method: .delete,
            additionalHeaders: headers
        )
    }

    func makePatchActiveFileRequest(
        content: String,
        headers: [String: String]
    ) -> NetworkRequest<Data, VoidResponse> {
        patchActiveFileCallCount += 1
        lastContent = content
        lastHeaders = headers
        return NetworkRequest<Data, VoidResponse>(
            path: "/spy-patch-active",
            method: .patch,
            body: content.data(using: .utf8),
            additionalHeaders: headers
        )
    }

    func makeGetVaultFileRequest(
        filename: String,
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, NoteJSONResponse> {
        vaultFileCallCount += 1
        lastFilename = filename
        lastHeaders = headers
        return NetworkRequest<VoidRequest, NoteJSONResponse>(
            path: "/spy-vault/\(filename)",
            method: .get,
            additionalHeaders: headers
        )
    }

    func makeCreateOrUpdateVaultFileRequest(
        filename: String,
        content: String,
        headers: [String: String]
    ) -> NetworkRequest<Data, VoidResponse> {
        createOrUpdateVaultFileCallCount += 1
        lastFilename = filename
        lastContent = content
        lastHeaders = headers
        return NetworkRequest<Data, VoidResponse>(
            path: "/spy-vault/\(filename)",
            method: .put,
            body: content.data(using: .utf8),
            additionalHeaders: headers
        )
    }

    func makeAppendToVaultFileRequest(
        filename: String,
        content: String,
        headers: [String: String]
    ) -> NetworkRequest<Data, VoidResponse> {
        appendToVaultFileCallCount += 1
        lastFilename = filename
        lastContent = content
        lastHeaders = headers
        return NetworkRequest<Data, VoidResponse>(
            path: "/spy-vault/\(filename)",
            method: .post,
            body: content.data(using: .utf8),
            additionalHeaders: headers
        )
    }

    func makeDeleteVaultFileRequest(
        filename: String,
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        deleteVaultFileCallCount += 1
        lastFilename = filename
        lastHeaders = headers
        return NetworkRequest<VoidRequest, VoidResponse>(
            path: "/spy-vault/\(filename)",
            method: .delete,
            additionalHeaders: headers
        )
    }

    func makePatchVaultFileRequest(
        filename: String,
        content: String,
        headers: [String: String]
    ) -> NetworkRequest<Data, VoidResponse> {
        patchVaultFileCallCount += 1
        lastFilename = filename
        lastContent = content
        lastHeaders = headers
        return NetworkRequest<Data, VoidResponse>(
            path: "/spy-vault/\(filename)",
            method: .patch,
            body: content.data(using: .utf8),
            additionalHeaders: headers
        )
    }

    func makeListVaultDirectoryRequest(
        directory: String,
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, DirectoryListingResponse> {
        listVaultDirectoryCallCount += 1
        lastDirectory = directory
        lastHeaders = headers
        return NetworkRequest<VoidRequest, DirectoryListingResponse>(
            path: "/spy-vault/\(directory)/",
            method: .get,
            additionalHeaders: headers
        )
    }

    func makeSearchVaultRequest(
        query: String,
        ignoreCase: Bool,
        wholeWord: Bool,
        isRegex: Bool,
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, [SimpleSearchResponse]> {
        searchVaultCallCount += 1
        lastQuery = query
        lastHeaders = headers
        return NetworkRequest<VoidRequest, [SimpleSearchResponse]>(
            path: "/spy-search/",
            method: .post,
            queryItems: [URLQueryItem(name: "query", value: query)],
            additionalHeaders: headers
        )
    }

    func reset() {
        serverInfoCallCount = 0
        activeFileCallCount = 0
        updateActiveFileCallCount = 0
        deleteActiveFileCallCount = 0
        patchActiveFileCallCount = 0
        vaultFileCallCount = 0
        createOrUpdateVaultFileCallCount = 0
        appendToVaultFileCallCount = 0
        deleteVaultFileCallCount = 0
        patchVaultFileCallCount = 0
        listVaultDirectoryCallCount = 0
        searchVaultCallCount = 0
        lastHeaders = [:]
        lastContent = ""
        lastFilename = ""
        lastDirectory = ""
        lastQuery = ""
    }
}
