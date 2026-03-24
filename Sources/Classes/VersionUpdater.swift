import Foundation

public enum VersionUpdaterError: Error, Sendable {
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case noUpdateURL
}

public final class VersionUpdater: Sendable {

    public let endPointURL: URL

    // MARK: - Initialization

    public init(endPointURL: URL) {
        self.endPointURL = endPointURL
    }

    // MARK: - Public API

    /// Fetches version info from the endpoint.
    public func fetchVersionInfo() async throws -> VersionInfo {
        let (data, response) = try await URLSession.shared.data(from: endPointURL)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw VersionUpdaterError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(VersionInfo.self, from: data)
        } catch {
            throw VersionUpdaterError.decodingError(error)
        }
    }

    // MARK: - Version Comparison

    public func isUpdateNeeded(currentVersion: String, requiredVersion: String) -> Bool {
        let current = SemanticVersion(string: currentVersion)
        let required = SemanticVersion(string: requiredVersion)
        return required > current
    }
}
