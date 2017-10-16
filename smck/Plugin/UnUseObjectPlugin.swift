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
    var whiteList = ["AppDelegate","DCHomeDriverDataSource","DCSocialModule","DCGuideViewBubble","DCHomePassengerDataSource","DCHomeOperationPopView","DCActivityGuideStartUpWelcome"] //定义白名单，因为有些是在 C 方法里用了，但是目前还没有处理 c 的方法
    var whiteSuperList = ["JSONModel","TRBaseModel","DCBaseModel","UIViewController","DCBaseViewController","DCBaseComponent","UITableViewCell"] //白名单父类
    
    func plug(ob:Observable<Any>) {
        _ = ob.subscribe(onNext: { result in
            if result is Dictionary<String, Any> {
                let dic = result as! Dictionary<String, Any>
                if dic["currentParsingFileDes"] is String {
                    Console.outPrint("\(String(describing: dic["currentParsingFileDes"]))")
                }
                if dic["firstRoundAFile"] is File {
                    let aFile = dic["firstRoundAFile"] as! File
//                    Console.outPrint("\(aFile.name)")
                    if aFile.name.hasSuffix("Request.h") {
//                        Console.outPrint("\(aFile.path)")
                    }
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
                        if key == "DCOrderlistMyTripSegmentViewController" {
                            
                        }
                        let obj = self.finalSuperObj(obj: value)
                        //supername。除了 supername 外还要考虑 category 自己 name 可能就是系统的情况
                        if self.whiteSuperList.contains(obj.superName) || self.whiteSuperList.contains(obj.name) || key.hasSuffix("Unit") || key.hasSuffix("Com") || key.hasSuffix("Cell") {
                            
                        } else {
                            Console.outPrint("\(key)")
                            allUnUsedObjects[key] = value
                        }
                        
                    }
                    continue
                } // end guard
            } // end for
        }) // end subscribe
    } // end func
    
    //递归查找最终父类
    func finalSuperObj(obj:Object) -> Object {
        guard let sObj = self.allObjects[obj.superName] else {
            return obj
        }
        if self.whiteSuperList.contains(sObj.name) {
            return sObj
        }
        return self.finalSuperObj(obj: sObj)
    }
}
