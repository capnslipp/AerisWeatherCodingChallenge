//
//  HeatmapLayer.swift
//  App
//
//  Created by Cap'n Slipp on 3/20/23.
//

import DTMHeatmap



class StormReportsPointLayer : WeatherMapLayer
{
	private var _stormReports: StormReports
	
	init(stormReports: StormReports) {
		_stormReports = stormReports
	}
	
	
	let isBase = false
	
	
	func refresh(inRegion region: MKCoordinateRegion) {
		_stormReports = StormReports(region: region)
	}
	
	
	var overlay: MKOverlay? { nil }
	
	var overlayRenderer: MKOverlayRenderer? { nil }
	
	
	var annotations: [MKAnnotation]? {
		_stormReports.reports
	}
	
	
	var inDarkMode: Bool { false }
}
