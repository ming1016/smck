//
//  HtmlAST.swift
//  smck
//
//  Created by Daiming on 2017/4/13.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

/*
 grammer Backus–Naur form(BNF) https://en.wikipedia.org/wiki/Backus-Naur_form
 <prototype>  ::= <identifier> "(" <params> ")"
 <params>     ::= <identifier> | <identifier>, <params>
 <definition> ::= "def" <prototype> <expr> ";"
 <extern>     ::= "extern" <prototype> ";"
 <operator>   ::= "+" | "-" | "*" | "/" | "%"
 <expr>       ::= <binary> | <call> | <identifier> | <number> | <ifelse> | "(" <expr> ")"
 <binary>     ::= <expr> <operator> <expr>
 <call>       ::= <identifier> "(" <arguments> ")"
 <ifelse>     ::= "if" <expr> "then" <expr> "else" <expr>
 <arguments>  ::= <expr> | <expr> "," <arguments>
 */

struct SMLangPrototype {
    let name: String
    let params: [String]
}

indirect enum SMLangExpr {
    case number(Double)
    case variable(String)
    case binary(SMLangExpr, SMLangBinaryOperator, SMLangExpr)
    case call(String, [SMLangExpr])
    case ifelse(SMLangExpr, SMLangExpr, SMLangExpr)
}

struct SMLangDefinition {
    let prototype: SMLangPrototype
    let expr: SMLangExpr
}

class SMLangFile {
    private(set) var externs = [SMLangPrototype]()
    private(set) var definitions = [SMLangDefinition]()
    private(set) var expressions = [SMLangExpr]()
    private(set) var prototypeMap = [String: SMLangPrototype]()
    
    func prototype(name:String) -> SMLangPrototype? {
        return prototypeMap[name]
    }
    
    func addExpression(_ expression:SMLangExpr) {
        expressions.append(expression)
    }
    
    func addExtern(_ prototype:SMLangPrototype) {
        externs.append(prototype)
        prototypeMap[prototype.name] = prototype
    }
    
    func addDefinition(_ definition:SMLangDefinition) {
        definitions.append(definition)
        prototypeMap[definition.prototype.name] = definition.prototype
    }
    
}

