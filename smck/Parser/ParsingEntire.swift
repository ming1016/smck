//
//  ParsingEntire.swift
//  SMCheckProjectCL
//
//  Created by daiming on 2017/3/8.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

class ParsingEntire {
    
    class func parsing(path: String) -> Observable<Any> {
        /*
         onNext 的 Dic 定义
         "filePaths" : [String]               //全部文件路径
         "currentParsingFileDes" : String     //当前文件信息
         "firstRoundAFile" : File             //第一轮获取的单个文件，可以用来打印一些基本信息用，因为IO这个过程会有些慢。
         
         "methodsUsed" : [String]             //用过的方法集合
         "methodsMFile" : [String]            //m文件pnameId集合
         "methodsDefinedInHFile" : [Method]   //h文件定义的方法集合
         "methodsDefinedInMFile" : [Method]   //m文件定义的方法集合
         
         "allObjects" : [String:Object]       //全部类
         "allUsedObjects" : [String:Object]   //使用过的类
         
         "unUsedObject" : [String:Object]     //无用类
         "secondRoundFiles" : [String:File]   //第二轮获取的全部文件
         */
        
        return Observable.create({ (observer) -> Disposable in
            let filePaths = SeekFolderFiles.seekWith(path)
            observer.on(.next(["filePaths":filePaths]))
            
            var methodsDefinedInHFile = [Method]() //h文件定义的方法集合
            var methodsDefinedInMFile = [Method]() //m文件定义的方法集合
            var methodsMFile = [String]()          //m文件pnameId集合
            var methodsUsed = [String]()           //用过的方法集合
            var protocols = [String:Protocol]()    //delegate
            var marcros = [String:Macro]()         //宏
            var fileDic = [String:File]()          //全部文件
            
            /*---------第一轮--------*/
            //遍历文件夹下所有文件
            var i = 0
            let count = filePaths.count
            for filePathString in filePaths {
                
                //读取文件内容
                let fileUrl = URL(string: filePathString)
                
                if fileUrl == nil {
                    
                } else {
                    i += 1
                    _ = ParsingFirstRoundOneFile.parsing(fileUrl: fileUrl!).subscribe(onNext: { (result) in
                        if result is Dictionary<String, Any> {
                            let dic = result as! Dictionary<String, Any>
                            if dic.keys.contains("macroUsedMethod") {
                                let pnameId = dic["macroUsedMethod"] as! String
                                methodsUsed.append(pnameId)
                            }
                            
                            if dic.keys.contains("aMacro") {
                                let aMacro = dic["aMacro"] as! Macro
                                marcros[aMacro.name] = aMacro
                            }
                            if dic.keys.contains("aProtocol") {
                                let aPro = dic["aProtocol"] as! Protocol
                                //检查是否已经存在该protocol
                                if !protocols.keys.contains(aPro.name) {
                                    protocols[aPro.name] = aPro
                                }
                            }
                            if dic.keys.contains("aProMtd") && dic.keys.contains("proName") {
                                let mtd = dic["aProMtd"] as! Method
                                let proName = dic["proName"] as! String
                                protocols[proName]?.methods.append(mtd)
                            }
                            if dic.keys.contains("aMtdInMFile") {
                                let mtd = dic["aMtdInMFile"] as! Method
                                methodsDefinedInMFile.append(mtd)
                                methodsMFile.append(mtd.pnameId) //方便快速对比映射用
                            }
                            if dic.keys.contains("aUsedMtdPnameId") {
                                let mNameId = dic["aUsedMtdPnameId"] as! String
                                methodsUsed.append(mNameId) //将用过的方法添加到集合中
                            }
                            if dic.keys.contains("aMtdInHFile") {
                                let mtd = dic["aMtdInHFile"] as! Method
                                methodsDefinedInHFile.append(mtd)
                            }
                            if dic.keys.contains("completeAFile") {
                                let aFile = dic["completeAFile"] as! File
                                fileDic[aFile.path] = aFile
                                observer.on(.next(["firstRoundAFile" : aFile]))
                                observer.on(.next(["currentParsingFileDes" : "进度：\(i+1)/\(count) 正在查询文件：\(aFile.name)"]))
                            }
                        }
                        
                        
                    })
                    
                    
                } //判断地址是否为空
                
            } //结束所有文件遍历
            
            //输出
            observer.on(.next(["methodsUsed":methodsUsed]))
            observer.on(.next(["methodsMFile":methodsMFile]))
            observer.on(.next(["methodsDefinedInHFile":methodsDefinedInHFile]))
            observer.on(.next(["methodsDefinedInMFile":methodsDefinedInMFile]))
            
            
            /*--------第二轮--------*/
            var allFiles = [String:File]() //需要查找的头文件
            var newFiles = [String:File]() //递归全的文件
            
            var allObjects = [String:Object]()
            var allUsedObjects = [String:Object]()
            
            for (_, aFile) in fileDic {
                allFiles[aFile.name] = aFile
            }
            for (_, aFile) in allFiles {
                //单文件处理
                aFile.recursionImports = self.fetchImports(file: aFile, allFiles: allFiles, allRecursionImports:[Import]())
//                Console.outPrint("\(aFile.name)")
                //记录所有import的的类
                for aImport in aFile.recursionImports {
                    for (name, aObj) in aImport.file.objects {
                        //全部类
                        aFile.importObjects[name] = aObj
                        allObjects[name] = aObj
                    }
                }
                newFiles[aFile.name] = aFile
                //处理无用的import
                //在文件方法里记录所有用过的类
                for aMethod in aFile.methods {
                    let _ = ParsingMethodContent.parsing(method: aMethod, file: aFile).subscribe(onNext:{ (result) in
                        if result is Object {
                            let aObj = result as! Object
                            allUsedObjects[aObj.name] = aObj
                        }
                    })
                }
                //在文件宏里记录所有用过的类
                for (_,aMac) in aFile.macros {
                    let _ = ParsingMacro.parsing(aMac: aMac, file: aFile).subscribe(onNext: { result in
                        if result is Object {
                            let obj = result as! Object
                            allUsedObjects[obj.name] = obj
                        }
                    })
                }
                //记录类的父类，作为已用类
                for (_, value) in allObjects {
                    if value.superName.characters.count > 0 {
                        guard let obj = allObjects[value.superName] else {
                            continue
                        }
                        allUsedObjects[value.superName] = obj
                    }
                }
                
            }
            
            observer.on(.next(["allObjects" : allObjects]))
            observer.on(.next(["allUsedObjects" : allUsedObjects]))
            observer.on(.next(["secondRoundFiles" : newFiles]))
            observer.on(.completed)
            
            return Disposables.create {}
        })
    }
    
    
    
    //递归获取所有import
    class func fetchImports(file: File, allFiles:[String:File], allRecursionImports:[Import]) -> [Import] {
        var allRecursionImports = allRecursionImports
        for aImport in file.imports {
            
            
            guard let importFile = allFiles[aImport.fileName] else {
                continue
            }
            if !checkIfContain(aImport: aImport, inImports: allRecursionImports) {
                allRecursionImports.append(addFileObjectTo(aImport: aImport, allFiles: allFiles))
            } else {
                continue
            }
            
            let reRecursionImports = fetchImports(file: importFile, allFiles: allFiles, allRecursionImports: allRecursionImports)
            for aImport in reRecursionImports {
                if !checkIfContain(aImport: aImport, inImports: allRecursionImports) {
                    allRecursionImports.append(addFileObjectTo(aImport: aImport, allFiles: allFiles))
                }
            }
            
        }
        return allRecursionImports
    }
    
    class func addFileObjectTo(aImport:Import, allFiles: [String:File]) -> Import {
        var mImport = aImport
        guard let aFile =  allFiles[aImport.fileName] else {
            return aImport
        }
        mImport.file = aFile
        return mImport
    }
    
    class func checkIfContain(aImport:Import, inImports:[Import]) -> Bool{
        let tf = inImports.contains { element in
            if aImport.fileName == element.fileName {
                return true
            } else {
                return false
            }
        }
        return tf
    }
    
}


