//
//  ParsingMacro.swift
//  SMCheckProject
//
//  Created by daiming on 2017/2/22.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

class ParsingMacro {
    class func parsing(line:String) -> Macro {
        var macro = Macro()
        let aLine = line.replacingOccurrences(of: Sb.defineStr, with: "")
        let tokens = ParsingBase.createOCTokens(conent: aLine)
        guard let name = tokens.first else {
            return macro
        }
        macro.name = name
        macro.tokens = tokens
        return macro
    }
    //获取宏中所需的东西
    class func parsing(aMac:Macro, file:File) -> Observable<Any> {
        return Observable.create({ (observer) -> Disposable in
            
            _ = ParsingObject.parsing(tokens: aMac.tokens, file: file).subscribe(onNext: { result in
                if result is Object {
                    let obj = result as! Object
                    observer.on(.next(obj))
                }
            })
            observer.on(.completed)
            return Disposables.create {}
        })
    }
    //获取宏中用到的字符串
}
