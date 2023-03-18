//
//  ViewController.swift
//  AerisWeatherCodingChallenge
//
//  Created by Cap'n Slipp on 3/18/23.
//

import UIKit
import MapKit



class MapViewController : UIViewController, MKMapViewDelegate
{
	enum LayerState {
		case radar
		case alerts
		case stormReportsPoints
		case stormReportsHeatmap
		
		static let `default`: Self = .radar
	}
	var layerState: LayerState = .default
	
	
	@IBOutlet var mapView: MKMapView!
	
	@IBOutlet var radarButton: UIButton!
	@IBOutlet var alertsButton: UIButton!
	@IBOutlet var stormReportsPointsButton: UIButton!
	@IBOutlet var stormReportsHeatmapButton: UIButton!
	
	lazy var allLayerToggleButtons: [UIButton] = [
		self.radarButton,
		self.alertsButton,
		self.stormReportsPointsButton,
		self.stormReportsHeatmapButton,
	]
	
	func layerToggleButtonFor(layerState: LayerState) -> UIButton {
		switch layerState {
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
	
	func layerStateFor(layerToggleButton: UIButton) -> LayerState? {
		switch layerToggleButton {
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
	
	
	
	
	override func viewDidLoad()
	{
		selectLayerToggleButton(forLayerState: self.layerState)
		
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	
	@IBAction func layerToggleButtonPressed(_ senderButton: UIButton)
	{
		guard let layerState = layerStateFor(layerToggleButton: senderButton) else {
			print("Warning: \(#function) ignoring received action from unhandled button \(senderButton).")
			return
		}
		
		self.layerState = layerState
		selectLayerToggleButton(forLayerState: layerState)
	}
	
	func selectLayerToggleButton(forLayerState: LayerState)
	{
		let selectedButton = layerToggleButtonFor(layerState: layerState)
		let otherButtons = self.allLayerToggleButtons.filter{ $0 != selectedButton }
		
		// This could also be accomplished via `UIButton`'s `.changesSelectionAsPrimaryAction`, but we'd still need to un-select the other buttons.
		// In general I prefer to have discrete state transitions all in one place, rather than two systems doing the same thing (can cause state desync). 
		selectedButton.isSelected = true
		otherButtons.forEach{ $0.isSelected = false }
	}
}
