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

public struct ServerInfoResponse: Decodable, Sendable {

    // MARK: - Nested types

    public struct Versions: Decodable, Sendable {

        public let obsidian: String
        public let `self`: String
    }

    public struct Manifest: Decodable, Sendable {

        public let id: String
        public let name: String
        public let version: String
        public let minAppVersion: String
        public let description: String
        public let author: String
        public let authorUrl: String
        public let isDesktopOnly: Bool
        public let dir: String
    }

    public struct CertificateInfo: Decodable, Sendable {

        public let validityDays: Double
        public let regenerateRecommended: Bool
    }

    // MARK: - Properties

    public let authenticated: Bool
    public let status: String
    public let service: String
    public let versions: Versions
    public let manifest: Manifest?
    public let certificateInfo: CertificateInfo?
    public let apiExtensions: [String]?
}
