import Foundation

public struct ServerInfoResponse: Decodable {

    // MARK: - Nested types

    public struct Versions: Decodable {
        public let obsidian: String
        public let `self`: String
    }

    public struct Manifest: Decodable {
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

    public struct CertificateInfo: Decodable {
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
