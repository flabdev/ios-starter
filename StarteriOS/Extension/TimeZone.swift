//
//  TimeZone.swift
//  StarteriOS
//
//  Created by Nagesh Kumar Mishra on 24/02/23.
//

import Foundation

extension TimeZone {
    
    /**
     getLocalTimeOffset - Extract the local time zone offset
     - Returns: Returns the local time zone string in the form of Z i.e. +0530
     */
    func getLocalTimeOffset() -> String {
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.locale = NSLocale.current
        localTimeZoneFormatter.timeZone = self
        localTimeZoneFormatter.dateFormat = "Z"
        return localTimeZoneFormatter.string(from: Date())
    }
    
}
