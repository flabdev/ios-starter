//
//  FileDestination.swift
//  StarteriOS
//
//  Created by Nagesh on 10/12/18.
//  Copyright © 2018 Nagesh. All rights reserved.
//

import Foundation

class FileDestination: LogDestination {
    private var logFileURL: URL?
    private var syncAfterEachWrite: Bool = false
    private var fileHandle: FileHandle?
    override var defaultHashValue: Int {
        AppLogger.shared.info("defaultHashValue set")
        return 2
    }
    
    private let APP_LOG_FILE_KEY = "AppLogFileKey"
    // Default file size is 2MB
    private var MAX_FILE_SIZE: UInt64 = 2 * 1024 * 1024
    // Default file rotation cycle is 30
    private var FILE_ROTATION_CYCLE = 30
    
    override init() {
        super.init()
        self.generateLogFileURL()
    }
    
    // append to file. uses full base class functionality
    override func send(_ level: AppLogger.Level, msg: String, module: String = "") -> String? {
        let formattedString = super.send(level, msg: msg, module: module)
        
        if let str = formattedString {
            _ = saveToFile(str: str)
        }
        return formattedString
    }
    
    deinit {
        // close file handle if set
        if let fileHandle = fileHandle {
            fileHandle.closeFile()
        }
    }
    
    func setMaxLogFile(size: UInt64) {
        if size != 0 && MAX_FILE_SIZE != size {
            MAX_FILE_SIZE = size
        }
    }
    
    func setFile(rotation: Int) {
        if rotation != 0 && FILE_ROTATION_CYCLE != rotation {
            FILE_ROTATION_CYCLE = rotation
        }
    }
    
    /* deletes log file.
     * returns true if file was removed or does not exist, false otherwise
     */
    @discardableResult
    func delete(logFile: String) -> Bool {
        
        if let url = URL(string: logFile) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("ERROR: Logger File Destination could not remove file \(url).")
                return false
            }
        }
        return true
    }
    
    // MARK: - Helper
    
    private func generateLogFileURL() {
        let baseURL = logDirectory()
        var logFileName: String
        
        if let fileName = UserDefaults.standard.value(forKey: APP_LOG_FILE_KEY) as? String,
            baseURL.appendingPathComponent(fileName, isDirectory: false).fileSize <= MAX_FILE_SIZE {
            logFileName = fileName
        } else {
            // Log file rotation
            logFileRotation()
            logFileName = self.newLogFileName()
            UserDefaults.standard.set(logFileName, forKey: APP_LOG_FILE_KEY)
        }
        
        logFileURL = baseURL.appendingPathComponent(logFileName, isDirectory: false)
    }
    
    /* Appends a string as line to a file.
     * returns true if line is appended successfully
     */
    private func saveToFile(str: String) -> Bool {
        guard let url = logFileURL else { return false }
        do {
            if !FileManager.default.fileExists(atPath: url.path) {
                // create file if not existing
                let line = str + "\n"
                try line.write(to: url, atomically: true, encoding: .utf8)
                
            } else {
                
                if fileHandle == nil {
                    fileHandle = try FileHandle(forWritingTo: url as URL)
                }
                if let fileHandle = fileHandle {
                    _ = fileHandle.seekToEndOfFile()
                    let line = str + "\n"
                    if let data = line.data(using: String.Encoding.utf8) {
                        fileHandle.write(data)
                        if syncAfterEachWrite {
                            fileHandle.synchronizeFile()
                        }
                    }
                }
            }
            return true
        } catch {
            print("ERROR: AppLogger File Destination could not write to file \(url).")
            return false
        }
    }
    
    private func logDirectory() -> URL {
        let baseURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        var logDir = baseURL!
        if let dir = baseURL?.appendingPathComponent("Logs", isDirectory: true) {
            logDir = dir
        }

        do {
            try FileManager.default.createDirectory(at: logDir, withIntermediateDirectories: true, attributes: nil)
        } catch {
             AppLogger.shared.error("ERROR: Failed to create directory!", module: AppLogger.Module.UTILITIES)
        }
        return logDir
    }
    
    private func newLogFileName() -> String {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? ""
        let dateFormatter = DateFormatter.formatDate("yyyy-MM-dd--HH-mm-ss-SSS", timeZone: "UTC")
        
        return appName + dateFormatter + ".log"
    }
    
    private func logFileRotation() {
        let logs = logFiles()
        var sortedLogs = logs.sorted(by: { $0 > $1 })
        while sortedLogs.count >= FILE_ROTATION_CYCLE {
            if let logFilePath = sortedLogs.last,
                self.delete(logFile: logFilePath) {
                sortedLogs.remove(at: sortedLogs.count - 1)
            }
        }
    }
    
    private func logFiles() -> [String] {
        let logDir = logDirectory()
        var dirContents = [String]()
        do {
            let dirs = try FileManager.default.contentsOfDirectory(at: logDir, includingPropertiesForKeys: nil, options: [FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants])
            dirContents = dirs.map { $0.absoluteString }
        } catch {
            print(error.localizedDescription)
        }
        return dirContents
    }
    
}

// MARK: - URL extension
extension URL {
    var attributes: [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("ERROR: FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        print("")
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
}
