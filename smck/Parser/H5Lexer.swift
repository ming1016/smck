//
//  H5Lexer.swift
//  smck
//
//  Created by DaiMing on 2017/4/17.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation


class H5Lexer {
    let input: String
    var index: String.Index
    var psTName = false
    var psTNameEnd = false
    
    init(input: String) {
        self.input = input
        self.index = input.startIndex
    }
    
    public func lex() -> [String] {
        var tks = [String]()
        while let tk = advanceToNextToken() {
            if tk != " " {
                tks.append(tk)
            }
        }
        return tks
    }
    
    func advanceToNextToken() -> String? {
        //检测末尾
        guard currentChar != nil else {
            return nil
        }
        let keyMap = ["<",">","/","\"","'","="," "]
        
        let currentStr = currentChar?.description
        
        var str = ""
        var quite = false
    
        
        if keyMap.contains(currentStr!) {
            advanceIndex()
            return currentStr!
        } else {
            advanceSpace()
            while let char = currentChar, !quite{
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
