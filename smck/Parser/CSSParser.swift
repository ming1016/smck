//
//  CSSParser.swift
//  smck
//
//  Created by DaiMing on 2017/4/19.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

enum CSSParseError: Swift.Error {
    case unexpectedToken(String)
    case unexpectedEOF
}

class CSSParser {
    let tokens: [String]
    var index = 0
    
    init(tokens:[String]) {
        self.tokens = tokens
    }
    func parseFile() throws -> CSSFile {
        let file = CSSFile()
        while currentToken != nil {
            let selector = try parseSelector()
            file.addSelector(selector)
        }
        return file
    }
    
    func parseSelector() throws -> CSSSelector {
        guard currentToken != nil else {
            throw CSSParseError.unexpectedEOF
        }
        
        var psStep = 0 //0：初始，1：开始处理属性名，2：开始处理属性值，3结束一个selector
        
        var selectorName = ""
        var propertys = [String: String]()
        var currentAttributeName = ""
        
        while let tk = currentToken {
            
            if psStep == 2 {
                var vr = ""
                while let tok = currentToken {
                    if tok == ";" {
                        propertys[currentAttributeName] = vr
                        psStep = 1
                        consumeToken()
                        break
                    } else {
                        vr.append(tok)
                    }
                    consumeToken()
                }
                continue
            }
            
            if psStep == 1 {
                if tk == "}" {
                    consumeToken()
                    break
                }
                while let tok = currentToken {
                    if tok == ":" {
                        psStep = 2
                        consumeToken()
                        break
                    } else {
                        currentAttributeName.append(tok)
                    }
                    consumeToken()
                }
                continue
            }
            
            if psStep == 0 {
                if tk == "{" {
                    psStep = 1
                    consumeToken()
                    continue
                }
                selectorName.append(tk)
                consumeToken()
                continue
            }
        }
        
        return CSSSelector(selectorName: selectorName, propertys: propertys)
    }
    
    /*------------------*/
    var currentToken: String? {
        return index < tokens.count ? tokens[index] : nil
    }
    func consumeToken(n: Int = 1) {
        index += n
    }
    
}
