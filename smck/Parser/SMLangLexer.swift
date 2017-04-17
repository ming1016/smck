//
//  HtmlLexer.swift
//  smck
//
//  Created by Daiming on 2017/4/11.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

enum SMLangBinaryOperator: UnicodeScalar {
    case plus = "+", minus = "-", times = "*", divide = "/", mod = "%", equals = "="
}

enum SMLangToken: Equatable {
    case leftParen, rightParen, def, extern, comma, semicolon, `if`, then, `else`
    case identifier(String)
    case number(Double)
    case `operator`(SMLangBinaryOperator)
    
    static func == (lhs:SMLangToken, rhs:SMLangToken) -> Bool {
        switch (lhs, rhs) {
        case (.leftParen, .leftParen),
             (.rightParen, .rightParen),
             (.def, .def),
             (.extern, .extern),
             (.comma, .comma),
             (.semicolon, .semicolon),
             (.if, .if),
             (.then, .then),
             (.else, .else)
             :
            return true
        case let (.identifier(id1), .identifier(id2)):
            return id1 == id2
        case let (.number(n1), .number(n2)):
            return n1 == n2
        case let (.operator(op1), .operator(op2)):
            return op1 == op2
        default:
            return false
        }
    }
}

class SMLangLexer {
    let input: String
    var index: String.Index
    
    init(input: String) {
        self.input = input
        self.index = input.startIndex
    }
    
    var currentChar: Character? {
        return index < input.endIndex ? input[index] : nil
    }
    
    func advanceIndex() {
        input.characters.formIndex(after: &index)
    }
    
    func readIdentifierOrNumber() -> String {
        var str = ""
        while let char = currentChar, char.isAlphanumeric || char == "." {
            str.characters.append(char)
            advanceIndex()
        }
        return str
    }
    
    func advanceToNextToken() -> SMLangToken? {
        //跳过所有的空格
        while let char = currentChar, char.isSpace{
            advanceIndex()
        }
        //到达输入文字的最后
        guard let char = currentChar else {
            return nil
        }
        
        //处理单个字符，比如comma，leftParen等
        let singleToMapping: [Character: SMLangToken] = [
            "," : .comma,
            "(" : .leftParen,
            ")" : .rightParen,
            ";" : .semicolon,
            "+" : .operator(.plus),
            "-" : .operator(.minus),
            "*" : .operator(.times),
            "/" : .operator(.divide),
            "%" : .operator(.mod),
            "=" : .operator(.equals)
        ]
        if let tk = singleToMapping[char] {
            advanceIndex()
            return tk
        }
        
        //非单个字符的处理
        if char.isAlphanumeric {
            let str = readIdentifierOrNumber()
            if let db = Double(str) {
                return .number(db)
            }
            
            //一些定义的关键字
            switch str {
            case "def":
                return .def
            case "extern":
                return .extern
            case "if":
                return .if
            case "then":
                return .then
            case "else":
                return .else
            default:
                return .identifier(str)
            }
        }
        return nil
    }
    
    func lex() -> [SMLangToken] {
        var tks = [SMLangToken]()
        while let tk = advanceToNextToken() {
            tks.append(tk)
        }
        return tks
    }
}



