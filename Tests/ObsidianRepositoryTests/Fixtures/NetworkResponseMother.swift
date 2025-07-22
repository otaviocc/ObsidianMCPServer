import Foundation
import MicroClient
import ObsidianNetworking
import ObsidianRepository

enum NetworkResponseMother {

    static func makeNoteJSONResponse(
        path: String = "active-note.md",
        content: String = "# Active Note"
    ) throws -> NetworkResponse<NoteJSONResponse> {
        let jsonString = """
        {
            "content": "\(content)",
            "frontmatter": {},
            "path": "\(path)",
            "stat": {
                "ctime": 1234567890,
                "mtime": 1234567890,
                "size": \(content.count)
            },
            "tags": []
        }
        """
        let data = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        let noteResponse = try decoder.decode(NoteJSONResponse.self, from: data)
        let httpResponse = HTTPURLResponseMother.makeHTTPURLResponse()

        return .init(value: noteResponse, response: httpResponse)
    }

    static func makeVoidResponse() throws -> NetworkResponse<VoidResponse> {
        let data = Data("{}".utf8)
        let decoder = JSONDecoder()
        let voidResponse = try decoder.decode(VoidResponse.self, from: data)
        let httpResponse = HTTPURLResponseMother.makeHTTPURLResponse()

        return .init(value: voidResponse, response: httpResponse)
    }

    static func makeSearchResponse(
        results: [(filename: String, score: Float)] = [
            ("note1.md", 0.95),
            ("note2.md", 0.87),
            ("folder/note3.md", 0.73)
        ]
    ) throws -> NetworkResponse<[SimpleSearchResponse]> {
        let searchResults = results.map { result in
            """
            {
                "filename": "\(result.filename)",
                "score": \(result.score)
            }
            """
        }
        let jsonString = "[\(searchResults.joined(separator: ", "))]"
        let data = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        let searchResponse = try decoder.decode([SimpleSearchResponse].self, from: data)
        let httpResponse = HTTPURLResponseMother.makeHTTPURLResponse()

        return .init(value: searchResponse, response: httpResponse)
    }

    static func makeServerInfoResponse() throws -> NetworkResponse<ServerInfoResponse> {
        let jsonString = """
        {
            "authenticated": true,
            "status": "OK",
            "service": "obsidian-local-rest-api",
            "versions": {
                "obsidian": "1.0.0",
                "self": "1.2.3"
            },
            "manifest": {
                "id": "obsidian-local-rest-api",
                "name": "Local REST API",
                "version": "1.2.3",
                "minAppVersion": "0.15.0",
                "description": "REST API for Obsidian",
                "author": "coddingtonbear",
                "authorUrl": "https://github.com/coddingtonbear",
                "isDesktopOnly": false,
                "dir": "plugins/obsidian-local-rest-api"
            },
            "certificateInfo": null,
            "apiExtensions": []
        }
        """
        let data = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        let serverInfoResponse = try decoder.decode(ServerInfoResponse.self, from: data)
        let httpResponse = HTTPURLResponseMother.makeHTTPURLResponse()

        return .init(value: serverInfoResponse, response: httpResponse)
    }

    static func makeDirectoryListingResponse(
        files: [String] = ["note1.md", "note2.md", "note3.md", "directory1/"]
    ) throws -> NetworkResponse<DirectoryListingResponse> {
        let jsonString = """
        {
            "files": [\(files.map { "\"\($0)\"" }.joined(separator: ", "))]
        }
        """
        let data = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        let directoryResponse = try decoder.decode(DirectoryListingResponse.self, from: data)
        let httpResponse = HTTPURLResponseMother.makeHTTPURLResponse()

        return .init(value: directoryResponse, response: httpResponse)
    }
}
