//
//  StormReports.swift
//  App
//
//  Created by Cap'n Slipp on 3/19/23.
//

import Foundation
import MapKit



public class StormReports
{
	enum Error : Swift.Error {
		case missingGeoJSONFeatures
		case geoJSONFailed
	}
	
	
	private let _geoJSONDecoder = MKGeoJSONDecoder()
	
	public private(set) var reports: [Report]
	
	public init()
	{
		self.reports = []
	}
	
	func refreshReports(inRegion region: MKCoordinateRegion, reportsUpdatedCallback: @escaping ([Report])->Void)
	{
		reportsUpdatedCallback(self.reports)
		
		let endpointQueryArgs: [String : CustomStringConvertible] = [
			"p": [ region.northernLatitude, region.westernLongitude, region.southernLatitude, region.easternLongitude ]
				.map{ "\($0, format: "%.4f")" }.joined(separator: ","),
			"format": "geojson",
			"from": "-12hours",
			"limit": 250,
			"client_id": "mDDQDYPbqq4PK43usr9HJ",
			"client_secret": "nEyhFtwTSaCkBDKLpppDEOePPh1qw5qaeyuxYal6",
		]
		let endpointURL = URL(string: "https://api.aerisapi.com/stormreports/within")!.appending(
			queryItems: endpointQueryArgs.mapValues{ "\($0)" }.map(URLQueryItem.init)
		)
		
		let dataTask = URLSession.shared.dataTask(with: endpointURL){ [weak self] (data, response, error) in
			guard let self else { return }
			
			guard let data else {
				print("error: network request failed")
				return
			}
			
			let geoJSONObjects = try! self._geoJSONDecoder.decode(data)
			guard let geoJSONFeatures = geoJSONObjects as? [MKGeoJSONFeature] else {
				print("error: missing MKGeoJSONFeature")
				return
			}
			
			self.reports = try! geoJSONFeatures.map(Report.init)
			
			reportsUpdatedCallback(self.reports)
		}
		dataTask.resume()
	}
}



extension Data
{
	var utf8DecodedString: String {
		String(decoding: self, as: UTF8.self)
	}
	
	var jsonObjectDictionary: [String:Any] {
		try! JSONSerialization.jsonObject(with: self, options: []) as! [String:Any]
	}
}
