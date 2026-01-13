import Foundation

// swiftlint:disable force_unwrapping

enum HTTPURLResponseMother {

    static func makeHTTPURLResponse(
        statusCode: Int = 200,
        url: URL = URL(string: "https://test.com")!
    ) -> URLResponse {
        HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}

// swiftlint:enable force_unwrapping
