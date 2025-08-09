import Foundation
import MicroClient

// swiftlint:disable file_length type_body_length
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

    // MARK: - Periodic Notes Operations

    public func makeGetPeriodicNoteRequest(
        period: String
    ) -> NetworkRequest<VoidRequest, NoteJSONResponse> {
        .init(
            path: "/periodic/\(period)/",
            method: .get,
            additionalHeaders: [
                "Accept": "application/vnd.olrapi.note+json"
            ]
        )
    }

    public func makeCreateOrUpdatePeriodicNoteRequest(
        period: String,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: "/periodic/\(period)/",
            method: .put,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "text/markdown"
            ]
        )
    }

    public func makeAppendToPeriodicNoteRequest(
        period: String,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: "/periodic/\(period)/",
            method: .post,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "text/markdown"
            ]
        )
    }

    public func makeDeletePeriodicNoteRequest(
        period: String
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        .init(
            path: "/periodic/\(period)/",
            method: .delete
        )
    }

    // MARK: - Date-Specific Periodic Notes Operations

    public func makeDeleteDailyNoteRequest(
        year: Int,
        month: Int,
        day: Int
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        .init(
            path: "/periodic/daily/\(year)/\(month)/\(day)/",
            method: .delete
        )
    }

    public func makeDeleteWeeklyNoteRequest(
        year: Int,
        month: Int,
        day: Int
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        .init(
            path: "/periodic/weekly/\(year)/\(month)/\(day)/",
            method: .delete
        )
    }

    public func makeDeleteMonthlyNoteRequest(
        year: Int,
        month: Int,
        day: Int
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        .init(
            path: "/periodic/monthly/\(year)/\(month)/\(day)/",
            method: .delete
        )
    }

    public func makeDeleteQuarterlyNoteRequest(
        year: Int,
        month: Int,
        day: Int
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        .init(
            path: "/periodic/quarterly/\(year)/\(month)/\(day)/",
            method: .delete
        )
    }

    public func makeDeleteYearlyNoteRequest(
        year: Int,
        month: Int,
        day: Int
    ) -> NetworkRequest<VoidRequest, VoidResponse> {
        .init(
            path: "/periodic/yearly/\(year)/\(month)/\(day)/",
            method: .delete
        )
    }

    public func makeAppendToDailyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: "/periodic/daily/\(year)/\(month)/\(day)/",
            method: .post,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "text/markdown"
            ]
        )
    }

    public func makeAppendToWeeklyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: "/periodic/weekly/\(year)/\(month)/\(day)/",
            method: .post,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "text/markdown"
            ]
        )
    }

    public func makeAppendToMonthlyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: "/periodic/monthly/\(year)/\(month)/\(day)/",
            method: .post,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "text/markdown"
            ]
        )
    }

    public func makeAppendToQuarterlyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: "/periodic/quarterly/\(year)/\(month)/\(day)/",
            method: .post,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "text/markdown"
            ]
        )
    }

    public func makeAppendToYearlyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: "/periodic/yearly/\(year)/\(month)/\(day)/",
            method: .post,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "text/markdown"
            ]
        )
    }

    public func makeCreateOrUpdateDailyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: "/periodic/daily/\(year)/\(month)/\(day)/",
            method: .put,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "text/markdown"
            ]
        )
    }

    public func makeCreateOrUpdateWeeklyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: "/periodic/weekly/\(year)/\(month)/\(day)/",
            method: .put,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "text/markdown"
            ]
        )
    }

    public func makeCreateOrUpdateMonthlyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: "/periodic/monthly/\(year)/\(month)/\(day)/",
            method: .put,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "text/markdown"
            ]
        )
    }

    public func makeCreateOrUpdateQuarterlyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: "/periodic/quarterly/\(year)/\(month)/\(day)/",
            method: .put,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "text/markdown"
            ]
        )
    }

    public func makeCreateOrUpdateYearlyNoteRequest(
        year: Int,
        month: Int,
        day: Int,
        content: String
    ) -> NetworkRequest<Data, VoidResponse> {
        .init(
            path: "/periodic/yearly/\(year)/\(month)/\(day)/",
            method: .put,
            body: content.data(using: .utf8),
            additionalHeaders: [
                "Content-Type": "text/markdown"
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
// swiftlint:enable file_length type_body_length
