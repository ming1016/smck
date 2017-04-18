//
//  ConsoleIO.swift
//  SMCheckProjectCL
//
//  Created by daiming on 2017/3/6.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

enum OutputType {
    case error
    case standard
    case description
}

enum OptionType: String {
    case seekFile = "s"       //列出文件夹下的所有文件
    case unUseMethods = "m"   //列出文件夹下没有用到的函数
    case unUseObject = "o"    //列出无用类
    case h5ToSwift = "h2s"    //将h5转swift
    case help = "h"           //查看帮助
    case quit = "q"           //退出互动操作
    case unknown
    
    init(value: String) {
        switch value {
        case "s":
            self = .seekFile
        case "m":
            self = .unUseMethods
        case "o":
            self = .unUseObject
        case "h2s":
            self = .h5ToSwift
        case "h":
            self = .help
        case "q":
            self = .quit
        default:
            self = .unknown
        }
    }
}

class Console {
    class func printUsage() {
        let exName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        print("Usage:")
        print("\(exName) -f filePath like /")
        print("\(exName) -h more infomation")
    }
    
    class func getInput() -> String {
        let keyboard = FileHandle.standardInput
        let inputData = keyboard.availableData
        let strData = String(data:inputData, encoding:String.Encoding.utf8)!
        return strData.trimmingCharacters(in: CharacterSet.newlines)
    }
    
    class func outPrint(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            print("\(message)")
        case .description:
            print("😈 \(message)")
        case .error:
            print("😱 \(message)\n", stderr)
        }
    }
    
    class func getOption(_ option: String) -> (option:OptionType, value:String) {
        return (OptionType(value:option),option)
    }
}
