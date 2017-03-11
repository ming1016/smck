//
//  main.swift
//  smck
//
//  Created by daiming on 2017/3/11.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

let checker = Checker()
if CommandLine.argc < 2 {
    checker.interactiveModel()
} else {
    checker.staticMode()
}

