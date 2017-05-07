//
//  JSAST.swift
//  smck
//
//  Created by DaiMing on 2017/5/2.
//  Copyright © 2017年 Starming. All rights reserved.
//

import Foundation
/*
 PrimaryExpression	::=	"this"
 |	ObjectLiteral
 |	( "(" Expression ")" )
 |	Identifier
 |	ArrayLiteral
 |	Literal
 */
indirect enum JSPrimaryExpression {
    case this(String)
    case objectLiteral(JSObjectLiteral)
    case expressions(JSExpression)
    case identifier(JSIdentifier)
    case arrayLiteral(JSArrayLiteral)
    case literal(JSLiteral)
}

//Literal	::=	( <DECIMAL_LITERAL> | <HEX_INTEGER_LITERAL> | <STRING_LITERAL> | <BOOLEAN_LITERAL> | <NULL_LITERAL> | <REGULAR_EXPRESSION_LITERAL> )
indirect enum JSLiteral {
    case decimal(String)
    case hexInteger(String)
    case string(String)
    case boolean(String)
    case null(String)
    case regularExpression(String)
}

//Identifier	::=	<IDENTIFIER_NAME>
struct JSIdentifier {
    let identifier: String
}

//ArrayLiteral	::=	"[" ( ( Elision )? "]" | ElementList Elision "]" | ( ElementList )? "]" )
indirect enum JSArrayLiteral {
    case elisions([JSElision])
    case elementList(JSElementList)
}

//ElementList	::=	( Elision )? AssignmentExpression ( Elision AssignmentExpression )*
struct JSElementList {
    let elisions: [JSElision]
    let assignmentExpression: JSAssignmentExpression
}

//Elision	::=	( "," )+
struct JSElision {
    let commas: [String]
}

//ObjectLiteral	::=	"{" ( PropertyNameAndValueList )? "}"
struct JSObjectLiteral {
    let propertyNameAndValueList: [JSPropertyNameAndValueList]
}

//PropertyNameAndValueList	::=	PropertyNameAndValue ( "," PropertyNameAndValue | "," )*
struct JSPropertyNameAndValueList {
    let propertyNameAndValues: [JSPropertyNameAndValue]
}

//PropertyNameAndValue	::=	PropertyName ":" AssignmentExpression
struct JSPropertyNameAndValue {
    let propertyName: String
    let assignmentExpression: JSAssignmentExpression
}

/*
 PropertyName	::=	Identifier
 |	<STRING_LITERAL>
 |	<DECIMAL_LITERAL>
 */
indirect enum JSPropertyName {
    case identifier(JSIdentifier)
    case stringLiteral(String)
    case decimalLiteral(String)
}

/*
 MemberExpression	::=	( ( FunctionExpression | PrimaryExpression ) ( MemberExpressionPart )* )
 |	AllocationExpression
 */
struct JSMemberExpression {
    let functionExpression: JSFunctionExpression
    let primaryExpression: JSPrimaryExpression
    let memberExpressionPart: JSMemberExpressionPart
}

//MemberExpressionForIn	::=	( ( FunctionExpression | PrimaryExpression ) ( MemberExpressionPart )* )
struct JSMemberExpressionForIn {
    let functionExpression: JSFunctionExpression
    let primaryExpression: JSPrimaryExpression
    let memberExpressionPart: JSMemberExpressionPart
}

//AllocationExpression	::=	( "new" MemberExpression ( ( Arguments ( MemberExpressionPart )* )* ) )
struct JSAllocationExpression {
    let memberExpression: JSMemberExpression
    let arguments: JSArguments
    let memberExpressionPart: JSMemberExpressionPart
}

/*
 MemberExpressionPart	::=	( "[" Expression "]" )
 |	( "." Identifier )
 */
indirect enum JSMemberExpressionPart {
    case expressions(JSExpression)
    case identifiers(String)
}

//CallExpression	::=	MemberExpression Arguments ( CallExpressionPart )*
struct JSCallExpression {
    let memberExpression: JSMemberExpression
    let arguments: JSArguments
    let callExpressionPart: JSCallExpressionPart
}

//CallExpressionForIn	::=	MemberExpressionForIn Arguments ( CallExpressionPart )*
struct JSCallExpressionForIn {
    let memberExpressionForIn: JSMemberExpressionForIn
    let arguments: JSArguments
    let callExpressionPart: JSCallExpressionPart
}

/*
 CallExpressionPart	::=	Arguments
 |	( "[" Expression "]" )
 |	( "." Identifier )
 */
indirect enum JSCallExpressionPart {
    case arguments(JSArguments)
    case expression(JSExpression)
    case identifier(String)
}

//Arguments	::=	"(" ( ArgumentList )? ")"
struct JSArguments {
    let argumentList: JSArgumentList
}

//ArgumentList	::=	AssignmentExpression ( "," AssignmentExpression )*
struct JSArgumentList {
    let assignmentExpressions: [JSAssignmentExpression]
}

/*
 LeftHandSideExpression	::=	CallExpression
 |	MemberExpression
 */
indirect enum JSLeftHandSideExpression {
    case callExpression(JSCallExpression)
    case memberExpression(JSMemberExpression)
}

/*
 LeftHandSideExpressionForIn	::=	CallExpressionForIn
 |	MemberExpressionForIn
 */
enum JSLeftHandSideExpressionForIn {
    case callExpression(JSCallExpressionForIn)
    case memberExpression(JSMemberExpressionForIn)
}

//PostfixExpression	::=	LeftHandSideExpression ( PostfixOperator )?
struct JSPostfixExpression {
    let leftHandSideExpression: JSLeftHandSideExpression
    let postfixOperator: JSPostfixOperator
}

//PostfixOperator	::=	( "++" | "--" )
indirect enum JSPostfixOperator {
    case plusPlus(String)
    case minusMinus(String)
}

//UnaryExpression	::=	( PostfixExpression | ( UnaryOperator UnaryExpression )+ )
indirect enum JSUnaryExpression {
    case postfixExpression(JSPrimaryExpression)
    case unaryOperator(JSUnaryOperator)
    case unaryExpression(JSUnaryExpression)
}

//UnaryOperator	::=	( "delete" | "void" | "typeof" | "++" | "--" | "+" | "-" | "~" | "!" )
indirect enum JSUnaryOperator {
    case delete(String)
    case void(String)
    case typeof(String)
    case plusPlus(String)
    case minusMinus(String)
    case plus(String)
    case minus(String)
    case tilde(String)
    case excMk(String)
}

//MultiplicativeExpression	::=	UnaryExpression ( MultiplicativeOperator UnaryExpression )*
struct JSMultiplicativeExpression {
    let multiplicativeOperator: JSMultiplicativeOperator
    let unaryExpression: JSUnaryExpression
}

//MultiplicativeOperator	::=	( "*" | <SLASH> | "%" )
indirect enum JSMultiplicativeOperator {
    case asterisk(String)
    case slash(String)
    case percent(String)
}

//AdditiveExpression	::=	MultiplicativeExpression ( AdditiveOperator MultiplicativeExpression )*
struct JSAdditiveExpression {
    let additiveOperator: JSAdditiveOperator
    let multiplicativeExpression: JSMultiplicativeExpression
}

//AdditiveOperator	::=	( "+" | "-" )
enum JSAdditiveOperator {
    case plus(String)
    case minus(String)
}

//ShiftExpression	::=	AdditiveExpression ( ShiftOperator AdditiveExpression )*
struct JSShiftExpression {
    let shiftOperator: JSShiftOperator
    let additiveExpression: JSAdditiveExpression
}

//ShiftOperator	::=	( "<<" | ">>" | ">>>" )
indirect enum JSShiftOperator {
    case agLDouble(String)
    case agRDouble(String)
    case agRTriple(String)
}

//RelationalExpression	::=	ShiftExpression ( RelationalOperator ShiftExpression )*
struct JSRelationalExpression {
    let shiftExpression: JSShiftExpression
    let relationOperator: JSRelationalOperator
}

//RelationalOperator	::=	( "<" | ">" | "<=" | ">=" | "instanceof" | "in" )
indirect enum JSRelationalOperator {
    case agL(String)
    case agR(String)
    case agLEqual(String)
    case agREqual(String)
    case instanceof(String)
    case inString(String)
}

//RelationalExpressionNoIn	::=	ShiftExpression ( RelationalNoInOperator ShiftExpression )*
struct JSRelationalExpressionNoIn {
    let shiftExpression: JSShiftExpression
    let relationalNoInOperation: JSRelationalNoInOperator
}

//RelationalNoInOperator	::=	( "<" | ">" | "<=" | ">=" | "instanceof" )
indirect enum JSRelationalNoInOperator {
    case agL(String)
    case agR(String)
    case agLEqual(String)
    case agREqual(String)
    case instanceof(String)
}

//EqualityExpression	::=	RelationalExpression ( EqualityOperator RelationalExpression )*
struct JSEqualityExpression {
    let relationalExpression: JSRelationalExpression
    let eqaulityOperator: JSEqualityOperator
}

//EqualityExpressionNoIn	::=	RelationalExpressionNoIn ( EqualityOperator RelationalExpressionNoIn )*
struct JSEqualityExpressionNoIn {
    let relationalExpressionNoIn: JSRelationalExpressionNoIn
    let equalityOperator: JSEqualityOperator
}

//EqualityOperator	::=	( "==" | "!=" | "===" | "!==" )
indirect enum JSEqualityOperator {
    case equalDouble(String)
    case noEqual(String)
    case equalTriple(String)
    case noEqualDouble(String)
}

//BitwiseANDExpression	::=	EqualityExpression ( BitwiseANDOperator EqualityExpression )*
struct JSBitwiseANDExpression {
    let bitwiseANDOperator: JSBitwiseANDOperator
    let equalityExprssion: JSEqualityExpression
}

//BitwiseANDExpressionNoIn	::=	EqualityExpressionNoIn ( BitwiseANDOperator EqualityExpressionNoIn )*
struct JSBitwiseANDExpressionNoIn {
    let bitwiseANDOperator: JSBitwiseANDOperator
    let equalityExpressionNoIn: JSEqualityExpressionNoIn
}

//BitwiseANDOperator	::=	"&"
struct JSBitwiseANDOperator {
    let bitwiseANDOperator: String
}

//BitwiseXORExpression	::=	BitwiseANDExpression ( BitwiseXOROperator BitwiseANDExpression )*
struct JSBitwiseXORExpression {
    let bitwiseXOROperator: JSBitwiseXOROperator
    let bitwiseANDExpression: JSBitwiseANDExpression
}

//BitwiseXORExpressionNoIn	::=	BitwiseANDExpressionNoIn ( BitwiseXOROperator BitwiseANDExpressionNoIn )*
struct JSBitwiseXORExpressionNoIn {
    let bitwiseANDExpressionNoIn: JSBitwiseANDExpressionNoIn
    let bitwiseXOROperator: JSBitwiseXOROperator
}

//BitwiseXOROperator	::=	"^"
struct JSBitwiseXOROperator {
    let bitwiseXOROperator: String
}

//BitwiseORExpression	::=	BitwiseXORExpression ( BitwiseOROperator BitwiseXORExpression )*
struct JSBitwiseORExpression {
    let bitwiseOROperator: JSBitwiseOROperator
    let bitwiseXORExpression: JSBitwiseXORExpression
}

//BitwiseORExpressionNoIn	::=	BitwiseXORExpressionNoIn ( BitwiseOROperator BitwiseXORExpressionNoIn )*
struct JSBitwiseORExpressionNoIn {
    let bitwiseOROpertor: JSBitwiseOROperator
    let bitwiseXORExpressionNoIn: JSBitwiseXORExpressionNoIn
}

//BitwiseOROperator	::=	"|"
struct JSBitwiseOROperator {
    let bitwiseOROperator: String
}

//LogicalANDExpression	::=	BitwiseORExpression ( LogicalANDOperator BitwiseORExpression )*
struct JSLogicalANDExpression {
    let logicalANDOperator: JSLogicalANDOperator
    let bitwiseORExpression: JSBitwiseORExpression
}

//LogicalANDExpressionNoIn	::=	BitwiseORExpressionNoIn ( LogicalANDOperator BitwiseORExpressionNoIn )*
struct JSLogicalANDExpressionNoIn {
    let logicalANDOperator: JSLogicalANDOperator
    let bitwiseORExpressionNoIn: JSBitwiseORExpressionNoIn
}

//LogicalANDOperator	::=	"&&"
struct JSLogicalANDOperator {
    let logicalANDOperator: String
}

//LogicalORExpression	::=	LogicalANDExpression ( LogicalOROperator LogicalANDExpression )*
struct JSLogicalORExpression {
    let logicalOROperator: JSLogicalOROperator
    let logicalANDExpression: JSLogicalANDExpression
}

//LogicalORExpressionNoIn	::=	LogicalANDExpressionNoIn ( LogicalOROperator LogicalANDExpressionNoIn )*
struct JSLogicalORExpressionNoIn {
    let logicalOROperator: JSLogicalOROperator
    let logicalANDExpressionNoIn: JSLogicalANDExpressionNoIn
}

//LogicalOROperator	::=	"||"
struct JSLogicalOROperator {
    let logicalOROperator: String
}

//ConditionalExpression	::=	LogicalORExpression ( "?" AssignmentExpression ":" AssignmentExpression )?
struct JSConditionalExpression {
    let assignmentExpressionTure: JSAssignmentExpression
    let assignmentExpressionFalse: JSAssignmentExpression
}

//ConditionalExpressionNoIn	::=	LogicalORExpressionNoIn ( "?" AssignmentExpression ":" AssignmentExpressionNoIn )?
struct JSConditionalExpressionNoIn {
    let assignmentExpression: JSAssignmentExpression
    let assignmentExpressionNoIn: JSAssignmentExpressionNoIn
}

//AssignmentExpression	::=	( LeftHandSideExpression AssignmentOperator AssignmentExpression | ConditionalExpression )
struct JSAssignmentExpression {
    let leftHandSideExpression: JSLeftHandSideExpression
    let assignmentOperator: JSAssignmentOperator
}

//AssignmentExpressionNoIn	::=	( LeftHandSideExpression AssignmentOperator AssignmentExpressionNoIn | ConditionalExpressionNoIn )
struct JSAssignmentExpressionNoIn {
    let leftHandSideExpression: JSLeftHandSideExpression
    let assignmentOperator: JSAssignmentOperator
}

//AssignmentOperator	::=	( "=" | "*=" | <SLASHASSIGN> | "%=" | "+=" | "-=" | "<<=" | ">>=" | ">>>=" | "&=" | "^=" | "|=" )
indirect enum JSAssignmentOperator {
    case equal(String)
    case starEqual(String)
    case slashassign(String)
    case percentEqual(String)
    case plusEqual(String)
    case minusEqual(String)
    case agLDoubleEqual(String)
    case agRDoubleEqual(String)
    case agRTripleEqual(String)
    case andEqual(String)
    case upArrowEqual(String)
    case pipeEqual(String)
}

//Expression	::=	AssignmentExpression ( "," AssignmentExpression )*
struct JSExpression {
    let assignmentExpression: JSAssignmentExpression
}

//ExpressionNoIn	::=	AssignmentExpressionNoIn ( "," AssignmentExpressionNoIn )*
struct JSExpressionNoIn {
    let assignmentExpressionNoIn: JSAssignmentExpressionNoIn
}

/*
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
 */
indirect enum JSStatement {
    case block(JSBlock)
    case jscriptVarStatement(JScriptVarStatement)
    case variableStatement(JSVariableStatement)
    case emptyStatement(JSEmptyStatement)
    case labelledStatement(JSLabelledStatement)
    case expressionStatement(JSExpressionStatement)
    case ifStatement(JSIfStatement)
    case IterationStatement(JSIterationStatement)
    case continueStatement(JSContinueStatement)
    case breakStatement(JSBreakStatement)
    case importStatement(JSImportStatement)
    case returnStatement(JSReturnStatement)
    case withStatement(JSWithStatement)
    case switchStatement(JSSwitchStatement)
    case throwStatement(JSThrowStatement)
    case tryStatement(JSTryStatement)
}

//Block	::=	"{" ( StatementList )? "}"
struct JSBlock {
    let statementList: JSStatementList
}

//StatementList	::=	( Statement )+
struct JSStatementList {
    let statementList: [JSStatement]
}

//VariableStatement	::=	"var" VariableDeclarationList ( ";" )?
struct JSVariableStatement {
    let variableDeclarationList: JSVariableDeclarationList
}

//VariableDeclarationList	::=	VariableDeclaration ( "," VariableDeclaration )*
struct JSVariableDeclarationList {
    let variableDeclarationList: [JSVariableDeclaration]
}

//VariableDeclarationListNoIn	::=	VariableDeclarationNoIn ( "," VariableDeclarationNoIn )*
struct JSVariableDeclarationListNoIn {
    let variableDeclarationNoIns: [JSVariableDeclarationNoIn]
}

//VariableDeclaration	::=	Identifier ( Initialiser )?
struct JSVariableDeclaration {
    let identifier: JSIdentifier
    let initialiser: JSInitialiser
}

//VariableDeclarationNoIn	::=	Identifier ( InitialiserNoIn )?
struct JSVariableDeclarationNoIn {
    let identifier: JSIdentifier
    let initialiserNoIn: JSInitialiserNoIn
}

//Initialiser	::=	"=" AssignmentExpression
struct JSInitialiser {
    let assignmentExpression: JSAssignmentExpression
}

//InitialiserNoIn	::=	"=" AssignmentExpressionNoIn
struct JSInitialiserNoIn {
    let assignmentExpressionNoIn: JSAssignmentExpressionNoIn
}

//EmptyStatement	::=	";"
struct JSEmptyStatement {
    let emptyStatement: String
}

//ExpressionStatement	::=	Expression ( ";" )?
struct JSExpressionStatement {
    let expression: JSExpression
}

//IfStatement	::=	"if" "(" Expression ")" Statement ( "else" Statement )?
struct JSIfStatement {
    let expression: JSExpression
    let statement: JSStatement
    let elseStatement: JSStatement
}

/*
 IterationStatement	::=	( "do" Statement "while" "(" Expression ")" ( ";" )? )
 |	( "while" "(" Expression ")" Statement )
 |	( "for" "(" ( ExpressionNoIn )? ";" ( Expression )? ";" ( Expression )? ")" Statement )
 |	( "for" "(" "var" VariableDeclarationList ";" ( Expression )? ";" ( Expression )? ")" Statement )
 |	( "for" "(" "var" VariableDeclarationNoIn "in" Expression ")" Statement )
 |	( "for" "(" LeftHandSideExpressionForIn "in" Expression ")" Statement )
 */
indirect enum JSIterationStatement {
    case typeOne(JSIterationTypeOneStatement)
    case typeTwo(JSIterationTypeTwoStatement)
    case typeThree(JSIterationTypeThreeStatement)
    case typeFour(JSIterationTypeFourStatement)
    case typeFive(JSIterationTypeFiveStatement)
    case typeSix(JSIterationTypeSixStatement)
}
struct JSIterationTypeOneStatement {
    let doStatement: JSStatement
    let whileStatement: JSStatement
}
struct JSIterationTypeTwoStatement {
    let expression: JSExpression
    let statement: JSStatement
}
struct JSIterationTypeThreeStatement {
    let expressionNoIn: JSExpressionNoIn
    let expressionOne: JSExpression
    let expressionTwo: JSExpression
    let statement: JSStatement
}
struct JSIterationTypeFourStatement {
    let variableDeclarationList: JSVariableDeclarationList
    let expressionOne: JSExpression
    let expressionTwo: JSExpression
    let statement: JSStatement
}
struct JSIterationTypeFiveStatement {
    let variableDeclarationNoIn: JSVariableDeclarationNoIn
    let inExpression: JSExpression
    let statement: JSStatement
}
struct JSIterationTypeSixStatement {
    let leftHandSideExpressionForIn: JSLeftHandSideExpressionForIn
    let inExpression: JSExpression
    let statement: JSStatement
}

//ContinueStatement	::=	"continue" ( Identifier )? ( ";" )?
struct JSContinueStatement {
    let identifier: JSIdentifier
}

//BreakStatement	::=	"break" ( Identifier )? ( ";" )?
struct JSBreakStatement {
    let identifier: JSIdentifier
}

//ReturnStatement	::=	"return" ( Expression )? ( ";" )?
struct JSReturnStatement {
    let expression: JSExpression
}

//WithStatement	::=	"with" "(" Expression ")" Statement
struct JSWithStatement {
    let expression: JSExpression
    let statement: JSStatement
}

//SwitchStatement	::=	"switch" "(" Expression ")" CaseBlock
struct JSSwitchStatement {
    let expression: JSExpression
    let caseBlock: JSCaseBlock
}

//CaseBlock	::=	"{" ( CaseClauses )? ( "}" | DefaultClause ( CaseClauses )? "}" )
indirect enum JSCaseBlock {
    case caseClauses(JSCaseClauses)
    case defaultCaseClauses(JSDefaultCaseBlock)
}
struct JSDefaultCaseBlock {
    let defaultClause: JSDefaultClause
    let caseClauses: JSCaseClauses
}

//CaseClauses	::=	( CaseClause )+
struct JSCaseClauses {
    let caseClauses: [JSCaseClause]
}

//CaseClause	::=	( ( "case" Expression ":" ) ) ( StatementList )?
struct JSCaseClause {
    let expression: JSExpression
    let statementList: JSStatementList
}

//DefaultClause	::=	( ( "default" ":" ) ) ( StatementList )?
struct JSDefaultClause {
    let statementList: JSStatementList
}

//LabelledStatement	::=	Identifier ":" Statement
struct JSLabelledStatement {
    let identifier: JSIdentifier
    let statement: JSStatement
}

//ThrowStatement	::=	"throw" Expression ( ";" )?
struct JSThrowStatement {
    let expression: JSExpression
}

//TryStatement	::=	"try" Block ( ( Finally | Catch ( Finally )? ) )
struct JSTryStatement {
    let block: JSBlock
    let tryFinally: JSFinally
    let catchString: JSCatch
    let catchFinally: JSFinally
}

//Catch	::=	"catch" "(" Identifier ")" Block
struct JSCatch {
    let identifier: JSIdentifier
    let block: JSBlock
}

//Finally	::=	"finally" Block
struct JSFinally {
    let block: JSBlock
}

//FunctionDeclaration	::=	"function" Identifier ( "(" ( FormalParameterList )? ")" ) FunctionBody
struct JSFunctionDeclaration {
    let identifier: JSIdentifier
    let formalParameterList: JSFormalParameterList
    let functionBody: JSFunctionBody
}

//FunctionExpression	::=	"function" ( Identifier )? ( "(" ( FormalParameterList )? ")" ) FunctionBody
struct JSFunctionExpression {
    let identifier: JSIdentifier
    let formalParameterList: JSFormalParameterList
    let functionBody: JSFunctionBody
}

//FormalParameterList	::=	Identifier ( "," Identifier )*
struct JSFormalParameterList {
    let identifier: [JSIdentifier]
}

//FunctionBody	::=	"{" ( SourceElements )? "}"
struct JSFunctionBody {
    let sourceElements: JSSourceElements
}

//Program	::=	( SourceElements )? <EOF>
struct JSProgram {
    let sourceElements: JSSourceElements
}

//SourceElements	::=	( SourceElement )+
struct JSSourceElements {
    let sourceElements: [JSSourceElement]
}

/*
 SourceElement	::=	FunctionDeclaration
 |	Statement
 */
indirect enum JSSourceElement {
    case functionDeclaration(JSFunctionDeclaration)
    case statement(JSStatement)
}

//ImportStatement	::=	"import" Name ( "." "*" )? ";"
struct JSImportStatement {
    let name: JSName
}

//Name	::=	<IDENTIFIER_NAME> ( "." <IDENTIFIER_NAME> )*
struct JSName {
    let identifierName: String
}

//JScriptVarStatement	::=	"var" JScriptVarDeclarationList ( ";" )?
struct JScriptVarStatement {
    let jscriptVarDeclarationList: JScriptVarDeclarationList
}

//JScriptVarDeclarationList	::=	JScriptVarDeclaration ( "," JScriptVarDeclaration )*
struct JScriptVarDeclarationList {
    let jscriptVarDeclarations: [JScriptVarDeclaration]
}

//JScriptVarDeclaration	::=	Identifier ":" <IDENTIFIER_NAME> ( Initialiser )?
struct JScriptVarDeclaration {
    let identifier: JSIdentifier
    let identifierName: String
    let initialiser: JSInitialiser
}

//insertSemiColon	::=	java code
struct JSInsertSemiColon {
    let insertSemiColon: String
}











class JSFile {
    
}
