// MIT License
//
// Copyright (c) 2026 Otávio C.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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

    static func makeFrontmatterUpdateResponse() throws -> NetworkResponse<VoidResponse> {
        try makeVoidResponse()
    }

    static func makeErrorResponse(statusCode: Int) throws -> NetworkResponse<VoidResponse> {
        let data = Data("{}".utf8)
        let decoder = JSONDecoder()
        let voidResponse = try decoder.decode(VoidResponse.self, from: data)
        let httpResponse = HTTPURLResponseMother.makeHTTPURLResponse(statusCode: statusCode)

        return .init(value: voidResponse, response: httpResponse)
    }
}
