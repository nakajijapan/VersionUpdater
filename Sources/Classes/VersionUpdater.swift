//
//  Shari.swift
//  Pods
//
//  Created by nakajijapan on 2015/12/24.
//
//
import Foundation
import UIKit

class WindowManager {
    static let shared = WindowManager()
    var window: UIWindow?
    var mainWindow: UIWindow!

    func present(viewController: UIViewController) {
        if self.window != nil {
            return
        }

        mainWindow = UIApplication.shared.windows[0]

        let aWindow = UIWindow(frame: UIScreen.main.bounds)
        aWindow.backgroundColor = UIColor.clear
        aWindow.rootViewController = UIViewController()
        self.window = aWindow

        window?.windowLevel = UIWindowLevelAlert
        window?.makeKeyAndVisible()
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }

    func dismiss() {
        window?.isHidden = true
        window?.removeFromSuperview()
        window = nil
        mainWindow.makeKeyAndVisible()
        mainWindow = nil
    }
}

public class VersionUpdater {

    let endPointURL: URL
    let customAlertTitle: String
    let customAlertBody: String

    var versionInfo: VersionInfo!
    var infoDictionary = Bundle.main.infoDictionary!

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

    public func executeVersionCheck() {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let request = URLRequest(url: endPointURL)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }

            do {
                let decodedData = try JSONDecoder().decode(VersionInfo.self, from: data)
                self.versionInfo = decodedData
                self.showUpdateAnnounceIfNeeded()
             } catch {
                print("Error: \(error.localizedDescription)")
            }

        }
        task.resume()
    }
}

extension VersionUpdater {

    func showUpdateAnnounceIfNeeded() {
        if !isVersionUpNeeded {
            return
        }
        DispatchQueue.main.async { 
            self.showUpdateAnnounce()
        }
    }

    func showUpdateAnnounce() {
        let alertController = VersionUpdaterAlertController(
            title: alertTitle,
            message: alertBody,
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(
            title: updateButtonText,
            style: UIAlertActionStyle.default,
            handler: { action in
                guard UIApplication.shared.canOpenURL(self.versionInfo.updateURL) else { return }
                guard let updateURL = self.versionInfo.updateURL else { return }

                UIApplication.shared.open(updateURL, options: [:], completionHandler: { _ in
                    WindowManager.shared.dismiss()
                })
        }))

        if versionInfo.type == .optional {
            alertController.addAction(
                UIAlertAction(
                    title: cancelButtonText,
                    style: UIAlertActionStyle.cancel,
                    handler: { _ in
                        WindowManager.shared.dismiss()
                })
            )
        }

        WindowManager.shared.present(viewController: alertController)
    }

    var isVersionUpNeeded: Bool {
        let currentVersionString = (infoDictionary["CFBundleShortVersionString"] as? String) ?? ""
        let requiredVersionString = versionInfo.requiredVersion
        let currentVersion = SemanticVersion(string: currentVersionString)
        let requiredVersion = SemanticVersion(string: requiredVersionString)

        let comparision = requiredVersion.compare(currentVersion)
        return comparision == .orderedDescending || comparision == .orderedSame
    }

    public var alertTitle: String {
        if customAlertTitle.isEmpty {
            return localizedStringWithFormat(key: "VersionUpdater.alert.title")
        }
        return customAlertTitle
    }

    var alertBody: String {
        if customAlertBody.isEmpty {
            return localizedStringWithFormat(key: "VersionUpdater.alert.body")
        }
        return customAlertBody
    }

    var updateButtonText: String {
        return localizedStringWithFormat(key: "VersionUpdater.alert.updateButton")
    }

    var cancelButtonText: String {
        return localizedStringWithFormat(key: "VersionUpdater.alert.calcelButton")
    }

    func localizedStringWithFormat(key: String) -> String {

        let bundlePath = Bundle.main.path(
            forResource: "VersionUpdater",
            ofType: "bundle",
            inDirectory: "Frameworks/VersionUpdater.framework"
            )!

        let bundle = Bundle(path: bundlePath)!
        let string = NSLocalizedString(key, tableName: "VersionUpdater", bundle: bundle, comment: "")
        return string
    }

}

