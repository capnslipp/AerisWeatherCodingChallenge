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
	public var layerState: LayerState = .default
	
	
	var mapView: MKMapView!
	
	
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
		let mapView = MKMapView()
		mapView.delegate = self
		
		mapView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(mapView)
		NSLayoutConstraint.activate(
			[
				"H:|-0-[mapView]-0-|",
				"V:|-0-[mapView]-0-|"
			].flatMap{
				NSLayoutConstraint.constraints(withVisualFormat: $0, options: [ .directionLeftToRight ], metrics: nil, views: [ "mapView": mapView ])
			}
		)
		
		self.mapView = mapView
	}
}
