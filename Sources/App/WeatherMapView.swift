//
//  WeatherMapView.swift
//  App
//
//  Created by Cap'n Slipp on 3/18/23.
//

import UIKit
import MapKit
import DTMHeatmap



class WeatherMapView : UIView, MKMapViewDelegate
{
	enum LayerState {
		case radar
		case alerts
		case stormReportsPoints
		case stormReportsHeatmap
		
		static let `default`: Self = .radar
	}
	public var layerState: LayerState = .default {
		didSet {
			guard self.layerState != oldValue else { return }
			setUpOverlaysForCurrentLayerState()
		}
	}
	
	
	private var _mkMapView: MKMapView!
	
	static let stormReportsAnnotationViewReuseIdentifier = "StormReportsAnnotationView"
	
	var inDarkMode: Bool { self.traitCollection.userInterfaceStyle == .dark }
	
	lazy var baseOverlay: MKTileOverlay = {
		let apiKey = "576c3abd-74af-419b-91d6-847b6e17ce38"
		let styleID = self.inDarkMode ? "alidade_smooth_dark" : "alidade_smooth"
		let overlay = MKTileOverlay(urlTemplate: "https://tiles.stadiamaps.com/tiles/\(styleID)/{z}/{x}/{y}.png?api_key=\(apiKey)")
		overlay.canReplaceMapContent = true
		return overlay
	}()
	lazy var baseOverlayRenderer: MKTileOverlayRenderer = {
		let renderer = MKTileOverlayRenderer(tileOverlay: self.baseOverlay)
		return renderer
	}()
	
	lazy var radarLayerOverlay: MKTileOverlay = {
		let clientID = "mDDQDYPbqq4PK43usr9HJ"
		let clientSecret = "nEyhFtwTSaCkBDKLpppDEOePPh1qw5qaeyuxYal6"
		let overlay = MKTileOverlay(urlTemplate: "https://maps.aerisapi.com/\(clientID)_\(clientSecret)/radar/{z}/{x}/{y}/current.png")
		overlay.canReplaceMapContent = false
		return overlay
	}()
	lazy var radarLayerOverlayRenderer: MKTileOverlayRenderer = {
		let renderer = MKTileOverlayRenderer(tileOverlay: self.radarLayerOverlay)
		#if !targetEnvironment(macCatalyst)
			renderer.blendMode = self.inDarkMode ? .screen : .multiply
		#endif
		return renderer
	}()
	
	lazy var alertsLayerOverlay: MKTileOverlay = {
		let clientID = "mDDQDYPbqq4PK43usr9HJ"
		let clientSecret = "nEyhFtwTSaCkBDKLpppDEOePPh1qw5qaeyuxYal6"
		let overlay = MKTileOverlay(urlTemplate: "https://maps.aerisapi.com/\(clientID)_\(clientSecret)/alerts/{z}/{x}/{y}/current.png")
		overlay.canReplaceMapContent = false
		return overlay
	}()
	lazy var alertsLayerOverlayRenderer: MKTileOverlayRenderer = {
		let renderer = MKTileOverlayRenderer(tileOverlay: self.alertsLayerOverlay)
		#if !targetEnvironment(macCatalyst)
			renderer.blendMode = self.inDarkMode ? .screen : .multiply
		#endif
		return renderer
	}()
	
	
	public override init(frame: CGRect)
	{
		super.init(frame: frame)
		
		setUpSubviews()
		setUpBaseOverlay()
		setUpOverlaysForCurrentLayerState()
	}
	
	/// Used by UIKit when unarchiving from a NIB/XIB/Storyboard.
	public required init?(coder:NSCoder)
	{
		super.init(coder: coder)
		
		setUpSubviews()
		setUpBaseOverlay()
		setUpOverlaysForCurrentLayerState()
	}
	
	func setUpSubviews()
	{
		_mkMapView = {
			let view = MKMapView()
			view.delegate = self
			
			view.register(StormReports.AnnotationView.self, forAnnotationViewWithReuseIdentifier: Self.stormReportsAnnotationViewReuseIdentifier)
			
			view.translatesAutoresizingMaskIntoConstraints = false
			addSubview(view)
			NSLayoutConstraint.activate(
				[
					"H:|-0-[view]-0-|",
					"V:|-0-[view]-0-|"
				].flatMap{
					NSLayoutConstraint.constraints(withVisualFormat: $0, options: [ .directionLeftToRight ], metrics: nil, views: [ "view": view ])
				}
			)
			
			return view
		}()
	}
	
	func setUpBaseOverlay()
	{
		_mkMapView.addOverlay(self.baseOverlay, level: .aboveLabels)
	}
	
	func setUpOverlaysForCurrentLayerState()
	{
		_mkMapView.removeOverlays(self.allLayerOverlays)
		
		if let newOverlay = layerOverlay(forLayerState: self.layerState) {
			// TODO: Remove `if let` once we have all states handled.
			_mkMapView.addOverlay(newOverlay, level: .aboveLabels)
		}
		
		_mkMapView.removeAllAnnotation()
		
		if case .stormReportsPoints = self.layerState {
			let stormReports = StormReports(region: _mkMapView.region)
			print("stormReports.reports.count: \(stormReports.reports.count)")
			_mkMapView.addAnnotations(stormReports.reports)
		}
	}
	
	func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
	{
		if (overlay as? MKTileOverlay) == self.baseOverlay {
			return self.baseOverlayRenderer
		}
		
		switch layerState(forLayerOverlay: overlay) {
			case .radar:
				return self.radarLayerOverlayRenderer
			case .alerts:
				return self.alertsLayerOverlayRenderer
			
			default:
				print("Warning: \(#function) ignoring unhandled overlay \(overlay).")
				return MKPolygonRenderer(polygon: MKPolygon(points: [], count: 0))
		}
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
	{
		if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Self.stormReportsAnnotationViewReuseIdentifier, for: annotation) as? StormReports.AnnotationView {
			try! annotationView.configureForStormReport()
			return annotationView
		}
		
		return nil
	}
}



/// `MKOverlay` ↔ `WeatherMapView.LayerState` Convenience Methods
extension WeatherMapView
{
	var allLayerOverlays: [MKOverlay] {
		[
			self.radarLayerOverlay,
			self.alertsLayerOverlay,
		]
	}
	
	func layerOverlay(forLayerState state: LayerState) -> MKOverlay? {
		switch state {
			case .radar:
				return self.radarLayerOverlay
			case .alerts:
				return self.alertsLayerOverlay
			
			default: return nil
		}
	}
	
	func layerState(forLayerOverlay overlay: MKOverlay) -> LayerState? {
		switch overlay {
			case let tileOverlay as MKTileOverlay where tileOverlay == self.radarLayerOverlay:
				return .radar
			case let tileOverlay as MKTileOverlay where tileOverlay == self.alertsLayerOverlay:
				return .alerts
			
			default: return nil
		}
	}
}



extension MKMapView
{
	func removeAllAnnotation() {
		removeAnnotations(self.annotations)
	}
	
	func removeAllOverlays() {
		removeOverlays(self.overlays)
	}
}
