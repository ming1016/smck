//
//  HTMLAST.swift
//  smck
//
//  Created by Daiming on 2017/4/16.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

struct HTMLTag {
    let name: String
    let subs: [HTMLTag]
    let attributes: [String:String]
    let value: String
}

class HTMLFile {
    private(set) var tags = [HTMLTag]()
    
    func addTag(_ tag:HTMLTag) {
        tags.append(tag)
    }
}
