import SwiftUI
import VersionUpdater

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var showUpdateAlert = false
    @State private var versionInfo: VersionInfo?
    @State private var errorMessage: String?

    private let updater = VersionUpdater(
        endPointURL: URL(string: "https://example.com/ios.json")!
    )

    var body: some View {
        VStack {
            Text("VersionUpdater Example")
        }
        .task {
            await checkVersion()
        }
        .alert("Update Available", isPresented: $showUpdateAlert, presenting: versionInfo) { info in
            Button("Update") {
                if let url = info.updateURL {
                    UIApplication.shared.open(url)
                }
            }
            if info.type == .optional {
                Button("Cancel", role: .cancel) {}
            }
        } message: { _ in
            Text("A new version is available. Please update.")
        }
    }

    private func checkVersion() async {
        do {
            let info = try await updater.fetchVersionInfo()
            let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"

            if updater.isUpdateNeeded(currentVersion: currentVersion, requiredVersion: info.requiredVersion) {
                versionInfo = info
                showUpdateAlert = true
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
