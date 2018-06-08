//
//  VersionInfo.swift
//  VersionUpdater
//
//  Created by Daichi Nakajima on 2018/06/08.
//  Copyright © 2018 Daichi Nakajima. All rights reserved.
//

import Foundation

struct VersionInfo: Codable {
    var requiredVersion = ""
    var type: UpdateType = .optional
    let updateURL: URL!

    enum UpdateType: String, Codable {
        case force
        case optional
    }

    enum CodingKeys: String, CodingKey {
        case requiredVersion = "required_version"
        case type
        case updateURL = "update_url"
    }
}
