//
//  AppLogger.swift
//  StarteriOS
//
//  Created by Nagesh on 06/12/18.
//  Copyright © 2018 Nagesh. All rights reserved.
//

import Foundation

@objcMembers
class AppLogger: NSObject {
    static let shared = AppLogger()
    
    // Log levels
   @objc enum Level: Int {
        case verbose = 0
        case debug = 1
        case info = 2
        case warning = 3
        case error = 4
    }
    
    // Module Names
    struct Module {
        static let APPDELEGATE = "APPDELEGATE"
        static let UTILITIES = "UTILITIES"
        static let NETWORK = "NETWORK"
        static let OFFLINESYNC = "OFFLINESYNC"
        static let NOTIFICATIONS = "NOTIFICATIONS"
        static let UIACTION = "UIACTION"
    }
    deinit {
        print("Deinit AppLogger!!!")
    }
    
    override private init () {
        // Enable console logging in debug mode
        #if DEBUG
        let console = ConsoleDestination()
        console.minLevel = .debug
        AppLogger.destinations.insert(console)
        #endif
    }
    
    // a set of active destinations
    private(set) static var destinations = Set<LogDestination>()
    
    // MARK: Destination Handling
    @discardableResult
    func addDestination(_ destination: LogDestination) -> Bool {
        if AppLogger.destinations.contains(destination) {
            return false
        }
        AppLogger.destinations.insert(destination)
        return true
    }
    
    // remove Destination
    @discardableResult
    func removeDestination(_ destination: LogDestination) -> Bool {
        if !AppLogger.destinations.contains(destination) {
            return false
        }
        AppLogger.destinations.remove(destination)
        return true
    }
    
    // Remove all the destination to restart logging
    func removeAllDestinations() {
        AppLogger.destinations.removeAll()
    }
    
    // Destination count
    func countDestinations() -> Int {
        AppLogger.shared.info("countDestinations")
        return AppLogger.destinations.count
    }
    
    /*
     * Update log level if it's not the console
     */
    func updateLog(level: Level) {
        for dest in AppLogger.destinations {
            guard (dest as? ConsoleDestination) == nil else {
                continue
            }
            dest.minLevel = level
        }
    }
    
    // MARK: Log Levels
    // lowest priority - log generally unimportant
    func verbose(_ message: @autoclosure () -> String, module: String = "") {
        log(level: .verbose, message: message(), module: module)
    }
    
    // lowest priority - log which help during debugging
    func debug(_ message: @autoclosure () -> String, module: String = "") {
        log(level: .debug, message: message(), module: module)
    }
    
    // normal priority - log which you are really interested however they are not an issue or error
    func info(_ message: @autoclosure () -> String, module: String = "") {
        log(level: .info, message: message(), module: module)
    }
    
    // high priority - log which may cause big trouble soon
    func warning(_ message: @autoclosure () -> String, module: String = "") {
        log(level: .warning, message: message(), module: module)
    }
    
    // highest priority - log which will keep you awake at night
    func error(_ message: @autoclosure () -> String, module: String = "") {
        log(level: .error, message: message(), module: module)
    }
    
    // custom logging to manually adjust values
    func log(level: AppLogger.Level, message: @autoclosure () -> String, module: String = "") {
        dispatch_send(level: level, message: message(), module: module)
    }
    
    // custom logging to manually adjust values
    func objCLog(level: AppLogger.Level, message: String, module: String = "") {
        log(level: level, message: message, module: module)
        }
    
    // internal helper which dispatches send to dedicated queue if minLevel is ok
    private func dispatch_send(level: AppLogger.Level, message: @autoclosure () -> Any, module: String) {
        var resolvedMessage: String?
        for dest in AppLogger.destinations {
            guard let queue = dest.queue else {
                continue
            }
            
            resolvedMessage = resolvedMessage == nil ? "\(message())" : resolvedMessage
            if dest.shouldLevelBeLogged(level) {
                // try to convert msg object to String and put it on queue
                let msgStr = resolvedMessage == nil ? "\(message())" : resolvedMessage!
                
                if dest.asynchronously {
                    queue.async {
                        _ = dest.send(level, msg: msgStr, module: module)
                    }
                } else {
                    queue.sync {
                        _ = dest.send(level, msg: msgStr, module: module)
                    }
                }
            }
        }
    }
}
