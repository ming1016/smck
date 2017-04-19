
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
        case .h5ToSwift:
            doH2S(path: argValue)
        case .help:
            Console.printUsage()
        case .unknown, .quit:
            print("Unknown option\(value)")
            Console.printUsage()
        }
    }
    
    //h5 to swift
    func doH2S(path:String) {
        let pathUrl = URL(string: "file://".appending(path))
        let content = try! String(contentsOf: pathUrl!, encoding: String.Encoding.utf8)
//        print("\(content)")
        
        let tks = H5Lexer(input: content).lex()
        let file = try! H5Parser(tokens: tks).parseFile()
        
        print("\(file)")
        
//        let tks = HTMLLexer(input: "<html><body background=\"#dkdkdds\" url=\"http://sldkfjadskfj.comds.ccc/sdkfjsd/dskfja.html\">kkkk<a><img scr=\"http://ww.ss.c/ss.jpg\"/></a>safd<div>safkasdfj</div><p><ll>safsdaf</ll>3333</p></body></html>").lex()
//        let tks = HTMLLexer(input: "<p>111</p><a>222</a>").lex()
//        let file = try! HTMLParser(tokens: tks).parseFile()
//        print("\(file)")

//SMLang
//        let tks = SMLangLexer(input: "extern sqrt(n);\ndef foo(n) (n * sqrt(n * 200) + 57 * n % 2);").lex()
//        let file = try! SMLangParser(tokens: tks).parseFile()
//        print("\(file)")
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
