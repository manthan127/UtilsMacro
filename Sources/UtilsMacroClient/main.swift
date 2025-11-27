import UtilsMacro
import Foundation

print(#staticURL("not a url"))

#if canImport(UIKit)
import UIKit

let image = #staticSystemUIImage("chevron.left")
#endif
