//
//  HTMLLexer.swift
//  smck
//
//  Created by Daiming on 2017/4/15.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

enum HTMLToken: Equatable {
    case leftAngle, rightAngle, slash, equal, quote
    case identifier(String)
    case tagValue(String)
    case attributeValue(String)
    
    static func == (lhs:HTMLToken, rhs:HTMLToken) -> Bool {
        switch (lhs, rhs) {
        case (.leftAngle, .leftAngle),
             (.rightAngle, .rightAngle),
             (.slash, .slash),
             (.equal, .equal),
             (.quote, .quote)
             :
            return true
        case let (.identifier(i1), .identifier(i2)):
            return i1 == i2
        case let (.tagValue(tv1), .tagValue(tv2)):
            return tv1 == tv2
        case let (.attributeValue(av1), .attributeValue(av2)):
            return av1 == av2
        default:
            return false
        }
    }
}

enum HTMLParsingType {
    case char, identifier, tagValue, attributeValue
}

class HTMLLexer {
    let input: String
    var index: String.Index
    var psType: HTMLParsingType
    
    init(input: String) {
        self.input = input
        self.index = input.startIndex
        self.psType = .char
    }
    
    /*--------tool---------*/
    var currentChar: Character? {
        return index < input.endIndex ? input[index] : nil
    }
    func advanceIndex() {
        input.characters.formIndex(after: &index)
    }
    //遇到空格一个一个过
    func advanceSpace() {
        while let char = currentChar, char.isSpace {
            advanceIndex()
        }
    }
    //处理单个字符转Token
    func singleToToken() -> HTMLToken? {
        
        let singleToMapping:[Character:HTMLToken] = [
            "<" : .leftAngle,
            ">" : .rightAngle,
            "/" : .slash,
            "\"" : .quote,
            "'" : .quote,
            "=" : .equal
        ]
        if let tk = singleToMapping[currentChar!] {
            return tk
        } else {
            return nil
        }
    }
    
    /*-----------------*/
    func advanceToNextToken() -> HTMLToken? {
        //到达末尾
        guard currentChar != nil else {
            return nil
        }
        
        switch self.psType {
        case .char: return doChar()
        case .identifier: return doIdentifier()
        case .tagValue: return doTagValue()
        case .attributeValue: return doAttributeValue()
        }
        
    }
    
    /*----------词法分析出各个类型 Token---------*/
    func doChar() -> HTMLToken? {
        var str = ""
        var isLeftAngle = false
        while let char = currentChar, !isLeftAngle {
            if let tk = singleToToken() {
                if tk == .leftAngle {
                    psType = .identifier
                    isLeftAngle = true
                }
            }
            if isLeftAngle {
                str.characters.append(char)
            }
            advanceIndex()
        }
        return .tagValue(str)
    }
    func doIdentifier() -> HTMLToken {
        var str = ""
        var isToken = false
        while let char = currentChar, !isToken {
            if let tk = singleToToken() {
                if tk == .quote {
                    psType = .attributeValue
                }
                if tk == .rightAngle {
                    psType = .tagValue
                }
                if tk != .slash {
                    isToken = true
                }
            }
            if char.isSpace {
                isToken = true
            }
            if !char.isSpace && !isToken {
                str.characters.append(char)
            }
            advanceIndex()
        }
        
        return .identifier(str)
    }
    func doTagValue() -> HTMLToken {
        var str = ""
        var isLeftAngle = false
        while let char = currentChar, !isLeftAngle {
            if let tk = singleToToken() {
                if tk == .leftAngle {
                    psType = .identifier
                    isLeftAngle = true
                }
            }
            str.characters.append(char)
            advanceIndex()
        }
        return .tagValue(str)
    }
    func doAttributeValue() -> HTMLToken {
        var str = ""
        var isQuote = false
        while let char = currentChar, !isQuote {
            
            if let tk = singleToToken() {
                if tk == .quote {
                    psType = .identifier
                    isQuote = true
                }
            }
            if !isQuote {
                str.characters.append(char)
            }
            advanceIndex()
        }
        return .attributeValue(str)
    }
    
    func lex() -> [HTMLToken] {
        var tks = [HTMLToken]()
        while let tk = advanceToNextToken() {
            var tkStr = ""
            switch tk {
            case .identifier(let str):
                tkStr = str
            case .tagValue(let str):
                tkStr = str
            case .attributeValue(let str):
                tkStr = str
            default:
                tkStr = ""
            }
            if tkStr.characters.count > 0 {
                tks.append(tk)
            }
        }
        return tks
    }
}






