import Foundation
import MicroClient

public struct ObsidianRequestFactory: ObsidianRequestFactoryProtocol {

    // MARK: - Life cycle

    public init() {}

    // MARK: - Server Info

    public func makeServerInfoRequest() -> NetworkRequest<VoidRequest, ServerInfoResponse> {
        NetworkRequest<VoidRequest, ServerInfoResponse>(
            path: "/",
            method: .get,
            additionalHeaders: [:]
        )
    }

    // MARK: - Active File

    public func makeGetActiveFileRequest(
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, NoteJSONResponse> {
        var requestHeaders = headers
        requestHeaders["Accept"] = "application/vnd.olrapi.note+json"

        return NetworkRequest<VoidRequest, NoteJSONResponse>(
            path: "/active/",
            method: .get,
            additionalHeaders: requestHeaders
        )
    }

    public func makeGetActiveFileJsonRequest(
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, NoteJSONResponse> {
        var requestHeaders = headers
        requestHeaders["Accept"] = "application/vnd.olrapi.note+json"

        return NetworkRequest<VoidRequest, NoteJSONResponse>(
            path: "/active/",
            method: .get,
            additionalHeaders: requestHeaders
        )
    }

    public func makeUpdateActiveFileRequest(
        content: String,
        headers: [String: String]
    ) -> NetworkRequest<Data, VoidResponse> {
        var requestHeaders = headers
        requestHeaders["Content-Type"] = "text/markdown; charset=utf-8"

        return NetworkRequest<Data, VoidResponse>(
            path: "/active/",
            method: .put,
            body: content.data(using: .utf8),
            additionalHeaders: requestHeaders
        )
    }

    public func makeDeleteActiveFileRequest(
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        NetworkRequest<VoidRequest, VoidResponse>(
            path: "/active/",
            method: .delete,
            additionalHeaders: headers
        )
    }

    public func makePatchActiveFileRequest(
        content: String,
        headers: [String: String]
    ) -> NetworkRequest<Data, VoidResponse> {
        var requestHeaders = headers
        requestHeaders["Content-Type"] = "text/markdown; charset=utf-8"

        return NetworkRequest<Data, VoidResponse>(
            path: "/active/",
            method: .patch,
            body: content.data(using: .utf8),
            additionalHeaders: requestHeaders
        )
    }

    // MARK: - Vault Files

    public func makeGetVaultFileRequest(
        filename: String,
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, NoteJSONResponse> {
        let filePath = buildVaultPath(for: filename)
        var requestHeaders = headers
        requestHeaders["Accept"] = "application/vnd.olrapi.note+json"

        return NetworkRequest<VoidRequest, NoteJSONResponse>(
            path: filePath,
            method: .get,
            additionalHeaders: requestHeaders
        )
    }

    public func makeCreateOrUpdateVaultFileRequest(
        filename: String,
        content: String,
        headers: [String: String]
    ) -> NetworkRequest<Data, VoidResponse> {
        let filePath = buildVaultPath(for: filename)
        var requestHeaders = headers
        requestHeaders["Content-Type"] = "text/markdown"

        return NetworkRequest<Data, VoidResponse>(
            path: filePath,
            method: .put,
            body: content.data(using: .utf8) ?? Data(),
            additionalHeaders: requestHeaders
        )
    }

    public func makeAppendToVaultFileRequest(
        filename: String,
        content: String,
        headers: [String: String]
    ) -> NetworkRequest<Data, VoidResponse> {
        let filePath = buildVaultPath(for: filename)
        var requestHeaders = headers
        requestHeaders["Content-Type"] = "text/markdown"

        return NetworkRequest<Data, VoidResponse>(
            path: filePath,
            method: .post,
            body: content.data(using: .utf8) ?? Data(),
            additionalHeaders: requestHeaders
        )
    }

    public func makeDeleteVaultFileRequest(
        filename: String,
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        let filePath = buildVaultPath(for: filename)

        return NetworkRequest<VoidRequest, VoidResponse>(
            path: filePath,
            method: .delete,
            additionalHeaders: headers
        )
    }

    public func makePatchVaultFileRequest(
        filename: String,
        content: String,
        headers: [String: String]
    ) -> NetworkRequest<Data, VoidResponse> {
        let filePath = buildVaultPath(for: filename)
        var requestHeaders = headers
        requestHeaders["Content-Type"] = "text/markdown"

        return NetworkRequest<Data, VoidResponse>(
            path: filePath,
            method: .patch,
            body: content.data(using: .utf8) ?? Data(),
            additionalHeaders: requestHeaders
        )
    }

    // MARK: - Directory Listing

    public func makeListVaultDirectoryRequest(
        directory: String,
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, DirectoryListingResponse> {
        let directoryPath = buildVaultDirectoryPath(for: directory)

        return NetworkRequest<VoidRequest, DirectoryListingResponse>(
            path: directoryPath,
            method: .get,
            additionalHeaders: headers
        )
    }

    // MARK: - Search Operations

    public func makeSearchVaultRequest(
        query: String,
        ignoreCase: Bool,
        wholeWord: Bool,
        isRegex: Bool,
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, [SimpleSearchResponse]> {
        var requestHeaders = headers
        requestHeaders["Accept"] = "application/json"

        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "contextLength", value: "100")
        ]

        return NetworkRequest<VoidRequest, [SimpleSearchResponse]>(
            path: "/search/simple/",
            method: .post,
            queryItems: queryItems,
            additionalHeaders: requestHeaders
        )
    }

    // MARK: - Private

    private func buildVaultPath(for filename: String) -> String {
        // swiftlint:disable:next force_unwrapping
        let baseVaultURL = URL(string: "vault")!
        let fileURL = baseVaultURL.appendingPathComponent(filename)

        return "/" + fileURL.path
    }

    private func buildVaultDirectoryPath(for directory: String) -> String {
        if directory.isEmpty {
            return "/vault/"
        }

        // swiftlint:disable:next force_unwrapping
        let baseVaultURL = URL(string: "vault")!
        let directoryURL = baseVaultURL.appendingPathComponent(directory)

        return "/" + directoryURL.path + "/"
    }
}
