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
	}
	
	
	private let _geoJSONDecoder = MKGeoJSONDecoder()
	
	public private(set) var reports: [Report]
	
	public init(region: MKCoordinateRegion)
	{
		do {
			print("region: \(region)")
			let endpointQueryArgs: [String : CustomStringConvertible] = [
				"p": [ region.northernLatitude, region.westernLongitude, region.southernLatitude, region.easternLongitude ].map{ "\($0)" }.joined(separator: ","),
				"format": "geojson",
				"from": "-12hours",
				"limit": 250,
				"client_id": "mDDQDYPbqq4PK43usr9HJ",
				"client_secret": "nEyhFtwTSaCkBDKLpppDEOePPh1qw5qaeyuxYal6",
			]
			let endpointURL = URL(string: "https://api.aerisapi.com/stormreports/within")!.appending(
				queryItems: endpointQueryArgs.mapValues{ "\($0)" }.map(URLQueryItem.init)
			)
			print("endpointURL: \(endpointURL)")
			
			let data = try Data(contentsOf: endpointURL)
			let geoJSONObjects = try _geoJSONDecoder.decode(data)
			guard let geoJSONFeatures = geoJSONObjects as? [MKGeoJSONFeature] else {
				throw Error.missingGeoJSONFeatures
			}
			
			try geoJSONObjects.forEach{
				print($0)
				if let feature = $0 as? MKGeoJSONFeature {
					print("\t"+"geometry: \(feature.geometry)")
					print("\t"+"identifier: \(feature.identifier ?? "")")
					if let properties = feature.properties {
						let propertiesString = "\(properties.jsonObjectDictionary)".components(separatedBy: .newlines).map{ "\t\t" + $0 }.joined(separator: "\n")
						print("\t"+"properties:\n\(propertiesString)")
						let reportType = (properties.jsonObjectDictionary as NSDictionary).value(forKeyPath: "report.type")!
						print("\t\t"+"report.type: \(reportType)")
					}
					
					let report = try Report(geoJSONFeature: feature)
					print("report: \(report)")
				}
			}
			
			self.reports = try geoJSONFeatures.map(Report.init)
		} catch let error {
			fatalError("geoJSONDecoder failed: \(error)")
		}
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
