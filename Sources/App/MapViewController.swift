//
//  ViewController.swift
//  AerisWeatherCodingChallenge
//
//  Created by Cap'n Slipp on 3/18/23.
//

import UIKit
import MapKit



class MapViewController : UIViewController
{
	@IBOutlet var mapView: WeatherMapView!
	
	@IBOutlet var radarButton: UIButton!
	@IBOutlet var alertsButton: UIButton!
	@IBOutlet var stormReportsPointsButton: UIButton!
	@IBOutlet var stormReportsHeatmapButton: UIButton!
	
	typealias LayerState = WeatherMapView.LayerState
	var layerState: LayerState {
		get { self.mapView.layerState }
		set { self.mapView.layerState = newValue }
	}
	
	
	
	override func viewDidLoad()
	{
		selectLayerToggleButton(forLayerState: self.layerState)
		
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	
	@IBAction func layerToggleButtonPressed(_ senderButton: UIButton)
	{
		guard let layerState = layerState(forLayerToggleButton: senderButton) else {
			print("Warning: \(#function) ignoring received action from unhandled button \(senderButton).")
			return
		}
		
		self.layerState = layerState
		selectLayerToggleButton(forLayerState: layerState)
	}
	
	func selectLayerToggleButton(forLayerState: LayerState)
	{
		let selectedButton = layerToggleButton(forLayerState: self.layerState)
		let otherButtons = self.allLayerToggleButtons.filter{ $0 != selectedButton }
		
		// This could also be accomplished via `UIButton`'s `.changesSelectionAsPrimaryAction`, but we'd still need to un-select the other buttons.
		// In general I prefer to have discrete state transitions all in one place, rather than two systems doing the same thing (can cause state desync). 
		selectedButton.isSelected = true
		otherButtons.forEach{ $0.isSelected = false }
	}
}


/// `UIButton` ↔ `WeatherMapView.LayerState` Convenience Methods
extension MapViewController
{
	var allLayerToggleButtons: [UIButton] {
		[
			self.radarButton,
			self.alertsButton,
			self.stormReportsPointsButton,
			self.stormReportsHeatmapButton,
		]
	}
	
	func layerToggleButton(forLayerState state: LayerState) -> UIButton {
		switch state {
			case .radar:
				return self.radarButton
			case .alerts:
				return self.alertsButton
			case .stormReportsPoints:
				return self.stormReportsPointsButton
			case .stormReportsHeatmap:
				return self.stormReportsHeatmapButton
		}
	}
	
	func layerState(forLayerToggleButton button: UIButton) -> LayerState? {
		switch button {
			case self.radarButton:
				return .radar
			case self.alertsButton:
				return .alerts
			case self.stormReportsPointsButton:
				return .stormReportsPoints
			case self.stormReportsHeatmapButton:
				return .stormReportsHeatmap
			
			default: return nil
		}
	}
}
