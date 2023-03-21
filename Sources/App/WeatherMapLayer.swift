//
//  WeatherMapOverlay.Layer.swift
//  App
//
//  Created by Cap'n Slipp on 3/20/23.
//

import Foundation
import MapKit



protocol WeatherMapLayer
{
	var isBase: Bool { get }
	
	
	func refresh(inRegion: MKCoordinateRegion)
	
	
	associatedtype Overlay : MKOverlay
	var overlay: Overlay? { get }
	
	associatedtype OverlayRenderer : MKOverlayRenderer
	var overlayRenderer: OverlayRenderer? { get }
	
	
	associatedtype Annotation : MKAnnotation
	var annotations: [Annotation]? { get }
}


extension WeatherMapLayer
{
	func refresh(inRegion: MKCoordinateRegion) {}
	
	var annotations: [Annotation]? { nil }
}
