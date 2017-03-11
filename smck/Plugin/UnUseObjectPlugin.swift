//
//  UnUseObjectPlugin.swift
//  SMCheckProjectCL
//
//  Created by didi on 2017/3/10.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

class UnUseObjectPlugin {
    var allObjects = [String:Object]()
    var allUsedObjects = [String:Object]()
    var whiteList = ["AppDelegate"] //定义白名单
    
    func plug(ob:Observable<Any>) {
        _ = ob.subscribe(onNext: { result in
            if result is Dictionary<String, Any> {
                let dic = result as! Dictionary<String, Any>
                if dic.keys.contains("currentParsingFileDes") {
                    Console.outPrint("\(dic["currentParsingFileDes"])")
                }
                if dic.keys.contains("firstRoundAFile") {
                    let aFile = dic["firstRoundAFile"] as! File
                    Console.outPrint("\(aFile.name)")
                }
                if dic["allObjects"] is [String:Object] {
                    self.allObjects = dic["allObjects"] as! [String:Object]
                }
                if dic["allUsedObjects"] is [String:Object] {
                    self.allUsedObjects = dic["allUsedObjects"] as! [String:Object]
                }
            }
            
        }, onCompleted: {
            Console.outPrint("无用类", to: .description)
            //遍历对比出无用的类
            var allUnUsedObjects = [String:Object]()
            for (key, value) in self.allObjects {
                guard let _ = self.allUsedObjects[key] else {
                    if value.category.characters.count > 0 || self.whiteList.contains(value.name) {
                    } else {
                        allUnUsedObjects[key] = value
                        Console.outPrint("\(key)")
                    }
                    continue
                }
            }
//            Console.outPrint("\(allUnUsedObjects)")
        })
    }
}
