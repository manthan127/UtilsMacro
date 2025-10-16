import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

import Foundation

protocol BaseStringToUrlMacro: ExpressionMacro {
    static func validateInput(string: String) throws
    
    static func returnValue(input: ExprSyntax) -> ExprSyntax
}

extension BaseStringToUrlMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard let argument = node.arguments.first?.expression,
              let literal = argument.as(StringLiteralExprSyntax.self),
              case .stringSegment(let segment) = literal.segments.first
        else {
            throw StaticURLMacroError.notAStringLiteral
        }
        
        try validateInput(string: segment.content.text)
        
        return returnValue(input: argument)
    }
}
