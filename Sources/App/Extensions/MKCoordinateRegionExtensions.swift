//
//  MKCoordinateRegionExtensions.swift
//  App
//
//  Created by Cap'n Slipp on 3/19/23.
//

import MapKit



extension MKCoordinateRegion
{
	public var northernLatitude: CLLocationDegrees {
		self.center.latitude + (self.span.latitudeDelta * 0.5)
	}
	public var southernLatitude: CLLocationDegrees {
		self.center.latitude - (self.span.latitudeDelta * 0.5)
	}
	
	public var westernLongitude: CLLocationDegrees {
		self.center.longitude - (self.span.longitudeDelta * 0.5)
	}
	public var easternLongitude: CLLocationDegrees {
		self.center.longitude + (self.span.longitudeDelta * 0.5)
	}
}
