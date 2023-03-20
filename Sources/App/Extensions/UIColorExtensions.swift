//
//  UIColorExtensions.swift
//  App
//
//  Created by Cap'n Slipp on 3/20/23.
//

import UIKit



extension UIColor
{
	enum Error : Swift.Error {
		case notAnHSBCompatibleColor
	}
	
	
	func lightened(by amount: CGFloat = 0.25) -> UIColor {
		return try! hsbColorWithBrightness(modifier: 1.0 + amount)
	}
	
	func darkened(by amount: CGFloat = 0.25) -> UIColor {
		return try! hsbColorWithBrightness(modifier: 1.0 - amount)
	}
	
	private func hsbColorWithBrightness(modifier: CGFloat) throws -> UIColor
	{
		var channels = ( h: CGFloat(), s: CGFloat(), b: CGFloat(), a: CGFloat() )
		guard getHue(&channels.h, saturation: &channels.s, brightness: &channels.b, alpha: &channels.a) else {
			throw Error.notAnHSBCompatibleColor
		}
		
		return UIColor(
			hue: channels.h,
			saturation: channels.s,
			brightness: channels.b * modifier,
			alpha: channels.a
		)
	}
}
