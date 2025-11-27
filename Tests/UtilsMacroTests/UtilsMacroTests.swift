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
        "staticURL": StaticURLMacro.self
    ]
    
    func testValidURLExpandsCorrectly() {
        assertMacroExpansion(
            #"#staticURL("https://swift.org")"#,
            expandedSource: #"Foundation.URL(string: "https://swift.org")!"#,
            macros: macros
        )
    }

    func testInvalidURLThrowsError() {
        assertMacroExpansion(
            #"#staticURL("not a url")"#,
            expandedSource: #"Foundation.URL(string: "not a url")!"#,
            diagnostics: [
                DiagnosticSpec(message: "Argument is not a valid URL", line: 1, column: 1)
            ],
            macros: macros
        )
    }

    func testNotAStringLiteral() {
        assertMacroExpansion("#staticURL(123)",
            expandedSource: "#staticURL(123)",
            diagnostics: [
                DiagnosticSpec(message: "Argument is not a string literal", line: 1, column: 1)
            ],
            macros: macros
        )
    }
}

#if canImport(UIKit)
import UIKit
import SwiftUI
extension UtilsMacroTests {
    private let uikitMacros: [String: Macro.Type] = [
        "staticSystemUIImage": StaticSystemUIImage.self,
        "staticSystemImage" : StaticSystemImage.self
    ]
    
    func testChevronUIKit() {
        assertMacroExpansion(
            #"#staticSystemUIImage("chevron.left")"#,
            expandedSource: #"UIKit.UIImage(systemName: "chevron.left")"#,
            macros: uikitMacros
        )
    }
    
    func testChevron() {
        assertMacroExpansion(
            #"#staticSystemImage("chevron.left")"#,
            expandedSource: #"SwiftUI.Image(systemName: "chevron.left")"#,
            macros: uikitMacros
        )
    }
}
#endif

#endif
