//
//  HtmlParser.swift
//  smck
//
//  Created by Daiming on 2017/4/14.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

enum SMLangParseError: Swift.Error {
    case unexpectedToken(SMLangToken)
    case unexpectedEOF
}

class SMLangParser {
    let tokens: [SMLangToken]
    var index = 0
    
    init(tokens: [SMLangToken]) {
        self.tokens = tokens
    }
    
    var currentToken: SMLangToken? {
        return index < tokens.count ? tokens[index] : nil
    }
    
    func consumeToken(n: Int = 1) {
        index += n
    }
    
    func consume(_ token: SMLangToken) throws {
        guard let tk = currentToken else {
            throw SMLangParseError.unexpectedEOF
        }
        guard token == tk else {
            throw SMLangParseError.unexpectedToken(token)
        }
        consumeToken()
    }
    
    /*---------Parse-----------*/
    
    func parseIdentifier() throws -> String {
        guard let tk = currentToken else {
            throw SMLangParseError.unexpectedEOF
        }
        guard case .identifier(let name) = tk else {
            throw SMLangParseError.unexpectedToken(tk)
        }
        consumeToken()
        return name
    }
    
    //泛型和高阶函数 generics and higher-order functions
    func parseCommaSeparated<TermType>(_ parseFn:() throws -> TermType) throws -> [TermType] {
        try consume(.leftParen)
        var vals = [TermType]()
        while let tk = currentToken, tk != .rightParen {
            let val = try parseFn()
            if case .comma? = currentToken {
                try consume(.comma)
            }
            vals.append(val)
        }
        try consume(.rightParen)
        return vals
    }
    
    func parsePrototype() throws -> SMLangPrototype {
        let name = try parseIdentifier()
        let params = try parseCommaSeparated(parseIdentifier)
        return SMLangPrototype(name: name, params: params)
    }
    
    func parseExtern() throws -> SMLangPrototype {
        try consume(.extern)
        let proto = try parsePrototype()
        try consume(.semicolon)
        return proto
    }
    
    func parseExpr() throws -> SMLangExpr {
        guard let tk = currentToken else {
            throw SMLangParseError.unexpectedEOF
        }
        var expr : SMLangExpr
        switch tk {
        case .leftParen:
            consumeToken()
            expr = try parseExpr()
            try consume(.rightParen)
        case .number(let value):
            consumeToken()
            expr = .number(value)
        case .identifier(let value):
            consumeToken()
            if case .leftParen? = currentToken {
                let params = try parseCommaSeparated(parseExpr)
                expr = .call(value, params)
            } else {
                expr = .variable(value)
            }
        case .if:
            consumeToken()
            let cond = try parseExpr()
            try consume(.then)
            let thenVal = try parseExpr()
            try consume(.else)
            let elseVal = try parseExpr()
            expr = .ifelse(cond, thenVal, elseVal)
        default:
            throw SMLangParseError.unexpectedToken(tk)
        }
        
        if case .operator(let op)? = currentToken {
            consumeToken()
            let rhs = try parseExpr()
            expr = .binary(expr, op, rhs)
        }
        return expr
    }
    
    func parseDefinition() throws -> SMLangDefinition {
        try consume(.def)
        let prototype = try parsePrototype()
        let expr = try parseExpr()
        let def = SMLangDefinition(prototype: prototype, expr: expr)
        try consume(.semicolon)
        return def
    }
    
    /*----------File---------*/
    func parseFile() throws -> SMLangFile {
        let file = SMLangFile()
        while let tk = currentToken {
            switch tk {
            case .extern:
                file.addExtern(try parseExtern())
            case .def:
                file.addDefinition(try parseDefinition())
            default:
                let expr = try parseExpr()
                try consume(.semicolon)
                file.addExpression(expr)
            }
        }
        return file
    }
    
}
