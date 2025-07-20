import Foundation

public struct DirectoryListingResponse: Decodable {

    // MARK: - Properties

    public let files: [String]

    public var fileURLs: [URL] {
        files.map { file in
            if file.hasSuffix("/") {
                let directoryName = String(file.dropLast())
                return URL(fileURLWithPath: directoryName, isDirectory: true)
            } else {
                return URL(fileURLWithPath: file)
            }
        }
    }
}
