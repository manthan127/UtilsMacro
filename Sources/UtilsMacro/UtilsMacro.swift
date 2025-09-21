// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@freestanding(expression)
public macro staticURL(_ value: StaticString) -> URL = #externalMacro(module: "UtilsMacroMacros", type: "StaticURLMacro")

@freestanding(expression)
public macro staticBundleURL(_ value: StaticString) -> URL = #externalMacro(module: "UtilsMacroMacros", type: "StaticBundleURLMacro")
