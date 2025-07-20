import Foundation

public struct DirectoryListingResponse: Decodable {

    // MARK: - Properties

    public let files: [String]

    public var fileURLs: [URL] {
        files.map { file in
            if file.hasSuffix("/") {
                let directoryName = String(file.dropLast())
                return .init(fileURLWithPath: directoryName, isDirectory: true)
            } else {
                return .init(fileURLWithPath: file)
            }
        }
    }
}
