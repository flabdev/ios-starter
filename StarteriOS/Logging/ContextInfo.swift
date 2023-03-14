//
//  ContextInfo.swift
//  StarteriOS
//
//  Created by Nagesh on 05/12/18.
//  Copyright © 2018 Nagesh. All rights reserved.
//

import Foundation
import UIKit

struct ContextInfo: Codable {
    let osVersion: String?
    let platform: String?
    let appVersion: String?
    let deviceTimeZone: String?
    let deviceModel: String?
    
    enum CodingKeys: String, CodingKey {
        case osVersion
        case platform
        case appVersion
        case deviceTimeZone
        case deviceModel 
    }
    
    init() {
        self.osVersion = UIDevice.current.systemVersion
        self.platform = UIDevice.current.systemName
        self.appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        self.deviceTimeZone = TimeZone.current.getLocalTimeOffset()
        self.deviceModel = UIDevice.current.model
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        osVersion = try values.decodeIfPresent(String.self, forKey: .osVersion)
        platform = try values.decodeIfPresent(String.self, forKey: .platform)
        appVersion = try values.decodeIfPresent(String.self, forKey: .appVersion)
        deviceTimeZone = try values.decodeIfPresent(String.self, forKey: .deviceTimeZone)
        deviceModel = try values.decodeIfPresent(String.self, forKey: .deviceModel)
    }    
}

