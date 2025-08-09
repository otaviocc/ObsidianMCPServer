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
        .init(
            path: filename.appendedToVaultPath(),
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
        .init(
            path: filename.appendedToVaultPath(),
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
        .init(
            path: filename.appendedToVaultPath(),
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
        .init(
            path: filename.appendedToVaultPath(),
            method: .delete
        )
    }

    public func makeSetVaultFrontmatterRequest(
        filename: String,
        content: String,
        operation: String,
        key: String
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: filename.appendedToVaultPath(),
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
        .init(
            path: directory.appendedAsDirectoryToVaultPath(),
            method: .get
        )
    }

    // MARK: - Search

    public func makeSearchVaultRequest(
        query: String
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

    // MARK: - Periodic Notes

    public func makeGetPeriodicNoteRequest(
        period: String,
        year: Int? = nil,
        month: Int? = nil,
        day: Int? = nil
    ) -> NetworkRequest<VoidRequest, NoteJSONResponse> {
        .init(
            path: period.appendingPeriodicPath(
                year: year,
                month: month,
                day: day
            ),
            method: .get,
            additionalHeaders: [
                "Accept": "application/vnd.olrapi.note+json"
            ]
        )
    }

    public func makeCreateOrUpdatePeriodicNoteRequest(
        period: String,
        content: String,
        year: Int? = nil,
        month: Int? = nil,
        day: Int? = nil
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: period.appendingPeriodicPath(
                year: year,
                month: month,
                day: day
            ),
            method: .put,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "text/markdown"
            ]
        )
    }

    public func makeAppendToPeriodicNoteRequest(
        period: String,
        content: String,
        year: Int? = nil,
        month: Int? = nil,
        day: Int? = nil
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: period.appendingPeriodicPath(
                year: year,
                month: month,
                day: day
            ),
            method: .post,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "text/markdown"
            ]
        )
    }

    public func makeDeletePeriodicNoteRequest(
        period: String,
        year: Int? = nil,
        month: Int? = nil,
        day: Int? = nil
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        .init(
            path: period.appendingPeriodicPath(
                year: year,
                month: month,
                day: day
            ),
            method: .delete
        )
    }
}
