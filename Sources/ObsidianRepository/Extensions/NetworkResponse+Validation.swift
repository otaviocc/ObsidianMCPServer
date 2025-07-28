import Foundation
import MicroClient

extension NetworkResponse {

    func validate() throws(RepositoryError) {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw .invalidResponse
        }

        let statusCode = httpResponse.statusCode

        guard 200..<300 ~= statusCode else {
            let message = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            throw .operationFailed(statusCode: statusCode, message: message)
        }
    }
}
