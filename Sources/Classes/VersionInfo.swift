import Foundation

public struct VersionInfo: Codable, Sendable {
    public let requiredVersion: String
    public let type: UpdateType
    public let updateURL: URL?

    public enum UpdateType: String, Codable, Sendable {
        case force
        case optional
    }

    enum CodingKeys: String, CodingKey {
        case requiredVersion = "required_version"
        case type
        case updateURL = "update_url"
    }

    public init(requiredVersion: String, type: UpdateType, updateURL: URL?) {
        self.requiredVersion = requiredVersion
        self.type = type
        self.updateURL = updateURL
    }
}
