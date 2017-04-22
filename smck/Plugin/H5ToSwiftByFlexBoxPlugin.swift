//
//  H5ToSwiftByFlexBoxPlugin.swift
//  smck
//
//  Created by DaiMing on 2017/4/20.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

class H5ToSwiftByFlexBoxPlugin {
    let path: String
    let pathUrl: URL
    var index = 0
    var propertys = ""
    let H5file: H5File
    var cssFile: CSSFile
    
    init(path:String) {
        self.path = path
        self.pathUrl = URL(string: "file://".appending(path))!
        let content = try! String(contentsOf: pathUrl, encoding: String.Encoding.utf8)
        let h5Lexer = H5Lexer(input: content)
        let tks = h5Lexer.lex()
        self.H5file = try! H5Parser(tokens: tks).parseFile()
        self.cssFile = h5Lexer.cssFile
    }
    
    func doSwitch() {
        
        
        var swiftStr = ""
        swiftStr.append("import UIKit\n")
        swiftStr.append("import YogaKit\n")
        swiftStr.append("\n")
        
        var className = ""
        
        var didLoadStr = ""
        for tag in self.H5file.tags {
            if tag.name == "title" {
                className = tag.value
            } else if tag.name == "body" {
                didLoadStr.append("let body = self.view!")
                didLoadStr.append(viewTagToSwift(tag: tag))
            } else {
                didLoadStr.append(viewTagToSwift(tag: tag))
            }
        }
        
        swiftStr.append("final class \(className): UIViewController {\n")
        swiftStr.append(propertys)
        swiftStr.append("override func viewDidLoad() {\n")
        swiftStr.append(didLoadStr)
        swiftStr.append("}")
    }
    
    func viewTagToSwift(tag:H5Tag) -> String {
        index += 1
        var reStr = ""
        var sName = tag.name + "\(index)"
        
        //初始
        if (tag.attributes["id"] != nil) {
            sName = tag.attributes["id"]! + "\(index)"
            propertys.append("private let \(sName) : UIView = UIView(frame: .zero)\n")
        } else if tag.name != "body" {
            reStr.append("let \(sName) = UIView(frame: .zero)")
        }
        
        
        var rePyStr = "" //属性
        var reLyStr = "" //layout
        let cssKeys = self.cssFile.selectors.keys
        if cssKeys.contains(tag.name) {
            let lyFloatKeyMap = [
                "width":"width",
                "height":"height",
                "margin":"margin",
                "padding":"padding",
                "flex-grow":"flexGrow",
                "flex-shrink":"flexShrink",
                "flex-basis":"flexBasis"
            ]
            let lyEnumKeyMap = [
                "flex-direction":"flexDirection",
                "justify-content":"justifyContent",
                "align-content":"alignContent",
                "align-items":"alignItems",
                "align-self":"alignSelf",
                "position":"position",
                "flex-wrap":"flexWrap",
                "overflow":"overflow",
                "display":"display"
            ]
            let lyEnumValueMap = [
                //flex-direction
                "column":"column",
                "columnReverse":"columnReverse",
                "row":"row",
                "rowReverse":"rowReverse",
                //justify-content
                "flex-start":"flexStart",
                "center":"center",
                "flex-end":"flexEnd",
                "space-between":"spaceBetween",
                "space-around":"spaceAround",
                //align-content,align-items,align-self
                "auto":"auto",
                "flex-start":"flexStart",
                "center":"center",
                "flex-end":"flexEnd",
                "stretch":"stretch",
                "baseline":"base",
                "space-between":"spaceBetween",
                "space-around":"spaceAround",
                //position
                "relative":"relative",
                "absolute":"absolute",
                //flex-wrap
                "no-wrap":"noWrap",
                "wrap":"wrap",
                "wrap-reverse":"wrapReverse",
                //overflow
                "visible":"visible",
                "hidden":"hidden"
            ]
            
            for (key,value) in (self.cssFile.selectors[tag.name]?.propertys)! {
                if lyFloatKeyMap.keys.contains(key) {
                    reLyStr.append("layout.\(lyFloatKeyMap[key]) = \(cutNumberMark(str: value))")
                }
                
                
            }
        }
        
        
        
        if tag.subs.count > 0 {
            for subTag in tag.subs {
                reStr.append(viewTagToSwift(tag: subTag))
            }
        }
        
        return reStr
    }
    
    //把数字后面的 pt px 去掉
    func cutNumberMark(str:String) -> String {
        var re = str.replacingOccurrences(of: "pt", with: "")
        re = re.replacingOccurrences(of: "px", with: "")
        return re
    }
    
    
}
