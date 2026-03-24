import Foundation
import UIKit

public enum VersionUpdaterError: Error, Sendable {
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case noUpdateURL
}

@MainActor
public final class VersionUpdater {

    private static var resourceBundle: Bundle = {
        #if SWIFT_PACKAGE
        return .module
        #else
        return Bundle(for: VersionUpdater.self)
        #endif
    }()

    public let endPointURL: URL
    public var customAlertTitle: String
    public var customAlertBody: String

    private(set) var versionInfo: VersionInfo?

    var currentAppVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }

    // MARK: - Initialization

    public init(endPointURL: URL) {
        self.endPointURL = endPointURL
        self.customAlertTitle = ""
        self.customAlertBody = ""
    }

    public init(endPointURL: URL, customAlertTitle: String, customAlertBody: String) {
        self.endPointURL = endPointURL
        self.customAlertTitle = customAlertTitle
        self.customAlertBody = customAlertBody
    }

    // MARK: - Public API

    /// Fetches version info from the endpoint and shows an update alert if needed.
    public func executeVersionCheck() async throws {
        let info = try await fetchVersionInfo()
        self.versionInfo = info

        if isUpdateNeeded(currentVersion: currentAppVersion, requiredVersion: info.requiredVersion) {
            showUpdateAlert(for: info)
        }
    }

    /// Fetches version info without presenting UI.
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

    // MARK: - Alert Presentation

    private func showUpdateAlert(for info: VersionInfo) {
        let title = customAlertTitle.isEmpty
            ? String(localized: "alert.title", bundle: Self.resourceBundle)
            : customAlertTitle
        let body = customAlertBody.isEmpty
            ? String(localized: "alert.body", bundle: Self.resourceBundle)
            : customAlertBody

        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)

        let downloadTitle = String(localized: "alert.updateButton", bundle: Self.resourceBundle)
        alert.addAction(UIAlertAction(title: downloadTitle, style: .default) { [weak self] _ in
            self?.openUpdateURL(info.updateURL)
        })

        if info.type == .optional {
            let cancelTitle = String(localized: "alert.cancelButton", bundle: Self.resourceBundle)
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        }

        presentAlert(alert)
    }

    private func openUpdateURL(_ url: URL?) {
        guard let url, UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }

    private func presentAlert(_ alert: UIAlertController) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let rootViewController = windowScene.windows.first(where: \.isKeyWindow)?.rootViewController else {
            return
        }

        var topController = rootViewController
        while let presented = topController.presentedViewController {
            topController = presented
        }
        topController.present(alert, animated: true)
    }
}
