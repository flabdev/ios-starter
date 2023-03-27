//
//  LogDestination.swift
//  StarteriOS
//
//  Created by Nagesh on 06/12/18.
//  Copyright © 2018 Nagesh. All rights reserved.
//

import Foundation

class LogDestination: Hashable, Equatable {
    
    enum LogFormat: Int {
        case JSON
        case DEFAULT
    }
    
    // Log format
    var logFormat = LogFormat.DEFAULT
    
    // Runs in own serial background thread for better performance
    var asynchronously = true
    
    // Default log level
    var minLevel = Logger.Level.info
    
    struct LevelString {
        let verbose = "VERBOSE"
        let debug = "DEBUG"
        let info = "INFO"
        let warning = "WARNING"
        let error = "ERROR"
    }
    
    // Level string
    var levelString = LevelString()
    
    // Each destination will have it's own serial queue to ensure output sequence
    var queue: DispatchQueue?
    
    init() {
        let uuid = NSUUID().uuidString
        let queueLabel = "AppLogger-queue-" + uuid
        queue = DispatchQueue(label: queueLabel, target: queue)
    }
    
    func send(_ level: Logger.Level, msg: String, module: String = "") -> String? {
        var formattedMessage: String?
        if logFormat == LogFormat.JSON {
            formattedMessage = messageToJSON(level, msg: msg, module: module)
        } else {
            formattedMessage = formatMessage(level: level, msg: msg, module: module)
        }
        return formattedMessage
    }
    
    func execute(synchronously: Bool, block: @escaping () -> Void) {
        guard let queue = queue else {
            fatalError("Queue is not initialized!")
        }
        if synchronously {
            queue.sync(execute: block)
        } else {
            queue.async(execute: block)
        }
    }
    
    func executeSynchronously<T>(block: @escaping () throws -> T) rethrows -> T {
        guard let queue = queue else {
            fatalError("Queue is not initialized!")
        }
        return try queue.sync(execute: block)
    }
    
    // MARK: - Helper methods
    
    /* Checks if level is at least minLevel or if a minLevel filter for that path does exist
     * returns boolean and can be used to decide if a message should be logged or not
     */
    func shouldLevelBeLogged(_ level: Logger.Level) -> Bool {
            var shouldLogged = false
            if level.rawValue >= minLevel.rawValue {
                shouldLogged = true
        }
        return shouldLogged
    }
    
    func messageToJSON(_ level: Logger.Level, msg: String, module: String = "") -> String? {
        let isoFormatter = ISO8601DateFormatter()
        let logMsg = LogMessage(module: module, message: msg, dateTime: isoFormatter.string(from: Date()), logLevel: levelWord(level), context: ContextInfo())
        var dict = [String: Any]()
        
        do {
            dict = try logMsg.asDictionary() as [String: Any]
        } catch {
            Logger.shared.error("failed to convert log message object into dictionary!", module: Logger.Module.UTILITIES)
            return jsonStringFromDict(["module": module, "level": levelWord(level), "message": msg])
        }
        return jsonStringFromDict(dict)
    }
    
    func jsonStringFromDict(_ dict: [String: Any]) -> String? {
        var jsonString: String?
        
        // try to create JSON string
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            jsonString = String(data: jsonData, encoding: .utf8)
        } catch {
            Logger.shared.error("AppLogger could not create JSON from dict.", module: Logger.Module.UTILITIES)
        }
        return jsonString
    }
    
    func formatMessage(level: Logger.Level, msg: String, module: String = "") -> String {
        var text = DateFormatter.formatDate("yyyy-MM-dd HH:mm:ss", timeZone: "UTC")
        let padding = " "
        text += padding + levelWord(level)
        
        if !module.isEmpty {
            text += padding + module
        }
        text += padding + msg
        
        return text
    }
    
    func levelWord(_ level: Logger.Level) -> String {
        
        var str = ""
        
        switch level {
        case .debug:
            str = levelString.debug
            
        case .info:
            str = levelString.info
            
        case .warning:
            str = levelString.warning
            
        case .error:
            str = levelString.error
            
        default:
            // Verbose is default
            str = levelString.verbose
        }
        return str
    }
    
    // MARK: - Hashable protocol
    public lazy var hashValue: Int = self.defaultHashValue
    var defaultHashValue: Int {
        Logger.shared.info("defaultHashValue")
        return 0
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(HashValue.defaultHashValue)
    }
    
    // MARK: - Equatable protocol
    static func == (lhs: LogDestination, rhs: LogDestination) -> Bool {
        Logger.shared.info("LogDestination")
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

enum HashValue: Hashable {
    case defaultHashValue
    
    func hash(into hasher: inout Hasher) {
        switch self {
            case .defaultHashValue: hasher.combine(0)
        }
    }
}
