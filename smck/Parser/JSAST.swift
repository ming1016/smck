//
//  JSAST.swift
//  smck
//
//  Created by DaiMing on 2017/5/2.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation

indirect enum JSPrimaryExpression {
    case this(String)
    case objectLiteral(JSObjectLiteral)
    case expressions(JSExpression)
    case identifier(JSIdentifier)
    case arrayLiteral(JSArrayLiteral)
    case literal(JSLiteral)
}

indirect enum JSLiteral {
    case decimal(String)
    case hexInteger(String)
    case string(String)
    case boolean(String)
    case null(String)
    case regularExpression(String)
}

struct JSIdentifier {
    let identifier:String
}

indirect enum JSArrayLiteral {
    case elisions([JSElision])
    case elementList(JSElementList)
}

struct JSElementList {
    let elisions:[JSElision]
    let assignmentExpression:JSAssignmentExpression
}

struct JSElision {
    
}

struct JSObjectLiteral {
    let propertyNameAndValueList:[JSPropertyNameAndValue]
}

struct JSPropertyNameAndValueList {
    
}

struct JSPropertyNameAndValue {
    let propertyName: String
//    let
}

enum JSPropertyName {
    
}

struct JSMemberExpression {
    
}

struct JSMemberExpressionForIn {
    
}

struct JSAllocationExpression {
    
}

enum JSMemberExpressionPart {
    
}

struct JSCallExpression {
    
}

struct JSCallExpressionForIn {
    
}

enum JSCallExpressionPart {
    
}

struct JSArguments {
    
}

struct JSArgumentList {
    
}

enum JSLeftHandSideExpression {
    
}

enum JSLeftHandSideExpressionForIn {
    case callExpression()
    case memberExpression()
}

struct JSPostfixExpression {
    
}

enum JSUnaryOperator {
    
}

struct JSMultiplicativeExpression {
    
}

enum JSMultiplicativeOperator {
    
}

struct JSAdditiveExpression {
    
}

enum JSAdditiveOperator {
    
}

struct JSShiftExpression {
    
}

enum JSShiftOperator {
    
}

struct JSRelationalExpression {
    
}

enum JSRelationalOperator {
    
}

struct JSRelationalExpressionNoIn {
    
}

enum JSRelationalNoInOperator {
    
}

struct JSEqualityExpression {
    
}

struct JSEqualityExpressionNoIn {
    
}

enum JSEqualityOperator {
    
}

struct JSBitwiseANDExpression {
    
}

struct JSBitwiseANDExpressionNoIn {
    
}

struct JSBitwiseANDOperator {
    
}

struct JSBitwiseXORExpression {
    
}

struct JSBitwiseXORExpressionNoIn {
    
}

struct JSBitwiseXOROperator {
    
}

struct JSBitwiseORExpression {
    
}

struct JSBitwiseORExpressionNoIn {
    
}

struct JSBitwiseOROperator {
    
}

struct JSLogicalANDExpression {
    
}

struct JSLogicalANDExpressionNoIn {
    
}

struct JSLogicalANDOperator {
    
}

struct JSLogicalORExpression {
    
}

struct JSLogicalORExpressionNoIn {
    
}

struct JSLogicalOROperator {
    
}

struct JSConditionalExpression {
    
}

struct JSConditionalExpressionNoIn {
    
}

struct JSAssignmentExpression {
    
}

struct JSAssignmentExpressionNoIn {
    
}

struct JSAssignmentOperator {
    
}

struct JSExpression {
    
}

struct JSExpressionNoIn {
    
}

enum JSStatement {
    
}

struct JSBlock {
    
}

struct JSStatementList {
    
}

struct JSVariableStatement {
    
}

struct JSVariableDeclarationList {
    
}

struct JSVariableDeclarationListNoIn {
    
}

struct JSVariableDeclaration {
    
}

struct JSVariableDeclarationNoIn {
    
}

struct JSInitialiser {
    
}

struct JSInitialiserNoIn {
    
}

struct JSEmptyStatement {
    
}

struct JSExpressionStatement {
    
}

struct JSIfStatement {
    
}

struct JSIterationStatement {
    
}

struct JSContinueStatement {
    
}

struct JSBreakStatement {
    
}

struct JSReturnStatement {
    
}

struct JSWithStatement {
    
}

struct JSSwitchStatement {
    
}

struct JSCaseBlock {
    
}

struct JSCaseClauses {
    
}

struct JSCaseClause {
    
}

struct JSDefaultClause {
    
}

struct JSLabelledStatement {
    
}

struct JSThrowStatement {
    
}

struct JSTryStatement {
    
}

struct JSCatch {
    
}

struct JSFinally {
    
}

struct JSFunctionDeclaration {
    
}

struct JSFunctionExpression {
    
}

struct JSFormalParameterList {
    
}

struct JSFunctionBody {
    
}

struct JSProgram {
    
}

struct JSSourceElements {
    
}

struct JSSourceElement {
    
}

struct JSImportStatement {
    
}

struct JSName {
    
}

struct JScriptVarStatement {
    
}

struct JScriptVarDeclarationList {
    
}

struct JScriptVarDeclaration {
    
}

struct JSInsertSemiColon {
    
}











class JSFile {
    
}

/*
 PrimaryExpression	::=	"this"
 |	ObjectLiteral
 |	( "(" Expression ")" )
 |	Identifier
 |	ArrayLiteral
 |	Literal
 Literal	::=	( <DECIMAL_LITERAL> | <HEX_INTEGER_LITERAL> | <STRING_LITERAL> | <BOOLEAN_LITERAL> | <NULL_LITERAL> | <REGULAR_EXPRESSION_LITERAL> )
 Identifier	::=	<IDENTIFIER_NAME>
 ArrayLiteral	::=	"[" ( ( Elision )? "]" | ElementList Elision "]" | ( ElementList )? "]" )
 ElementList	::=	( Elision )? AssignmentExpression ( Elision AssignmentExpression )*
 Elision	::=	( "," )+
 ObjectLiteral	::=	"{" ( PropertyNameAndValueList )? "}"
 PropertyNameAndValueList	::=	PropertyNameAndValue ( "," PropertyNameAndValue | "," )*
 PropertyNameAndValue	::=	PropertyName ":" AssignmentExpression
 PropertyName	::=	Identifier
 |	<STRING_LITERAL>
 |	<DECIMAL_LITERAL>
 MemberExpression	::=	( ( FunctionExpression | PrimaryExpression ) ( MemberExpressionPart )* )
 |	AllocationExpression
 MemberExpressionForIn	::=	( ( FunctionExpression | PrimaryExpression ) ( MemberExpressionPart )* )
 AllocationExpression	::=	( "new" MemberExpression ( ( Arguments ( MemberExpressionPart )* )* ) )
 MemberExpressionPart	::=	( "[" Expression "]" )
 |	( "." Identifier )
 CallExpression	::=	MemberExpression Arguments ( CallExpressionPart )*
 CallExpressionForIn	::=	MemberExpressionForIn Arguments ( CallExpressionPart )*
 CallExpressionPart	::=	Arguments
 |	( "[" Expression "]" )
 |	( "." Identifier )
 Arguments	::=	"(" ( ArgumentList )? ")"
 ArgumentList	::=	AssignmentExpression ( "," AssignmentExpression )*
 LeftHandSideExpression	::=	CallExpression
 |	MemberExpression
 LeftHandSideExpressionForIn	::=	CallExpressionForIn
 |	MemberExpressionForIn
 PostfixExpression	::=	LeftHandSideExpression ( PostfixOperator )?
 PostfixOperator	::=	( "++" | "--" )
 UnaryExpression	::=	( PostfixExpression | ( UnaryOperator UnaryExpression )+ )
 UnaryOperator	::=	( "delete" | "void" | "typeof" | "++" | "--" | "+" | "-" | "~" | "!" )
 MultiplicativeExpression	::=	UnaryExpression ( MultiplicativeOperator UnaryExpression )*
 MultiplicativeOperator	::=	( "*" | <SLASH> | "%" )
 AdditiveExpression	::=	MultiplicativeExpression ( AdditiveOperator MultiplicativeExpression )*
 AdditiveOperator	::=	( "+" | "-" )
 ShiftExpression	::=	AdditiveExpression ( ShiftOperator AdditiveExpression )*
 ShiftOperator	::=	( "<<" | ">>" | ">>>" )
 RelationalExpression	::=	ShiftExpression ( RelationalOperator ShiftExpression )*
 RelationalOperator	::=	( "<" | ">" | "<=" | ">=" | "instanceof" | "in" )
 RelationalExpressionNoIn	::=	ShiftExpression ( RelationalNoInOperator ShiftExpression )*
 RelationalNoInOperator	::=	( "<" | ">" | "<=" | ">=" | "instanceof" )
 EqualityExpression	::=	RelationalExpression ( EqualityOperator RelationalExpression )*
 EqualityExpressionNoIn	::=	RelationalExpressionNoIn ( EqualityOperator RelationalExpressionNoIn )*
 EqualityOperator	::=	( "==" | "!=" | "===" | "!==" )
 BitwiseANDExpression	::=	EqualityExpression ( BitwiseANDOperator EqualityExpression )*
 BitwiseANDExpressionNoIn	::=	EqualityExpressionNoIn ( BitwiseANDOperator EqualityExpressionNoIn )*
 BitwiseANDOperator	::=	"&"
 BitwiseXORExpression	::=	BitwiseANDExpression ( BitwiseXOROperator BitwiseANDExpression )*
 BitwiseXORExpressionNoIn	::=	BitwiseANDExpressionNoIn ( BitwiseXOROperator BitwiseANDExpressionNoIn )*
 BitwiseXOROperator	::=	"^"
 BitwiseORExpression	::=	BitwiseXORExpression ( BitwiseOROperator BitwiseXORExpression )*
 BitwiseORExpressionNoIn	::=	BitwiseXORExpressionNoIn ( BitwiseOROperator BitwiseXORExpressionNoIn )*
 BitwiseOROperator	::=	"|"
 LogicalANDExpression	::=	BitwiseORExpression ( LogicalANDOperator BitwiseORExpression )*
 LogicalANDExpressionNoIn	::=	BitwiseORExpressionNoIn ( LogicalANDOperator BitwiseORExpressionNoIn )*
 LogicalANDOperator	::=	"&&"
 LogicalORExpression	::=	LogicalANDExpression ( LogicalOROperator LogicalANDExpression )*
 LogicalORExpressionNoIn	::=	LogicalANDExpressionNoIn ( LogicalOROperator LogicalANDExpressionNoIn )*
 LogicalOROperator	::=	"||"
 ConditionalExpression	::=	LogicalORExpression ( "?" AssignmentExpression ":" AssignmentExpression )?
 ConditionalExpressionNoIn	::=	LogicalORExpressionNoIn ( "?" AssignmentExpression ":" AssignmentExpressionNoIn )?
 AssignmentExpression	::=	( LeftHandSideExpression AssignmentOperator AssignmentExpression | ConditionalExpression )
 AssignmentExpressionNoIn	::=	( LeftHandSideExpression AssignmentOperator AssignmentExpressionNoIn | ConditionalExpressionNoIn )
 AssignmentOperator	::=	( "=" | "*=" | <SLASHASSIGN> | "%=" | "+=" | "-=" | "<<=" | ">>=" | ">>>=" | "&=" | "^=" | "|=" )
 Expression	::=	AssignmentExpression ( "," AssignmentExpression )*
 ExpressionNoIn	::=	AssignmentExpressionNoIn ( "," AssignmentExpressionNoIn )*
 Statement	::=	Block
 |	JScriptVarStatement
 |	VariableStatement
 |	EmptyStatement
 |	LabelledStatement
 |	ExpressionStatement
 |	IfStatement
 |	IterationStatement
 |	ContinueStatement
 |	BreakStatement
 |	ImportStatement
 |	ReturnStatement
 |	WithStatement
 |	SwitchStatement
 |	ThrowStatement
 |	TryStatement
 Block	::=	"{" ( StatementList )? "}"
 StatementList	::=	( Statement )+
 VariableStatement	::=	"var" VariableDeclarationList ( ";" )?
 VariableDeclarationList	::=	VariableDeclaration ( "," VariableDeclaration )*
 VariableDeclarationListNoIn	::=	VariableDeclarationNoIn ( "," VariableDeclarationNoIn )*
 VariableDeclaration	::=	Identifier ( Initialiser )?
 VariableDeclarationNoIn	::=	Identifier ( InitialiserNoIn )?
 Initialiser	::=	"=" AssignmentExpression
 InitialiserNoIn	::=	"=" AssignmentExpressionNoIn
 EmptyStatement	::=	";"
 ExpressionStatement	::=	Expression ( ";" )?
 IfStatement	::=	"if" "(" Expression ")" Statement ( "else" Statement )?
 IterationStatement	::=	( "do" Statement "while" "(" Expression ")" ( ";" )? )
 |	( "while" "(" Expression ")" Statement )
 |	( "for" "(" ( ExpressionNoIn )? ";" ( Expression )? ";" ( Expression )? ")" Statement )
 |	( "for" "(" "var" VariableDeclarationList ";" ( Expression )? ";" ( Expression )? ")" Statement )
 |	( "for" "(" "var" VariableDeclarationNoIn "in" Expression ")" Statement )
 |	( "for" "(" LeftHandSideExpressionForIn "in" Expression ")" Statement )
 ContinueStatement	::=	"continue" ( Identifier )? ( ";" )?
 BreakStatement	::=	"break" ( Identifier )? ( ";" )?
 ReturnStatement	::=	"return" ( Expression )? ( ";" )?
 WithStatement	::=	"with" "(" Expression ")" Statement
 SwitchStatement	::=	"switch" "(" Expression ")" CaseBlock
 CaseBlock	::=	"{" ( CaseClauses )? ( "}" | DefaultClause ( CaseClauses )? "}" )
 CaseClauses	::=	( CaseClause )+
 CaseClause	::=	( ( "case" Expression ":" ) ) ( StatementList )?
 DefaultClause	::=	( ( "default" ":" ) ) ( StatementList )?
 LabelledStatement	::=	Identifier ":" Statement
 ThrowStatement	::=	"throw" Expression ( ";" )?
 TryStatement	::=	"try" Block ( ( Finally | Catch ( Finally )? ) )
 Catch	::=	"catch" "(" Identifier ")" Block
 Finally	::=	"finally" Block
 FunctionDeclaration	::=	"function" Identifier ( "(" ( FormalParameterList )? ")" ) FunctionBody
 FunctionExpression	::=	"function" ( Identifier )? ( "(" ( FormalParameterList )? ")" ) FunctionBody
 FormalParameterList	::=	Identifier ( "," Identifier )*
 FunctionBody	::=	"{" ( SourceElements )? "}"
 Program	::=	( SourceElements )? <EOF>
 SourceElements	::=	( SourceElement )+
 SourceElement	::=	FunctionDeclaration
 |	Statement
 ImportStatement	::=	"import" Name ( "." "*" )? ";"
 Name	::=	<IDENTIFIER_NAME> ( "." <IDENTIFIER_NAME> )*
 JScriptVarStatement	::=	"var" JScriptVarDeclarationList ( ";" )?
 JScriptVarDeclarationList	::=	JScriptVarDeclaration ( "," JScriptVarDeclaration )*
 JScriptVarDeclaration	::=	Identifier ":" <IDENTIFIER_NAME> ( Initialiser )?
 insertSemiColon	::=	java code
 
 */
