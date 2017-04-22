//
//  CSSLexer.swift
//  smck
//
//  Created by DaiMing on 2017/4/19.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

class CSSLexer {
    let input: String
    var index: String.Index
    
    init(input:String) {
        var newStr = ""
        let annotationBlockPattern = "/\\*[\\s\\S]*?\\*/" //匹配/*...*/这样的注释
        let regexBlock = try! NSRegularExpression(pattern: annotationBlockPattern, options: NSRegularExpression.Options(rawValue:0))
        newStr = regexBlock.stringByReplacingMatches(in: input, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSMakeRange(0, input.characters.count), withTemplate: Sb.space)
        self.input = newStr
        self.index = newStr.startIndex
    }
    
    public func lex() -> [String] {
        var tks = [String]()
        while let tk = advanceToNextToken() {
            if tk == CSSSb.space || tk == CSSSb.empty {
            } else {
                tks.append(tk)
            }
        }
        return tks
    }
    
    func advanceToNextToken() -> String? {
        //检测尾
        guard currentChar != nil else {
            return nil
        }
        let keyMap = [CSSSb.braceL, CSSSb.braceR, CSSSb.pSign, CSSSb.dot, CSSSb.semicolon, CSSSb.colon, CSSSb.rBktL, CSSSb.rBktR, CSSSb.space]
        let currentStr = currentChar?.description
        var str = ""
        if keyMap.contains(currentStr!) {
            advanceIndex()
            return currentStr
        } else {
            while let charStr = currentChar?.description, !keyMap.contains(charStr) {
                str.append(charStr)
                advanceIndex()
            }
            return str
        }
        
        
    }
    
    /*---------------*/
    var currentChar: Character? {
        return index < input.endIndex ? input[index] : nil
    }
    func advanceIndex() {
        input.characters.formIndex(after: &index)
    }
    func advanceSpace() {
        while let char = currentChar, char.isSpace {
            advanceIndex()
        }
    }
}
