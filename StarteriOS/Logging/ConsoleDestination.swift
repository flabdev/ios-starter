//
//  ConsoleDestination.swift
//  StarteriOS
//
//  Created by Nagesh on 06/12/18.
//  Copyright © 2018 Nagesh. All rights reserved.
//

import Foundation

class ConsoleDestination: LogDestination {
    
    override var defaultHashValue: Int {
        AppLogger.shared.info("ConsoleDestination defaultHashValue")
        return 1
        
    }
    
    override init() {
        super.init()
    }
    
    // print to Xcode Console. uses full base class functionality
    override func send(_ level: AppLogger.Level, msg: String, module: String = "") -> String? {
        let formattedString = super.send(level, msg: msg, module: module)
        
        if let str = formattedString {
            print(str)
        }
        
        return formattedString
    }
}
