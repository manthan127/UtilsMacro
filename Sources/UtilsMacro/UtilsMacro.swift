// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@freestanding(expression)
public macro staticURL(_ value: StaticString) -> URL = #externalMacro(module: "UtilsMacroMacros", type: "StaticURLMacro")

#if canImport(UIKit)
import UIKit

@freestanding(expression)
public macro staticSystemUIImage(_ value: StaticString) -> UIImage = #externalMacro(module: "UtilsMacroMacros", type: "StaticSystemUIImage")

import SwiftUI

@freestanding(expression)
public macro staticSystemImage(_ value: StaticString) -> Image = #externalMacro(module: "UtilsMacroMacros", type: "StaticSystemImage")
#endif
