import Foundation

public struct SemanticVersion: Sendable, Equatable {
    public let major: Int
    public let minor: Int
    public let patch: Int

    public init(major: Int, minor: Int, patch: Int) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    public init(string: String) {
        let components = string.components(separatedBy: ".")
        self.major = components.indices.contains(0) ? (Int(components[0]) ?? 0) : 0
        self.minor = components.indices.contains(1) ? (Int(components[1]) ?? 0) : 0
        self.patch = components.indices.contains(2) ? (Int(components[2]) ?? 0) : 0
    }
}

extension SemanticVersion: Comparable {
    public static func < (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }
}

extension SemanticVersion: CustomStringConvertible {
    public var description: String {
        "\(major).\(minor).\(patch)"
    }
}
