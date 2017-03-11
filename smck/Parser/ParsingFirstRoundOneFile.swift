//
//  ParsingFirstRoundOneFile.swift
//  SMCheckProjectCL
//
//  Created by didi on 2017/3/8.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

class ParsingFirstRoundOneFile {
    class func parsing(fileUrl:URL) -> Observable<Any> {
        /*
         onNext 的 Dic 定义
         "macroUsedMethod" : String //在宏里用过的方法pnameId
         "aMacro" : Macro           //宏
         "aProtocol" : Protocol     //协议
         ["aProMtd" : Method, "proName" : "name"]    //协议里的方法
         "aMtdInMFile" : Method     //m文件里的方法
         "aUsedMtdPnameId" : String //在方法里使用过的方法的pnameId
         "aMtdInHFile" : Method     //h文件里的方法
         "completeAFile" : File     //完成的文件
         */
        return Observable.create({ (observer) -> Disposable in
            let aFile = File()
            aFile.path = fileUrl.absoluteString
            //显示parsing的状态
//            observer.on(.next(["currentParsingFileDes" : "进度：\(i+1)/\(count) 正在查询文件：\(aFile.name)"]))
            let content = try! String(contentsOf: fileUrl, encoding: String.Encoding.utf8)
            //print("文件内容: \(content)")
            aFile.content = content
            
            let tokens = ParsingBase.createOCTokens(conent: content)
            
            //----------根据行数切割----------
            let lines = ParsingBase.createOCLines(content: content)
            var inInterfaceTf = false
            var inImplementationTf = false
            var inProtocolTf = false
            var currentProtocolName = ""
            var obj = Object()
            
            for var aLine in lines {
                //清理头尾
                aLine = aLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                let tokens = ParsingBase.createOCTokens(conent: aLine)
                //处理 #define start
                if aLine.hasPrefix(Sb.defineStr) {
                    //处理宏定义的方法
                    let reMethod = ParsingMethodContent.parsing(contentArr: tokens, inMethod: Method())
                    if reMethod.usedMethod.count > 0 {
                        for aUsedMethod in reMethod.usedMethod {
                            //将用过的方法添加到集合中
                            observer.on(.next(["macroUsedMethod" : aUsedMethod.pnameId]))
                        }
                    }
                    //保存在文件结构体中
                    let aMacro = ParsingMacro.parsing(line: aLine)
                    aFile.macros[aMacro.name] = aMacro //添加到文件的集合里
                    observer.on(.next(["aMacro" : aMacro])) //添加到全局里
                    continue
                }//#define end
                
                //处理 #import start
                if aLine.hasPrefix(Sb.importStr) {
                    let imp = ParsingImport.parsing(tokens: tokens)
                    guard imp.fileName.characters.count > 0 else {
                        continue
                    }
                    aFile.imports.append(imp)
                    continue
                }//#import end
                
                
                //处理 @interface
                if aLine.hasPrefix(Sb.atInteface) && !inInterfaceTf {
                    inInterfaceTf = true
                    inProtocolTf = false
                    currentProtocolName = ""
                    
                    //查找文件中是否有该类，有就使用那个，没有就创建一个
                    let objName = ParsingInterface.parsingNameFrom(line: aLine)
                    if !aFile.objects.keys.contains(objName) {
                        obj = Object()
                        aFile.objects[objName] = obj
                    }
                    
                    ParsingInterface.parsing(line: aLine, inObject: obj)
                    continue
                }
                if inInterfaceTf {
                    //处理属性
                    if aLine.hasPrefix(Sb.atProperty) {
                        let aProperty = ParsingProperty.parsing(tokens: ParsingBase.createOCTokens(conent: aLine))
                        obj.properties.append(aProperty)
                    }
                }
                if aLine.hasPrefix(Sb.atEnd) && inInterfaceTf {
                    //                            aFile.objects.append(obj)
                    inInterfaceTf = false
                    inProtocolTf = false
                    currentProtocolName = ""
                    continue
                }
                
                //处理 @implementation
                if aLine.hasPrefix(Sb.atImplementation) && !inImplementationTf {
                    inImplementationTf = true
                    //暂不处理
                    continue
                }
                if aLine.hasPrefix(Sb.atEnd) && inImplementationTf {
                    inImplementationTf = false
                    inProtocolTf = false
                    currentProtocolName = ""
                    continue
                }
                
                //处理 @protocol
                if aLine.hasPrefix(Sb.atProtocol) && !inProtocolTf {
                    inProtocolTf = true
                    currentProtocolName = ParsingProtocol.parsingNameFrom(line: aLine)
                    
                    var pro = Protocol()
                    pro.name = currentProtocolName
                    observer.on(.next(["aProtocol", pro]))
                    continue
                }
                if inProtocolTf && currentProtocolName != "" {
                    //开始处理protocol里的方法
                    if !aLine.hasPrefix(Sb.atOptional) || !aLine.hasPrefix(Sb.atRequired) {
                        let pMtd = ParsingMethod.parsing(tokens: ParsingBase.createOCTokens(conent: aLine))
                        if pMtd.pnameId != "" {
                            observer.on(.next(["aProMtd" : pMtd, "proName" : currentProtocolName]))
                        }
                    }
                }
                if aLine.hasPrefix(Sb.atEnd) && inProtocolTf {
                    inProtocolTf = false
                    currentProtocolName = ""
                    continue
                }
                
                
            } //遍历lines，行数组
            
            //测试用
            if aFile.name == "SMSubCls.h" {
                
            }
            
            //---------根据token切割-----------
            //方法解析
            var mtdArr = [String]() //方法字符串
            var psMtdTf = false //是否在解析方法
            var psMtdStep = 0
            //方法内部解析
            var mtdContentArr = [String]()
            var psMtdContentClass = Method() //正在解析的那个方法
            var psMtdContentTf = false  //是否正在解析那个方法中实现部分内容
            var psMtdContentBraceCount = 0 //大括号计数
            //获取当前object
            var implementStep = 0
            var currentObject = Object()
            
            for tk in tokens {
                //h文件 m文件
                if aFile.type == FileType.FileH || aFile.type == FileType.FileM {
                    //设置使用哪个obj，根据implement
                    if aFile.type == FileType.FileM {
                        if tk == Sb.at {
                            implementStep = 1
                        } else if tk == Sb.implementationStr && implementStep == 1 {
                            implementStep = 2
                        } else if implementStep == 2 {
                            implementStep = 0
                            guard let cObject = aFile.objects[tk] else {
                                continue
                            }
                            currentObject = cObject
                        } else if tk == Sb.endStr && implementStep == 1{
                            implementStep = 0
                        } else {
                            implementStep = 0
                        }
                        
                    }
                    //解析方法内容
                    if psMtdContentTf {
                        if tk == Sb.braceL {
                            mtdContentArr.append(tk)
                            psMtdContentBraceCount += 1
                        } else if tk == Sb.braceR {
                            mtdContentArr.append(tk)
                            psMtdContentBraceCount -= 1
                            if psMtdContentBraceCount == 0 {
                                var reMethod = ParsingMethodContent.parsing(contentArr: mtdContentArr, inMethod: psMtdContentClass)
                                aFile.methods.append(reMethod)
                                currentObject.methods.append(reMethod)
                                reMethod.filePath = aFile.path //将m文件路径赋给方法
                                observer.on(.next(["aMtdInMFile" : reMethod]))
                                if reMethod.usedMethod.count > 0 {
                                    for aUsedMethod in reMethod.usedMethod {
                                        //方法里用过的方法
                                        observer.on(.next(["aUsedMtdPnameId" : aUsedMethod.pnameId]))
                                    }
                                }
                                //结束
                                mtdContentArr = []
                                psMtdTf = false
                                psMtdContentTf = false
                            }
                        } else {
                            //解析方法内容中
                            //先解析使用的方法
                            mtdContentArr.append(tk)
                        }
                        continue
                    } //方法内容处理结束
                    
                    //方法解析
                    //如果-和(没有连接起来直接判断不是方法
                    if psMtdStep == 1 && tk != Sb.rBktL {
                        psMtdStep = 0
                        psMtdTf = false
                        mtdArr = []
                    }
                    
                    if (tk == Sb.minus || tk == Sb.add) && psMtdStep == 0 && !psMtdTf {
                        psMtdTf = true
                        psMtdStep = 1;
                        mtdArr.append(tk)
                    } else if tk == Sb.rBktL && psMtdStep == 1 && psMtdTf {
                        psMtdStep = 2;
                        mtdArr.append(tk)
                    } else if (tk == Sb.semicolon || tk == Sb.braceL) && psMtdStep == 2 && psMtdTf {
                        mtdArr.append(tk)
                        var parsedMethod = ParsingMethod.parsing(tokens: mtdArr)
                        //开始处理方法内部
                        if tk == Sb.braceL {
                            psMtdContentClass = parsedMethod
                            psMtdContentTf = true
                            psMtdContentBraceCount += 1
                            mtdContentArr.append(tk)
                        } else {
                            aFile.methods.append(parsedMethod)
                            parsedMethod.filePath = aFile.path //将h文件的路径赋给方法
                            observer.on(.next(["aMtdInHFile" : parsedMethod]))
                            psMtdTf = false
                        }
                        //重置
                        psMtdStep = 0;
                        mtdArr = []
                        
                    } else if psMtdTf {
                        mtdArr.append(tk)
                    }
                    
                    
                } //m和h文件
                
            } //遍历tokens
            //aFile.des()
            observer.on(.next(["completeAFile" : aFile]))
            
            return Disposables.create {}
        })
    }
}
