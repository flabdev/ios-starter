//
//  DateFormatter.swift
//  StarteriOS
//
//  Created by Nagesh Kumar Mishra on 24/02/23.
// 
//

import Foundation

extension DateFormatter {
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
    
    static func formatDate(_ dateFormat: String, timeZone: String = "") -> String {
        let formatter = DateFormatter()
        if !timeZone.isEmpty {
            formatter.timeZone = TimeZone(abbreviation: timeZone)
        }
        formatter.dateFormat = dateFormat
        let dateStr = formatter.string(from: Date())
        return dateStr
    }
    
    static func stringToDate(from dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        
        if dateString.contains("T") {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        } else if dateString.contains(" ") && dateString.count <= 11 {
            dateFormatter.dateFormat = "h:mm:ss a"
            dateFormatter.defaultDate = Date()
        } else if dateString.count <= 8 {
            dateFormatter.dateFormat = "HH:mm:ss"
            dateFormatter.defaultDate = Date()
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
        
        dateFormatter.locale = NSLocale.current
        let date = dateFormatter.date(from: dateString)
        return date ?? Date()
    }
    
    static func getTime(dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = formatter.date(from: dateString)
        formatter.timeStyle = .short
        
        formatter.dateFormat = "H:mm"
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone.current
        let formattedDateString = formatter.string(from: date!)
        return formattedDateString
    }
    
    static func getTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.timeStyle = .short
        formatter.dateFormat = "H:mm"
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone.current
        let formattedDateString = formatter.string(from: date)
        return formattedDateString
    }
    
    static func formatDate(_ dateFormat: String, date: Date, timeZone: String = "") -> String {
        let formatter = DateFormatter()
        if !timeZone.isEmpty {
            formatter.timeZone = TimeZone(abbreviation: timeZone)
        }
        formatter.dateFormat = dateFormat
        let dateStr = formatter.string(from: date)
        return dateStr
    }
}
