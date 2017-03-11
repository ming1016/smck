//
//  ParsingObject.swift
//  SMCheckProjectCL
//
//  Created by didi on 2017/3/10.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

class ParsingObject {
    class func parsing(tokens:[String], file:File) -> Observable<Any> {
        return Observable.create({ (observer) -> Disposable in
            for tk in tokens {
                guard let obj = file.importObjects[tk] else {
                    continue
                }
                guard let _ = file.usedObjects[tk] else {
                    //记录使用过的类
                    file.usedObjects[tk] = obj
                    observer.on(.next(obj))
                    continue
                }
            }
            observer.on(.completed)
            return Disposables.create {}
        })
    }
}
