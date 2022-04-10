//
//  LogManager.swift
//  JikanDemo
//
//  Created by ice on 2022/4/10.
//

import Foundation
import CocoaLumberjackSwift

public func logInitail() {
    if let logger = DDTTYLogger.sharedInstance {
        logger.logFormatter = CustomFormat(false)
        DDLog.add(logger)
    }
    
    let fileLogger: DDFileLogger = DDFileLogger()
    fileLogger.logFormatter = CustomFormat(true)
    fileLogger.rollingFrequency = TimeInterval(60*60*24)
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7
    DDLog.add(fileLogger)
}

public func logDebug(_ message: @autoclosure () -> String,
                     file: StaticString = #file,
                     function: StaticString = #function,
                     line: UInt = #line,
                     tag: Any? = nil) {
    DDLogDebug(message(), file: file, function: function, line: line, tag: tag)
}

public func logError(_ message: @autoclosure () -> String,
                     file: StaticString = #file,
                     function: StaticString = #function,
                     line: UInt = #line,
                     tag: Any? = nil) {
    DDLogError(message(), file: file, function: function, line: line, tag: tag)
}

public func logInfo(_ message: @autoclosure () -> String,
                    file: StaticString = #file,
                    function: StaticString = #function,
                    line: UInt = #line,
                    tag: Any? = nil) {
    DDLogInfo(message(), file: file, function: function, line: line, tag: tag)
}

public func logVerbose(_ message: @autoclosure () -> String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line,
                       tag: Any? = nil) {
    DDLogVerbose(message(), file: file, function: function, line: line, tag: tag)
}

public func logWarn(_ message: @autoclosure () -> String,
                    file: StaticString = #file,
                    function: StaticString = #function,
                    line: UInt = #line,
                    tag: Any? = nil) {
    DDLogWarn(message(), file: file, function: function, line: line, tag: tag)
}

class CustomFormat: NSObject, DDLogFormatter {
    private var showDetail: Bool
    init(_ showDetail: Bool) {
        self.showDetail = showDetail
    }
    
    func format(message logMessage: DDLogMessage) -> String? {
        var level = ""
        switch logMessage.flag {
        case .debug: level = "⚫️"
        case .info: level = "⚪️"
        case .warning: level = "🟡"
        case .error: level = "🔴"
        case .verbose: level = "🟤"
        default: level = "🔵"
        }
        
        var result = "\(level)"
        if showDetail {
            result += " \(logMessage.fileName):\(logMessage.function ?? ""):\(logMessage.line) [\(String(describing: logMessage.representedObject))]"
        }
        return "\(result) \(logMessage.message)"
    }
}

