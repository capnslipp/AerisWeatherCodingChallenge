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
	var mapView: MKMapView! {
		guard let view else { return nil }
		guard let mapView = view as? MKMapView else {
			fatalError("\(Self.self) requires its `view` outlet be connected to a `\(MKMapView.self)` instance.")
		}
		return mapView
	}
	
	
	override func viewDidLoad()
	{
		_ = self.mapView // pre-empt typecast check
		
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
}
