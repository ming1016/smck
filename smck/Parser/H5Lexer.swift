//
//  H5Lexer.swift
//  smck
//
//  Created by DaiMing on 2017/4/17.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

struct H5Token {
    var str:String
    var type:H5TokenType
}

enum H5TokenType {
    case none, key, tagName, tagValue, attributeName, attributeValue
}

class H5Lexer {
    let input: String
    var index: String.Index
    var psTName = false
    
    init(input: String) {
        self.input = input
        self.index = input.startIndex
    }
    
    func lex() -> [H5Token] {
        var tks = [H5Token]()
        while let tk = advanceToNextToken() {
            tks.append(tk)
        }
        return tks
    }
    
    func advanceToNextToken() -> H5Token? {
        //检测末尾
        guard currentChar != nil else {
            return nil
        }
        let keyMap = ["<",">","/","\"","'","="]
        var tk = H5Token(str: "", type: .none)
        
        let currentStr = String(describing: currentChar)
        
        if keyMap.contains(currentStr) {
            tk = H5Token(str: currentStr, type: .key)
            
            advanceIndex()
            return tk
        }
        
        return tk
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
