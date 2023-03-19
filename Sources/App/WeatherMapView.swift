//
//  WeatherMapView.swift
//  App
//
//  Created by Cap'n Slipp on 3/18/23.
//

import UIKit
import MapKit



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
	
	
	var mapView: MKMapView!
	
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
			renderer.blendMode = .multiply
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
		setUpOverlaysForCurrentLayerState()
	}
	
	/// Used by UIKit when unarchiving from a NIB/XIB/Storyboard.
	public required init?(coder:NSCoder)
	{
		super.init(coder: coder)
		
		setUpSubviews()
		setUpOverlaysForCurrentLayerState()
	}
	
	func setUpSubviews()
	{
		let mapView = MKMapView()
		mapView.delegate = self
		
		mapView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(mapView)
		NSLayoutConstraint.activate(
			[
				"H:|-0-[view]-0-|",
				"V:|-0-[view]-0-|"
			].flatMap{
				NSLayoutConstraint.constraints(withVisualFormat: $0, options: [ .directionLeftToRight ], metrics: nil, views: [ "view": mapView ])
			}
		)
		
		self.mapView = mapView
	}
	
	func setUpOverlaysForCurrentLayerState()
	{
		self.mapView.removeOverlays(self.allLayerOverlays)
		
		if let newOverlay = layerOverlay(forLayerState: self.layerState) {
			// TODO: Remove `if let` once we have all states handled.
			self.mapView.addOverlay(newOverlay, level: .aboveRoads)
		}
	}
	
	func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
	{
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
