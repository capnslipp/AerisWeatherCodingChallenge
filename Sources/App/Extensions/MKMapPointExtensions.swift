//
//  MKMapPointExtensions.swift
//  App
//
//  Created by Cap'n Slipp on 3/20/23.
//

import Foundation
import MapKit



extension MKMapPoint : Hashable, Equatable
{
	public func hash(into hasher: inout Hasher) {
		hasher.combine(self.x)
		hasher.combine(self.y)
	}
	
	public static func == (lhs: MKMapPoint, rhs: MKMapPoint) -> Bool {
		(lhs.x == rhs.x) && (lhs.y == rhs.y)
	}
}
