//
//  BaseLayer.swift
//  App
//
//  Created by Cap'n Slipp on 3/20/23.
//

import MapKit



class BaseLayer : WeatherMapLayer
{
	let isBase = true
	
	
	var overlay: MKTileOverlay? {
		let apiKey = "576c3abd-74af-419b-91d6-847b6e17ce38"
		let styleID = self.inDarkMode ? "alidade_smooth_dark" : "alidade_smooth"
		return CachingTileOverlay(urlTemplate: "https://tiles.stadiamaps.com/tiles/\(styleID)/{z}/{x}/{y}.png?api_key=\(apiKey)")
	}
	
	var overlayRenderer: MKTileOverlayRenderer? {
		let renderer = MKTileOverlayRenderer(tileOverlay: self.overlay!)
		return renderer
	}
	
	
	var annotations: [MKAnnotation]? { nil }
	
	
	var inDarkMode: Bool { false }
}
