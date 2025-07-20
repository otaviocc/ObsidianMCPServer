import Foundation
import MicroClient

public protocol ObsidianRequestFactoryProtocol {

    // Server Info

    func makeServerInfoRequest() -> NetworkRequest<VoidRequest, ServerInfoResponse>

    // Active File

    func makeGetActiveFileRequest(
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, NoteJSONResponse>

    func makeGetActiveFileJsonRequest(
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, NoteJSONResponse>

    func makeUpdateActiveFileRequest(
        content: String,
        headers: [String: String]
    ) -> NetworkRequest<Data, VoidResponse>

    func makeDeleteActiveFileRequest(
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, VoidResponse>

    func makePatchActiveFileRequest(
        content: String,
        headers: [String: String]
    ) -> NetworkRequest<Data, VoidResponse>

    // Vault Files

    func makeGetVaultFileRequest(
        filename: String,
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, NoteJSONResponse>

    func makeCreateOrUpdateVaultFileRequest(
        filename: String,
        content: String,
        headers: [String: String]
    ) -> NetworkRequest<Data, VoidResponse>

    func makeAppendToVaultFileRequest(
        filename: String,
        content: String,
        headers: [String: String]
    ) -> NetworkRequest<Data, VoidResponse>

    func makeDeleteVaultFileRequest(
        filename: String,
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, VoidResponse>

    func makePatchVaultFileRequest(
        filename: String,
        content: String,
        headers: [String: String]
    ) -> NetworkRequest<Data, VoidResponse>

    // Directory Listing

    func makeListVaultDirectoryRequest(
        directory: String,
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, DirectoryListingResponse>

    // Search Operations

    func makeSearchVaultRequest(
        query: String,
        ignoreCase: Bool,
        wholeWord: Bool,
        isRegex: Bool,
        headers: [String: String]
    ) -> NetworkRequest<VoidRequest, [SimpleSearchResponse]>
}
