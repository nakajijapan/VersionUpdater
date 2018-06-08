//
//  AppDelegate.swift
//  Examples
//
//  Created by Daichi Nakajima on 2018/06/08.
//  Copyright © 2018 Daichi Nakajima. All rights reserved.
//

import UIKit
import VersionUpdater

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

        let versionUpdater = VersionUpdater(
            endPointURL: URL(string: "https://foo.com/ios.json")!,
            completion: { alertController in
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

                if !(appDelegate.window?.rootViewController?.presentedViewController is VersionUpdaterAlertController) {
                    appDelegate.window?.rootViewController?.present(
                        alertController, animated: true, completion: nil
                    )
                }
        })
        versionUpdater.executeVersionCheck()
    }

}

