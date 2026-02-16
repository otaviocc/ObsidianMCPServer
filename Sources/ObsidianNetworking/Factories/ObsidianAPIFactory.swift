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

public struct ObsidianAPIFactory: ObsidianAPIFactoryProtocol {

    // MARK: - Life cycle

    public init() {}

    // MARK: - Public

    public func makeObsidianAPIClient(
        baseURL: URL,
        userToken: @escaping @Sendable () async -> String?
    ) -> NetworkClientProtocol {
        let delegate = InsecureURLSessionDelegate()

        let session = URLSession(
            configuration: .default,
            delegate: delegate,
            delegateQueue: nil
        )

        let configuration = NetworkConfiguration(
            session: session,
            defaultDecoder: JSONDecoder(),
            defaultEncoder: JSONEncoder(),
            baseURL: baseURL,
            interceptors: [
                BearerAuthorizationInterceptor(
                    tokenProvider: userToken
                )
            ]
        )

        return NetworkClient(configuration: configuration)
    }
}

// MARK: - URLSessionDelegate

final class InsecureURLSessionDelegate: NSObject, URLSessionDelegate {

    // MARK: - Public

    /// Handles server trust authentication challenges by accepting self-signed certificates.
    ///
    /// This method is specifically used to ignore the self-signed certificate of the Obsidian REST API community
    /// plugin, allowing connections to proceed without standard certificate validation. This is necessary for
    /// development or community plugin environments where a trusted certificate authority is not used.
    ///
    /// - Parameters:
    ///   - session: The URL session containing the task that received the authentication challenge.
    ///   - challenge: The authentication challenge that needs to be handled.
    ///   - completionHandler: A closure that your handler must call, providing information about how to handle
    ///     the challenge.
    func urlSession(
        _: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        let credential = challenge.protectionSpace.serverTrust.flatMap(URLCredential.init)
        completionHandler(.useCredential, credential)
    }
}
