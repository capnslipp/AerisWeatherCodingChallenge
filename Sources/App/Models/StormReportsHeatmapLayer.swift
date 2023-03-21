//
//  HeatmapLayer.swift
//  App
//
//  Created by Cap'n Slipp on 3/20/23.
//

import DTMHeatmap



class StormReportsHeatmapLayer : WeatherMapLayer
{
	private var _stormReports: StormReports
	
	init(stormReports: StormReports) {
		_stormReports = stormReports
	}
	
	
	let isBase = false
	
	
	func refresh(inRegion region: MKCoordinateRegion) {
		self.overlay!.setData({
			let stormReports = StormReports(region: region)
			let reports = stormReports.reports
			let heatmapData = reports.reduce(into: [MKMapPoint:Double](minimumCapacity: reports.count)) { heatmapData, report in
				heatmapData[MKMapPoint(report.coordinate)] = 1.0
			}
			let heatmapData_objc = Dictionary(
				heatmapData.map{ (key: NSValue(mkMapPoint: $0), value: $1 ) },
				uniquingKeysWith: { $1 }
			)
			return heatmapData_objc
		}())
	}
	
	
	var overlay: DTMHeatmap? {
		return DTMHeatmap()
	}
	
	var overlayRenderer: DTMHeatmapRenderer? {
		let renderer = DTMHeatmapRenderer(overlay: self.overlay!)
		#if !targetEnvironment(macCatalyst)
			renderer.blendMode = self.inDarkMode ? .screen : .multiply
		#endif
		return renderer
	}
	
	
	var annotations: [MKAnnotation]? { nil }
	
	
	var inDarkMode: Bool { false }
}
