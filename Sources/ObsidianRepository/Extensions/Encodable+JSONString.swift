import Foundation

extension Encodable {

    func toJSONString() throws -> String {
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(self)

        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: [],
                    debugDescription: "Failed to convert JSON data to UTF-8 string"
                )
            )
        }
    }
}
