//
//  SemanticVersion.swift
//  VersionUpdater
//
//  Created by Daichi Nakajima on 2018/06/08.
//  Copyright © 2018 Daichi Nakajima. All rights reserved.
//

import Foundation

struct SemanticVersion {
    let major: Int
    let minor: Int
    let patch: Int

    init(string: String) {
        let numbers = string.components(separatedBy: ".")
        self.major = Int(numbers.first ?? "") ?? 0
        self.minor = Int(numbers[1]) ?? 0
        self.patch = Int(numbers.last ?? "") ?? 0
    }

    func compare(_ version: SemanticVersion) -> ComparisonResult {
        if major > version.major {
            return .orderedDescending
        } else if major < version.major {
            return .orderedAscending
        }

        if minor > version.minor {
            return .orderedDescending
        } else if minor < version.minor {
            return .orderedAscending
        }

        if patch > version.patch {
            return .orderedDescending
        } else if patch < version.patch {
            return .orderedAscending
        }

        return .orderedSame
    }
}
