//
//  Logger.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 10.07.2024.
//
import Foundation
import CocoaLumberjack

class Logger {
    static func configureLogger() {
        
        DDLog.add(DDOSLogger.sharedInstance)
        
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60*60*24)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        let logFormatter = LogFormatter()
        DDTTYLogger.sharedInstance?.logFormatter = logFormatter
        DDASLLogger.sharedInstance.logFormatter = logFormatter
        fileLogger.logFormatter = logFormatter
    }
}

class LogFormatter: NSObject, DDLogFormatter {
    let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss:SSS"
    }
    
    func format(message logMessage: DDLogMessage) -> String? {
        let dateAndTime = dateFormatter.string(from: logMessage.timestamp)
        return "\(dateAndTime) [\(logMessage.level)] [\(logMessage.fileName):\(logMessage.line)] \(logMessage.message)"
    }
}
