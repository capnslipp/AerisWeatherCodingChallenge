//
//  WeatherMapView.swift
//  App
//
//  Created by Cap'n Slipp on 3/18/23.
//

import UIKit
import MapKit
import DTMHeatmap
import Collections



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
	
	private var _currentBaseOverlay: MKOverlay_Box? {
		didSet(old) {
			if let old {
				_mkMapView.removeOverlay(old.value)
			}
			if let new = _currentBaseOverlay {
				_mkMapView.insertOverlay(new.value, at: 0, level: .aboveLabels)
			}
		}
	}
	
	private var _currentLayerOverlays: OrderedSet<MKOverlay_Box> {
		get {
			OrderedSet(_mkMapView.overlays.map(MKOverlay_Box.init))
				.subtracting([ _currentBaseOverlay ].compactMap{ $0 })
		}
		set(new) {
			let current = _currentLayerOverlays
			
			let removed = current.subtracting(new)
			_mkMapView.removeOverlays(removed.map{ $0.value })
			
			let additional = new.subtracting(current)
			_mkMapView.addOverlays(additional.map{ $0.value }, level: .aboveLabels)
		}
	}
	
	private var _currentAnnotations: OrderedSet<MKAnnotation_Box> {
		get {
			OrderedSet(_mkMapView.annotations.map(MKAnnotation_Box.init))
		}
		set(new) {
			let current = _currentAnnotations
			
			let removed = current.subtracting(new)
			_mkMapView.removeAnnotations(removed.map{ $0.value })
			
			let additional = new.subtracting(current)
			_mkMapView.addAnnotations(additional.map{ $0.value })
		}
	}
	
	
	
	static let stormReportsAnnotationViewReuseIdentifier = "StormReportsAnnotationView"
	
	var inDarkMode: Bool { self.traitCollection.userInterfaceStyle == .dark }
	
	
	public var baseLayer: (any WeatherMapLayer)? {
		willSet {
			_currentBaseOverlay = nil
		}
		didSet {
			if let layer = self.baseLayer, let overlay = layer.overlay {
				_currentBaseOverlay = MKOverlay_Box(overlay)
			}
		}
	}
	
	public var overlayLayers: [any WeatherMapLayer] {
		willSet {
			_currentLayerOverlays = []
			_currentAnnotations = []
		}
		didSet {
			for layer in self.overlayLayers {
				if let overlay = layer.overlay {
					_currentLayerOverlays.append(MKOverlay_Box(overlay))
				}
			}
			for layer in self.overlayLayers {
				if let annotations = layer.annotations {
					_currentAnnotations.append(contentsOf: annotations.map(MKAnnotation_Box.init))
				}
			}
		}
	}
	
	
	public override init(frame: CGRect)
	{
		super.init(frame: frame)
		
		setUpSubviews()
	}
	
	/// Used by UIKit when unarchiving from a NIB/XIB/Storyboard.
	public required init?(coder:NSCoder)
	{
		super.init(coder: coder)
		
		setUpSubviews()
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
	
	func mapView(_: MKMapView, rendererFor givenOverlay: MKOverlay) -> MKOverlayRenderer
	{
		let givenOverlay = MKOverlay_Box(givenOverlay)
		
		if let baseLayer, let baseLayerOverlay = baseLayer.overlay {
			if givenOverlay == MKOverlay_Box(baseLayerOverlay) {
				if let renderer = baseLayer.overlayRenderer {
					return renderer
				}
			}
		}
		
		if let layer = overlayLayers.first(where: {
			guard let layerOverlay = $0.overlay else { return false }
			return givenOverlay == MKOverlay_Box(layerOverlay)
		}) {
			if let renderer = layer.overlayRenderer {
				return renderer
			}
		}
		
		print("Warning: \(#function) ignoring unhandled overlay \(givenOverlay).")
		return MKPolygonRenderer(polygon: MKPolygon(points: [], count: 0))
	}
	
	func mapView(_ mapView: MKMapView, viewFor givenAnnotation: MKAnnotation) -> MKAnnotationView?
	{
		let givenAnnotation = MKAnnotation_Box(givenAnnotation)
		
		if let baseLayer, let baseLayerAnnotations = baseLayer.annotations {
			if let annotations = baseLayer.annotations {
				if annotations.map(MKAnnotation_Box.init).contains(givenAnnotation) {
					if let renderer = baseLayer.overlayRenderer {
						return renderer
					}
				}
			}
		}
		
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
	func layerOverlay(forLayerState state: LayerState) -> MKOverlay? {
		switch state {
			case .radar:
				return self.radarLayerOverlay
			case .alerts:
				return self.alertsLayerOverlay
			case .stormReportsPoints:
				return nil
			case .stormReportsHeatmap:
				return self.heatmapLayerOverlay
		}
	}
	
	func layerState(forLayerOverlay overlay: MKOverlay) -> LayerState? {
		switch overlay {
			case let tileOverlay as MKTileOverlay where tileOverlay == self.radarLayerOverlay:
				return .radar
			case let tileOverlay as MKTileOverlay where tileOverlay == self.alertsLayerOverlay:
				return .alerts
			case let heatmapOverlay as DTMHeatmap where heatmapOverlay == self.heatmapLayerOverlay:
				return .stormReportsHeatmap
			
			default: return nil
		}
	}
}
