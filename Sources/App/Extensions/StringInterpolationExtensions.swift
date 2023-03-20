//
//  StringInterpolationExtensions.swift
//  App
//
//  Created by Cap'n Slipp on 3/20/23.
//

import Foundation



extension String.StringInterpolation
{
	mutating func appendInterpolation(_ float: some FormattableFloatingPoint, format: String) {
		appendLiteral(String(format: format, float))
	}
}


protocol FormattableFloatingPoint : CVarArg {}
extension Float : FormattableFloatingPoint {}
extension Double : FormattableFloatingPoint {}
#if arch(i386) || arch(x86_64)
	extension Float80 : FormattableFloatingPoint {}
#endif
