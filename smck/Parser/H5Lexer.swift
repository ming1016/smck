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
    var cssFile: CSSFile
    
    init(input: String) {
        //清理
        var str = input.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let annotationBlockPattern = "/\\*[\\s\\S]*?\\*/" //匹配/*...*/这样的注释
        let annotationLinePattern = "//.*?\\n" //匹配//这样的注释
        
        let regexBlock = try! NSRegularExpression(pattern: annotationBlockPattern, options: NSRegularExpression.Options(rawValue:0))
        let regexLine = try! NSRegularExpression(pattern: annotationLinePattern, options: NSRegularExpression.Options(rawValue:0))
        var anStr = ""
        anStr = regexLine.stringByReplacingMatches(in: str, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSMakeRange(0, str.characters.count), withTemplate: Sb.space)
        anStr = regexBlock.stringByReplacingMatches(in: anStr, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSMakeRange(0, anStr.characters.count), withTemplate: Sb.space)
        
        
        str = anStr.replacingOccurrences(of: "\n", with: "")
        str = str.replacingOccurrences(of: "\t", with: "")
        
        var newStr = ""
        /*-----------CSS----------*/
        //去掉头部和注释
        let annotationPattern = "<!.*?>" //匹配<!>这样的注释
        let regex = try! NSRegularExpression(pattern: annotationPattern, options: NSRegularExpression.Options(rawValue:0))
        
        newStr = regex.stringByReplacingMatches(in: str, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSMakeRange(0, str.characters.count), withTemplate: H5Sb.space)
        
        //提取<Style>标签
        let cssPattern = "<style>(.*?)</style>"
        let cssRegex = try! NSRegularExpression(pattern: cssPattern, options: NSRegularExpression.Options(rawValue:0))
        let matches = cssRegex.matches(in: newStr, options: [], range: NSMakeRange(0,NSString(string: newStr).length))
        var cssSelecorsStr = ""
        for re in matches {
            cssSelecorsStr.append(NSString(string: newStr).substring(with: re.rangeAt(1)))
            //print("\(cssSelecorsStr)")
        }
        
        //提取完再将其替换成空
        newStr = cssRegex.stringByReplacingMatches(in: newStr, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSMakeRange(0, newStr.characters.count), withTemplate: H5Sb.space)
        //print("\(newStr)")
        
        //将 css 的 selector 添加到 cssSelectors 里做好映射
        let cssTks = CSSLexer(input: cssSelecorsStr).lex()
        //print("\(cssTks)")
        
        self.cssFile = try! CSSParser(tokens: cssTks).parseFile()
        
        /*------------JS------------*/
        //提取<script type="text/javascript"></script>里的内容
        let jsPattern = "<script.*?>(.*?)</script>"
        let jsRegex = try! NSRegularExpression(pattern: jsPattern, options: NSRegularExpression.Options(rawValue:0))
        let jsMatches = jsRegex.matches(in: newStr, options: [], range: NSMakeRange(0,NSString(string: newStr).length))
        var jsStr = ""
        for jsRe in jsMatches {
            jsStr.append(NSString(string: newStr).substring(with: jsRe.rangeAt(1)))
        }
        //替换空
        newStr = jsRegex.stringByReplacingMatches(in: newStr, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSMakeRange(0, newStr.characters.count), withTemplate: " ")
        
        let jsTks = JSLexer(input: jsStr).lex()
        print("\(jsTks)")
        
        self.input = newStr
        self.index = newStr.startIndex
    }
    
    public func lex() -> [String] {
        
        var tks = [String]()
        while let tk = advanceToNextToken() {
            if tk == H5Sb.space || tk == H5Sb.empty {
            } else {
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
        let keyMap = [H5Sb.agBktL, H5Sb.agBktR, H5Sb.divide, H5Sb.quotM, H5Sb.sQuot, H5Sb.equal, H5Sb.space]
        
        let currentStr = currentChar?.description
        
        var str = ""
        var quite = false
    
        
        if keyMap.contains(currentStr!) {
            advanceIndex()
            return currentStr!
        } else {
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
    //跳过空格
//    func advanceSpace() {
//        while let char = currentChar, char.isSpace {
//            advanceIndex()
//        }
//    }
    
}
