import Foundation

enum StaticURLMacroError: String, Error, CustomStringConvertible {
    case notAStringLiteral = "Argument is not a string literal"
    case invalidURL = "Argument is not a valid URL"

    public var description: String { rawValue }
}
