//
//  Gram.swift
//  SMCheckProjectCL
//
//  Created by daiming on 2017/3/6.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

class Checker {
    //交互
    func interactiveModel() {
        Console.outPrint("smck for Project Analyse")
        var shouldQuit = false
        while !shouldQuit {
            Console.outPrint("Type 'f' to folder path input or 'q' for quit")
            let (option, value) = Console.getOption(Console.getInput())
            switch option {
            case .seekFile:
                Console.outPrint("Type folder path:")
                let filePath = Console.getInput()
                doF(path: filePath)
                Console.outPrint("File path is \(filePath)")
            case .help:
                Console.printUsage()
            case .quit:
                shouldQuit = true
            default:
                Console.outPrint("Unknown option \(value)", to: .error)
            }
            
        }
    }
    
    //静态
    func staticMode() {
        let argument = CommandLine.arguments[1]
        let (option, value) = Console.getOption(argument.substring(from: argument.characters.index(argument.startIndex, offsetBy: 1)))
        let argValue = CommandLine.arguments[2]
        
        switch option {
        case .seekFile:
            doF(path: argValue)
        case .unUseMethods:
            doM(path: argValue)
        case .unUseObject:
            doO(path: argValue)
        case .help:
            Console.printUsage()
        case .unknown, .quit:
            print("Unknown option\(value)")
            Console.printUsage()
        }
    }
    //无用类
    func doO(path:String) {
        guard path.characters.count > 0 else {
            return
        }
        UnUseObjectPlugin().plug(ob: ParsingEntire.parsing(path: path))
    }
    
    //无用函数
    func doM(path:String) {
        guard path.characters.count > 0 else {
            return
        }
        UnUseMethodPlugin().plug(ob: ParsingEntire.parsing(path: path))
    }
    
    //列出文件下
    func doF(path:String) {
        guard path.characters.count > 0 else {
            return
        }
        let files = SeekFolderFiles.seekWith(path)
        for aFile in files {
            Console.outPrint(aFile)
        }
        Console.outPrint("\(path)")
    }
    
}
