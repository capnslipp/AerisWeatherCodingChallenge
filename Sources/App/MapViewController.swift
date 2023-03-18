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
	@IBOutlet var mapView: MKMapView!
	
	@IBOutlet var radarButton: UIButton!
	@IBOutlet var alertsButton: UIButton!
	@IBOutlet var stormReportsPointsButton: UIButton!
	@IBOutlet var stormReportsHeatmapButton: UIButton!
	
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	
	@IBAction func layerToggleButtonPressed(_ senderButton: UIButton)
	{
		print("\(senderButton) pressed")
	}
}
