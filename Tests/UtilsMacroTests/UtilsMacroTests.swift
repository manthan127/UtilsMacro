import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(UtilsMacroMacros)
import UtilsMacroMacros

final class UtilsMacroTests: XCTestCase {
    private let macros: [String: Macro.Type] = [
        "StaticURL": StaticURLMacro.self,
        "StaticBundleURL": StaticBundleURLMacro.self
    ]
    
    func testValidURLExpandsCorrectly() {
        assertMacroExpansion(
            """
            #StaticURL("https://swift.org")
            """,
            expandedSource: """
            Foundation.URL(string: "https://swift.org")!
            """,
            macros: macros
        )
    }

    func testInvalidURLThrowsError() {
        assertMacroExpansion(
            """
            #StaticURL("not a url")
            """,
            expandedSource: """
            Foundation.URL(string: "not a url")!
            """,
            diagnostics: [
                DiagnosticSpec(message: "Argument is not a valid URL", line: 1, column: 1)
            ],
            macros: macros
        )
    }

    func testNotAStringLiteral() {
        assertMacroExpansion("#StaticURL(123)",
            expandedSource: "#StaticURL(123)",
            diagnostics: [
                DiagnosticSpec(message: "Argument is not a string literal", line: 1, column: 1)
            ],
            macros: macros
        )
    }
}

#endif
