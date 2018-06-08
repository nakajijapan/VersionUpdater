//
//  Shari.swift
//  Pods
//
//  Created by nakajijapan on 2015/12/24.
//
//
import Foundation
import UIKit

public class VersionUpdater {

    let endPointURL: URL
    let customAlertTitle: String
    let customAlertBody: String
    let completionBlock: (_ alertController: VersionUpdaterAlertController) -> Void

    var versionInfo: VersionInfo!
    var infoDictionary = Bundle.main.infoDictionary!

    public init(endPointURL: URL, completion: @escaping (_ alertController: VersionUpdaterAlertController) -> Void) {
        self.endPointURL = endPointURL
        self.customAlertTitle = ""
        self.customAlertBody = ""
        self.completionBlock = completion
    }

    public init(endPointURL: URL, customAlertTitle: String, customAlertBody: String, completion: @escaping (_ alertController: VersionUpdaterAlertController) -> Void) {
        self.endPointURL = endPointURL
        self.customAlertTitle = customAlertTitle
        self.customAlertBody = customAlertBody
        self.completionBlock = completion
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
        showUpdateAnnounce()
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
                guard UIApplication.shared.canOpenURL(self.versionInfo.updateURL) else {
                    return
                }

                guard let updateURL = self.versionInfo.updateURL else {
                    return
                }

                UIApplication.shared.open(
                    updateURL,
                    options: [:],
                    completionHandler: nil
                )
        }))

        if versionInfo.type == .optional {
            alertController.addAction(UIAlertAction(
                title: cancelButtonText,
                style: UIAlertActionStyle.cancel,
                handler: nil)
            )
        }

        completionBlock(alertController)
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

