import Foundation

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
