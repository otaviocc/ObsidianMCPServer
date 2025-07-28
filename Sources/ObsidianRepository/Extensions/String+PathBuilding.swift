import Foundation

extension String {

    func appendingPathComponent(_ filename: String) -> String {
        if isEmpty {
            return filename
        }

        let directoryPath = hasSuffix("/") ? self : "\(self)/"
        return "\(directoryPath)\(filename)"
    }
}
