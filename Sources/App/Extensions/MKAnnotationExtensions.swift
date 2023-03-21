//
//  MKAnnotationExtensions.swift
//  App
//
//  Created by Cap'n Slipp on 3/20/23.
//

import MapKit



struct MKAnnotation_Box
{
	let value: any MKAnnotation
	
	init(_ concrete: any MKAnnotation) {
		self.value = concrete
	}
}


extension MKAnnotation_Box : Hashable
{
	func hash(into hasher: inout Hasher) {
		hasher.combine(self.value.hash)
	}
	
	static func == (lhs: MKAnnotation_Box, rhs: MKAnnotation_Box) -> Bool {
		lhs.value.isEqual(rhs.value)
	}
}
