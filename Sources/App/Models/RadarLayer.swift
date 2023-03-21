//
//  RadarLayer.swift
//  App
//
//  Created by Cap'n Slipp on 3/20/23.
//

import MapKit



class RadarLayer : WeatherMapLayer
{
	let isBase = false
	
	
	var overlay: MKTileOverlay? {
		let clientID = "mDDQDYPbqq4PK43usr9HJ"
		let clientSecret = "nEyhFtwTSaCkBDKLpppDEOePPh1qw5qaeyuxYal6"
		return CachingTileOverlay(urlTemplate: "https://maps.aerisapi.com/\(clientID)_\(clientSecret)/radar/{z}/{x}/{y}/current.png")
	}
	
	var overlayRenderer: MKTileOverlayRenderer? {
		let renderer = MKTileOverlayRenderer(tileOverlay: self.overlay!)
		#if !targetEnvironment(macCatalyst)
			renderer.blendMode = self.inDarkMode ? .screen : .multiply
		#endif
		return renderer
	}
	
	
	var annotations: [MKAnnotation]? { nil }
	
	
	var inDarkMode: Bool { false }
}
