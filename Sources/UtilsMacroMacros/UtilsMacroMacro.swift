import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

import Foundation

protocol BaseStringToUrlMacro: ExpressionMacro {
    static func makeURL(string: String) -> URL?
    
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
        
        guard makeURL(string: segment.content.text) != nil else {
            throw StaticURLMacroError.invalidURL
        }
        
        return returnValue(input: argument)
    }
}

public struct StaticURLMacro: BaseStringToUrlMacro {
    static func makeURL(string: String) -> URL? {
        URL(string: string)
    }
    
    static func returnValue(input: SwiftSyntax.ExprSyntax) -> SwiftSyntax.ExprSyntax {
        "Foundation.URL(string: \(input))!"
    }
}

public struct StaticBundleURLMacro: BaseStringToUrlMacro {
    static func makeURL(string: String) -> URL? {
        Bundle.main.url(forResource: string, withExtension: nil)
    }
    static func returnValue(input: SwiftSyntax.ExprSyntax) -> SwiftSyntax.ExprSyntax {
        "Foundation.Bundle.main.url(forResource: \(input), withExtension: nil)"
    }
}

enum StaticURLMacroError: String, Error, CustomStringConvertible {
    case notAStringLiteral = "Argument is not a string literal"
    case invalidURL = "Argument is not a valid URL"

    public var description: String { rawValue }
}


@main
struct UtilsMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StaticURLMacro.self,
        StaticBundleURLMacro.self
    ]
}
