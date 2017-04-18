//
//  H5AST.swift
//  smck
//
//  Created by DaiMing on 2017/4/17.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

struct H5Tag {
    let name: String
    let subs: [H5Tag]
    let attributes: [String:String]
    let value: String
}

class H5File {
    private(set) var tags = [H5Tag]()
    
    func addTag(_ tag:H5Tag) {
        tags.append(tag)
    }
}
