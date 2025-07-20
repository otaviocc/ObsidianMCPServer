import Foundation
import MicroClient

public struct ObsidianRequestFactory: ObsidianRequestFactoryProtocol {

    // MARK: - Life cycle

    public init() {}

    // MARK: - Server Info

    public func makeServerInfoRequest() -> NetworkRequest<VoidRequest, ServerInfoResponse> {
        .init(
            path: "/",
            method: .get
        )
    }

    // MARK: - Active File

    public func makeGetActiveFileRequest() -> NetworkRequest<VoidRequest, NoteJSONResponse> {
        .init(
            path: "/active/",
            method: .get,
            additionalHeaders: [
                "Accept": "application/vnd.olrapi.note+json"
            ]
        )
    }

    public func makeGetActiveFileJsonRequest() -> NetworkRequest<VoidRequest, NoteJSONResponse> {
        .init(
            path: "/active/",
            method: .get,
            additionalHeaders: [
                "Accept": "application/vnd.olrapi.note+json"
            ]
        )
    }

    public func makeUpdateActiveFileRequest(
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: "/active/",
            method: .put,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "text/markdown; charset=utf-8"
            ]
        )
    }

    public func makeDeleteActiveFileRequest() -> NetworkRequest<VoidRequest, VoidResponse> {
        .init(
            path: "/active/",
            method: .delete
        )
    }

    public func makeSetActiveFrontmatterRequest(
        content: String,
        operation: String,
        key: String
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: "/active/",
            method: .patch,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "application/json",
                "Operation": operation,
                "Target-Type": "frontmatter",
                "Create-Target-If-Missing": "true",
                "Target": key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
            ]
        )
    }

    // MARK: - Vault Files

    public func makeGetVaultFileRequest(
        filename: String
    ) -> NetworkRequest<VoidRequest, NoteJSONResponse> {
        let filePath = buildVaultPath(for: filename)

        return .init(
            path: filePath,
            method: .get,
            additionalHeaders: [
                "Accept": "application/vnd.olrapi.note+json"
            ]
        )
    }

    public func makeCreateOrUpdateVaultFileRequest(
        filename: String,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        let filePath = buildVaultPath(for: filename)

        return .init(
            path: filePath,
            method: .put,
            body: content.data(using: .utf8) ?? Data(),
            additionalHeaders: [
                "Content-Type": "text/markdown"
            ]
        )
    }

    public func makeAppendToVaultFileRequest(
        filename: String,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        let filePath = buildVaultPath(for: filename)

        return .init(
            path: filePath,
            method: .post,
            body: content.data(using: .utf8) ?? Data(),
            additionalHeaders: [
                "Content-Type": "text/markdown"
            ]
        )
    }

    public func makeDeleteVaultFileRequest(
        filename: String
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        let filePath = buildVaultPath(for: filename)

        return .init(
            path: filePath,
            method: .delete
        )
    }

    public func makeSetVaultFrontmatterRequest(
        filename: String,
        content: String,
        operation: String,
        key: String
    ) -> NetworkRequest<Data, VoidResponse> {
        let filePath = buildVaultPath(for: filename)

        return .init(
            path: filePath,
            method: .patch,
            body: content.data(using: .utf8) ?? Data(),
            additionalHeaders: [
                "Content-Type": "application/json",
                "Operation": operation,
                "Target-Type": "frontmatter",
                "Create-Target-If-Missing": "true",
                "Target": key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
            ]
        )
    }

    // MARK: - Directory Listing

    public func makeListVaultDirectoryRequest(
        directory: String
    ) -> NetworkRequest<VoidRequest, DirectoryListingResponse> {
        let directoryPath = buildVaultDirectoryPath(for: directory)

        return .init(
            path: directoryPath,
            method: .get
        )
    }

    // MARK: - Search Operations

    public func makeSearchVaultRequest(
        query: String,
        ignoreCase: Bool,
        wholeWord: Bool,
        isRegex: Bool
    ) -> NetworkRequest<VoidRequest, [SimpleSearchResponse]> {
        .init(
            path: "/search/simple/",
            method: .post,
            queryItems: [
                .init(name: "query", value: query),
                .init(name: "contextLength", value: "100")
            ],
            additionalHeaders: [
                "Accept": "application/json"
            ]
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
