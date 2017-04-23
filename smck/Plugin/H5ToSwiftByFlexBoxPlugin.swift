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
        "stretch":"stretch",
        "baseline":"base",
        //position
        "relative":"relative",
        "absolute":"absolute",
        //flex-wrap
        "no-wrap":"noWrap",
        "wrap":"wrap",
        "wrap-reverse":"wrapReverse",
        //overflow
        "visible":"visible",
        "hidden":"hidden",
        "scroll":"scroll",
        //display
        "flex":"flex",
        "none":"none"
    ]
    //propertyMap
    let ptKeyMap = [
        "background-color":"backgroundColor"
    ]
    let ptValueMap = [
        "black":".black",
        "red":".red",
        "white":".white"
    ]
    
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
        guard let htmlSubTags = self.H5file.tags.first?.subs else {
            return
        }
        
        var swiftStr = ""
        swiftStr.append("import UIKit\n")
        swiftStr.append("import YogaKit\n")
        swiftStr.append("\n")
        
        var className = ""
        
        var didLoadStr = ""
        for tag in htmlSubTags {
            if tag.name == "head" {
                for subTag in tag.subs {
                    if subTag.name == "title" {
                        className = (subTag.subs.first?.value)!
                    }
                }
            } else if tag.name == "body" {
                didLoadStr.append("let body = self.view!\n")
                didLoadStr.append(viewTagToSwift(tag: tag, superTag: self.H5file.tags.first!, superSName: "body"))
            }
        }
        
        swiftStr.append("final class \(className): UIViewController {\n")
        swiftStr.append(propertys)
        swiftStr.append("\noverride func viewDidLoad() {\n")
        swiftStr.append(didLoadStr)
        swiftStr.append("body.yoga.applyLayout(preservingOrigin: false)\n")
        swiftStr.append("}\n")
        swiftStr.append("}\n")
        
        do {
            try swiftStr.write(to: URL(string: "file://\(path).swift")!, atomically: false, encoding: String.Encoding.utf8)
        } catch {
            
        }
        
    }
    
    func viewTagToSwift(tag:H5Tag, superTag:H5Tag, superSName:String) -> String {
        index += 1
        var reStr = ""
        var sName = ""
        if tag.name == "body" {
            sName = "body"
        } else {
            sName = tag.name + "\(index)"
        }
        
        
        //初始
        if (tag.attributes["id"] != nil) {
            sName = tag.attributes["id"]!
            propertys.append("private let \(sName) : UIView = UIView(frame: .zero)\n")
        } else if tag.name != "body" {
            reStr.append("let \(sName) = UIView(frame: .zero)\n")
        }
        
        
        var rePyStr = "" //属性
        var reLyStr = "" //layout
        let cssKeys = self.cssFile.selectors.keys
        //
        if cssKeys.contains(tag.name) {
            let pt = self.cssFile.selectors[tag.name]?.propertys
            reLyStr.append(cssLayoutToSwift(csspt: pt!, sName: sName))
            rePyStr.append(cssPropertyToSwift(csspt: pt!, sName: sName))
        }
        
        if tag.attributes.keys.contains("id") {
            if cssKeys.contains("#\(tag.attributes["id"]!)") {
                let idPt = self.cssFile.selectors["#\(tag.attributes["id"]!)"]?.propertys
                reLyStr.append(cssLayoutToSwift(csspt: idPt!, sName: sName))
                rePyStr.append(cssPropertyToSwift(csspt: idPt!, sName: sName))
            }
        }
        
        if tag.attributes.keys.contains("class") {
            if cssKeys.contains(".\(tag.attributes["class"]!)") {
                let classPt = self.cssFile.selectors[".\(tag.attributes["class"]!)"]?.propertys
                reLyStr.append(cssLayoutToSwift(csspt: classPt!, sName: sName))
                rePyStr.append(cssPropertyToSwift(csspt: classPt!, sName: sName))
            }
        }
        
        //组装的地方
        reStr.append(rePyStr)
        reStr.append("\(sName).configureLayout { (layout) in\n")
        reStr.append("layout.isEnabled = true\n")
        reStr.append(reLyStr)
        reStr.append("}\n")
        if tag.name != "body" {
            reStr.append("\(superSName).addSubview(\(sName))\n\n")
        } else {
            reStr.append("\n")
        }
        
        if tag.subs.count > 0 {
            for subTag in tag.subs {
                if subTag.name.characters.count > 0 {
                    reStr.append(viewTagToSwift(tag: subTag, superTag: tag, superSName: sName))
                }
            }
        }
        
        return reStr
    }
    
    func cssPropertyToSwift(csspt:[String:String], sName:String) -> String {
        var reStr = ""
        for (key, value) in csspt {
            if ptKeyMap.keys.contains(key) {
                reStr.append("\(sName).\(ptKeyMap[key]!) = \(ptValueMap[value]!)\n")
            }
        }
        return reStr
    }
    
    func cssLayoutToSwift(csspt:[String:String], sName:String) -> String {
        var reStr = ""
        for (key, value) in (csspt) {
            if lyFloatKeyMap.keys.contains(key) {
                reStr.append("layout.\(lyFloatKeyMap[key]!) = \(cutNumberMark(str: value))\n")
            }
            if lyEnumKeyMap.keys.contains(key) {
                if key == "display" && value == "flex" {
                    //默认都加这里就不多添加了
                } else {
                    reStr.append("layout.\(lyEnumKeyMap[key]!) = .\(lyEnumValueMap[value]!)\n")
                }
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
