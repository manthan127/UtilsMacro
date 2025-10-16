import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

import Foundation

public struct StaticURLMacro: BaseStringToUrlMacro {
    static func validateInput(string: String) throws {
        if URL(string: string) == nil {
            throw StaticURLMacroError.invalidURL
        }
    }
    
    static func returnValue(input: SwiftSyntax.ExprSyntax) -> SwiftSyntax.ExprSyntax {
        "Foundation.URL(string: \(input))!"
    }
}

#if canImport(UIKit)
import UIKit

public struct StaticSystemImage: BaseStringToUrlMacro {
    static func validateInput(string: String) throws {
        if UIImage(systemName:  string) == nil {
            throw StaticURLMacroError.invalidURL
        }
    }
    
    static func returnValue(input: SwiftSyntax.ExprSyntax) -> SwiftSyntax.ExprSyntax {
        "UIKit.UIImage(systemName: \(input))"
    }
}
#endif

@main
struct UtilsMacroPlugin: CompilerPlugin {
#if canImport(UIKit)
    static let extraMacros: [Macro.Type] = [
        StaticSystemImage.self
    ]
#else
    static let extraMacros: [Macro.Type] = []
#endif

    let providingMacros: [Macro.Type] = [
        StaticURLMacro.self,
    ] + UtilsMacroPlugin.extraMacros
}
