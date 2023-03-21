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
		var degrees = self.center.latitude + (self.span.latitudeDelta * 0.5)
		degrees = min(degrees, 90) // clamp to north pole
		return degrees
	}
	public var southernLatitude: CLLocationDegrees {
		var degrees = self.center.latitude - (self.span.latitudeDelta * 0.5)
		degrees = max(degrees, -90) // clamp to south pole
		return degrees
	}
	
	public var westernLongitude: CLLocationDegrees {
		var degrees = self.center.longitude - (self.span.longitudeDelta * 0.5)
		degrees.formRemainder(dividingBy: 360)
		return degrees
	}
	public var easternLongitude: CLLocationDegrees {
		var degrees = self.center.longitude + (self.span.longitudeDelta * 0.5)
		degrees.formRemainder(dividingBy: 360)
		return degrees
	}
}
