import UIKit
import VersionUpdater

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func sceneDidBecomeActive(_ scene: UIScene) {
        let updater = VersionUpdater(
            endPointURL: URL(string: "https://example.com/ios.json")!
        )
        Task {
            do {
                let info = try await updater.fetchVersionInfo()
                let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"

                if updater.isUpdateNeeded(currentVersion: currentVersion, requiredVersion: info.requiredVersion) {
                    await showUpdateAlert(info: info, isForced: info.type == .force)
                }
            } catch {
                print("Version check failed: \(error)")
            }
        }
    }

    @MainActor
    private func showUpdateAlert(info: VersionInfo, isForced: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let rootVC = windowScene.windows.first(where: \.isKeyWindow)?.rootViewController else {
            return
        }

        let alert = UIAlertController(
            title: "Update Available",
            message: "A new version is available. Please update.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Update", style: .default) { _ in
            if let url = info.updateURL, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        })

        if !isForced {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }

        var topController: UIViewController = rootVC
        while let presented = topController.presentedViewController {
            topController = presented
        }
        topController.present(alert, animated: true)
    }
}
