//
//  VersionUpdaterTests.swift
//  VersionUpdaterTests
//
//  Created by Daichi Nakajima on 2018/06/08.
//  Copyright © 2018 Daichi Nakajima. All rights reserved.
//

import XCTest
@testable import VersionUpdater

class VersionUpdaterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCompareVersion() {
        var updater = updaterForVersion("2.0.0", requiredVersion: "2.0.0")
        XCTAssertEqual(updater.isVersionUpNeeded, true)

        updater = updaterForVersion("2.0.0", requiredVersion: "2.0.1")
        XCTAssertEqual(updater.isVersionUpNeeded, true)

        updater = updaterForVersion("2.0.0", requiredVersion: "1.9.9")
        XCTAssertEqual(updater.isVersionUpNeeded, false)

        updater = updaterForVersion("2.0.1", requiredVersion: "2.0.2")
        XCTAssertEqual(updater.isVersionUpNeeded, true)

        updater = updaterForVersion("2.0.1", requiredVersion: "2.0.11")
        XCTAssertEqual(updater.isVersionUpNeeded, true)

        updater = updaterForVersion("2.1.0", requiredVersion: "2.10.0")
        XCTAssertEqual(updater.isVersionUpNeeded, true)

        updater = updaterForVersion("1.0.0", requiredVersion: "10.0.0")
        XCTAssertEqual(updater.isVersionUpNeeded, true)
    }

    private func updaterForVersion(_ currentVersion: String, requiredVersion: String) -> VersionUpdater {
        let infoDictionary: [String: Any] = ["CFBundleShortVersionString": currentVersion]
        let versionInfo = VersionInfo(requiredVersion: requiredVersion, type: .force, updateURL: URL(string: "http://update.com"))

        let updater = VersionUpdater(
            endPointURL: URL(string: "https://foo.com")!,
            completion: { _ in }
        )
        updater.infoDictionary = infoDictionary
        updater.versionInfo = versionInfo
        return updater
    }
    
}
