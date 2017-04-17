//
//  HTMLParser.swift
//  smck
//
//  Created by DaiMing on 2017/4/16.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

enum HTMLParseError: Swift.Error {
    case unexpectedToken(HTMLToken)
    case unexpectedEOF
}

class HTMLParser {
    let tokens: [HTMLToken]
    var index = 0
    
    init(tokens:[HTMLToken]) {
        self.tokens = tokens
    }
    
    /*-----------------*/
    func parseFile() throws -> HTMLFile {
        let file = HTMLFile()
        while currentToken != nil {
            let tag = try parseTag()
            file.addTag(tag)
            consumeToken()
        }
        return file
    }
    
    /*--------Parse--------*/
    func parseTag() throws -> HTMLTag {
        guard currentToken != nil else {
            throw HTMLParseError.unexpectedEOF
        }
        var tagName = ""
        var tagSubs = [HTMLTag]()
        var attribuitesDic = [String:String]()
        var attributeName = ""
        var tagValue = ""
        var isTagEnd = false
        var isTagName = false
        var isTagNameDone = false
        
        while let tk = currentToken, !isTagEnd {

            switch tk {
            case .identifier(let idStr):
                
                if idStr.contains("/") {
                    isTagEnd = true
                } else if !isTagNameDone {
                    tagName = idStr
                    isTagNameDone = true
                } else {
                    attributeName = idStr
                }
                
            case .tagValue(let vlStr):
                if vlStr == "<" || vlStr.hasSuffix("<") {
                    tagValue = vlStr.replacingOccurrences(of: "<", with: "")
                    if isTagName {
                        
                        tagSubs.append(try parseTag())
                    } else {
                        isTagName = true
                    }
                }
                
            case .attributeValue(let avStr):
                attribuitesDic[attributeName] = avStr
                attributeName = ""
            default:
                break
            }
            
            consumeToken()
            
        }
        
        return HTMLTag(name: tagName, subs: tagSubs, attributes: attribuitesDic, value: tagValue)
    }
//    func parseIdentifier() throws -> String {
//        guard let tk = currentToken else {
//            throw HTMLParseError.unexpectedEOF
//        }
//        guard case .identifier(let tagName) = tk else {
//            throw HTMLParseError.unexpectedToken(tk)
//        }
//        consumeToken()
//        return tagName
//    }

    
    /*-----------------------*/
    var currentToken: HTMLToken? {
        return index < tokens.count ? tokens[index] : nil
    }
    
    func consumeToken(n: Int = 1) {
        index += n
    }
    
    func consume(_ token: HTMLToken) throws {
        guard let tk = currentToken else {
            throw HTMLParseError.unexpectedEOF
        }
        guard token == tk else {
            throw HTMLParseError.unexpectedToken(token)
        }
        consumeToken()
    }
    
}



