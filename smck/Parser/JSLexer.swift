//
//  JSLexer.swift
//  smck
//
//  Created by DaiMing on 2017/5/2.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

class JSLexer {
    let input: String
    var index: String.Index
    
    init(input: String) {
        //
        self.input = input
        self.index = input.startIndex
    }
    
    public func lex() -> [String] {
        var tks = [String]()
        while let tk = advanceToNextToken() {
            if tk == " " || tk == "" {
            } else {
                tks.append(tk)
            }
        }
        return tks
    }
    
    func advanceToNextToken() -> String? {
        //末尾检测
        guard currentChar != nil else {
            return nil
        }
        let keyMap = [JSSb.rBktL,JSSb.rBktR,JSSb.bktL,JSSb.bktR,JSSb.braceL,JSSb.braceR,JSSb.comma,JSSb.colon,JSSb.dot,JSSb.add,JSSb.minus,JSSb.tilde,JSSb.excMk,JSSb.asterisk,JSSb.percent,JSSb.agBktL,JSSb.equal,JSSb.and,JSSb.upArrow,JSSb.pipe,JSSb.qM,JSSb.semicolon," "]
        let currentStr = currentChar?.description
        var str = ""
        var quite = false
        
        if keyMap.contains(currentStr!) {
            advanceIndex()
            return currentStr!
        } else {
            while let char = currentChar, !quite {
                let charStr = char.description
                if keyMap.contains(charStr) {
                    quite = true
                } else {
                    str.characters.append(char)
                    advanceIndex()
                }
            }
            return str
        }
    }
    
    /*-----------*/
    var currentChar: Character? {
        return index < input.endIndex ? input[index] : nil
    }
    func advanceIndex() {
        input.characters.formIndex(after: &index)
    }
}
