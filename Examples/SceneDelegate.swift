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
                try await updater.executeVersionCheck()
            } catch {
                print("Version check failed: \(error)")
            }
        }
    }
}
