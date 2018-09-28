//
//  WindowManager.swift
//  VersionUpdater
//
//  Created by Daichi Nakajima on 2018/06/11.
//  Copyright © 2018 Daichi Nakajima. All rights reserved.
//

import UIKit

class WindowHandler {
    static let shared = WindowHandler()
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

        window?.windowLevel = UIWindow.Level.alert
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
