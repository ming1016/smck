//
//  H5Parser.swift
//  smck
//
//  Created by DaiMing on 2017/4/17.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

enum H5ParseError: Swift.Error {
    case unexpectedToken(String)
    case unexpectedEOF
}

class H5Parser {
    let tokens: [String]
    var index = 0
    
    init(tokens:[String]) {
        self.tokens = tokens
    }
    
    func parseFile() throws -> H5File {
        let file = H5File()
        while currentToken != nil {
            let tag = try parseTag()
            file.addTag(tag)
//            consumeToken()
        }
        return file
    }
    
    func parseTag() throws -> H5Tag {
        guard currentToken != nil else {
            throw H5ParseError.unexpectedEOF
        }
        
        var name = ""
        var subs = [H5Tag]()
        var attributes = [String:String]()
        var value = ""
        
        var currentAttribuiteName = ""
        
        var psStep = 0 //0：初始，1：标签名，2：标签名取完，3：获取属性值，4：斜线完结，5：标签完结，6：整个标签完成

        while let tk = currentToken {
            if psStep == 6 {
                break
            }
            
            if psStep == 5 {
                if tk == "<" {
                    let nextIndex = index + 1
                    let nextTk = nextIndex < tokens.count ? tokens[nextIndex] : nil
                    if nextTk == "/" {
                        while let tok = currentToken {
                            if tok == ">" {
                                consumeToken()
                                break
                            }
                            consumeToken()
                        }
                        break
                    }
                    
                }
                subs.append(try parseTag())
            }
            
            if psStep == 4 {
                if tk == ">" {
                    psStep = 6
                    consumeToken()
                    continue
                }
            }
            
            if psStep == 3 {
                if tk == "\"" || tk == "'" {
                    consumeToken()
                    var str = ""
                    while let tok = currentToken {
                        if tok == "\"" {
                            consumeToken()
                            break
                        }
                        consumeToken()
                        str.append(tok)
                    }
                    attributes[currentAttribuiteName] = str
                    psStep = 2
                    continue
                }
            }
            
            if psStep == 2 {
                if tk == "=" {
                    psStep = 3
                    consumeToken()
                    continue
                }
                if tk == "/" {
                    psStep = 4
                    consumeToken()
                    continue
                }
                if tk == ">" {
                    psStep = 5
                    consumeToken()
                    continue
                }
                currentAttribuiteName = tk
                consumeToken()
                continue
            }
            
            if psStep == 1 {
                name = tk
                psStep = 2
                consumeToken()
                continue
            }
            
            if psStep == 0 {
                //
                if tk == "<" {
                    psStep = 1
                    consumeToken()
                    continue
                } else {
                    consumeToken()
                    value = tk
                    break
                }
                
            }
            
        }
        
        return H5Tag(name: name, subs: subs, attributes: attributes, value: value)
    }
    
    
    /*------------------*/
    var currentToken: String? {
        return index < tokens.count ? tokens[index] : nil
    }
    func consumeToken(n: Int = 1) {
        index += n
    }
    
}
