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
import SwiftUI

public struct StaticSystemUIImage: BaseStringToUrlMacro {
    static func validateInput(string: String) throws {
        if UIImage(systemName: string) == nil {
            throw StaticURLMacroError.invalidURL
        }
    }
    
    static func returnValue(input: SwiftSyntax.ExprSyntax) -> SwiftSyntax.ExprSyntax {
        "UIKit.UIImage(systemName: \(input))"
    }
}


public struct StaticSystemImage: BaseStringToUrlMacro {
    static func validateInput(string: String) throws {
        if UIImage(systemName: string) == nil {
            throw StaticURLMacroError.invalidURL
        }
    }
    
    static func returnValue(input: SwiftSyntax.ExprSyntax) -> SwiftSyntax.ExprSyntax {
        "SwiftUI.Image(systemName: \(input))"
    }
}
#endif

@main
struct UtilsMacroPlugin: CompilerPlugin {
#if canImport(UIKit)
    static let extraMacros: [Macro.Type] = [
        StaticSystemUIImage.self,
        StaticSystemImage.self
    ]
#else
    static let extraMacros: [Macro.Type] = []
#endif

    let providingMacros: [Macro.Type] = [
        StaticURLMacro.self,
    ] + UtilsMacroPlugin.extraMacros
}
