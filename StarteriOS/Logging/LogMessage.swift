//
//  LogMessage.swift
//  StarteriOS
//
//  Created by Nagesh on 11/12/18.
//  Copyright © 2018 Nagesh. All rights reserved.
//

import Foundation


struct LogMessage: Codable {
    let module: String?
    let message: String?
    let dateTime: String?
    let logLevel: String?
    let context: ContextInfo?
    
    enum CodingKeys: String, CodingKey {
        
        case module
        case message
        case dateTime
        case logLevel
        case context 
    }
    
    init(module: String?, message: String?, dateTime: String?, logLevel: String?, context: ContextInfo?) {
        self.module = module
        self.message = message
        self.dateTime = dateTime
        self.logLevel = logLevel
        self.context = context
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        module = try values.decodeIfPresent(String.self, forKey: .module)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        dateTime = try values.decodeIfPresent(String.self, forKey: .dateTime)
        logLevel = try values.decodeIfPresent(String.self, forKey: .logLevel)
        context = try values.decodeIfPresent(ContextInfo.self, forKey: .context)
    }
    
}
