//
//  MKOverlayExtensions.swift
//  App
//
//  Created by Cap'n Slipp on 3/20/23.
//

import MapKit



struct MKOverlay_Box
{
	let value: any MKOverlay
	
	init(_ concrete: any MKOverlay) {
		self.value = concrete
	}
}


extension MKOverlay_Box : Hashable
{
	func hash(into hasher: inout Hasher) {
		hasher.combine(self.value.hash)
	}
	
	static func == (lhs: MKOverlay_Box, rhs: MKOverlay_Box) -> Bool {
		lhs.value.isEqual(rhs.value)
	}
}
