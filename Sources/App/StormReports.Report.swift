//
//  StormReports.Report.swift
//  App
//
//  Created by Cap'n Slipp on 3/19/23.
//

import Foundation
import MapKit



extension StormReports
{
	public class Report : NSObject
	{
		enum Error : Swift.Error {
			case missingGeoJSONProperties
		}
		
		
		private var _geoJSONFeature: MKGeoJSONFeature
		
		lazy var geometry: [MKShape] = _geoJSONFeature.geometry
		
		var _properties: Properties
		public var name: String { _properties.report.name }
		public var comments: String? { _properties.report.comments }
		public typealias ReportType = Properties.Report.TypeCode
		public var type: ReportType { _properties.report.code }
		public typealias Category = Properties.Report.Cat
		public var category: Properties.Report.Cat { _properties.report.cat }
		
		
		public init(geoJSONFeature: MKGeoJSONFeature) throws
		{
			_geoJSONFeature = geoJSONFeature
			
			guard let propertiesData = _geoJSONFeature.properties else {
				throw Error.missingGeoJSONProperties
			}
			_properties = try Properties.fromJSON(data: propertiesData)
		}
	}
}


extension StormReports.Report : MKAnnotation
{
	public var coordinate: CLLocationCoordinate2D { self.geometry.first!.coordinate }
	
	public var title: String? { "\(self.type)".capitalized }
	
	public var subtitle: String? {
		var subtitle = self.name
		if let comments {
			subtitle += " — \(comments)"
		}
		return subtitle
	}
}


extension StormReports.Report
{
	public struct Properties : Decodable
	{
		public var id: String
		
		public var report: Report
		public struct Report : Decodable
		{
			public var name: String
			
			public var comments: String?
			
			public var code: TypeCode
			public enum TypeCode : String, Codable {
				case hurricane = "0"
				case stormSurge = "1"
				case dustStorm = "2"
				case sprinkles = "3"
				case highAstronomicalWinds = "4"
				case freezingRain = "5"
				case freezeTemperature = "6"
				case extremeWindChill = "7"
				case wildfire_8 = "8"
				case seiche = "9"
				case highSustainedWinds = "A"
				case downburst = "B"
				case funnelCloud = "C"
				case thunderstormWindDamage = "D"
				case flood = "E"
				case flashFlood = "F"
				case thunderstormWindGust = "G"
				case hail = "H"
				case excessiveHeat = "I"
				case denseFog = "J"
				case lightning = "L"
				case marineThunderstormWind = "M"
				case nonThunderstormWindGust = "N"
				case nonThunderstormWindDamage = "O"
				case ripCurrents = "P"
				case tropicalStorm = "Q"
				case heavyRain = "R"
				case snowHeavySnow = "S"
				case tornado = "T"
				case wildfire_U = "U"
				case avalanche = "V"
				case waterSpout = "W"
				case wallCloud = "X"
				case blizzard = "Z"
				case blowingSnow = "a"
				case sleet = "s"
				case sneakerWave = "t"
				case lakeshoreFlood = "u"
				case coastalFlood = "v"
				case debrisFlow = "x"
				case volcanicAshfall = "z"
				
				case stormCodeWasNotReported = "None"
			}
			
			public var cat: Cat
			public enum Cat : String, Decodable {
				case avalanche
				case blizzard
				case dust
				case fire
				case flood
				case fog
				case hail
				case ice
				case lightning
				case marine
				case rain
				case snow
				case tides
				case tornado
				case tropical
				case wind
				case other
			}
		}
	}
}


extension StormReports.Report.Properties
{
	static func fromJSON(data: Data) throws -> Self {
		let decoder = JSONDecoder()
		return try decoder.decode(Self.self, from: data)
	}
}


extension StormReports.Report.Properties.Report.TypeCode : CustomStringConvertible
{
	public var description: String {
		switch self {
			case .hurricane: return "hurricane"
			case .stormSurge: return "storm surge"
			case .dustStorm: return "dust storm"
			case .sprinkles: return "sprinkles"
			case .highAstronomicalWinds: return "high astronomical winds"
			case .freezingRain: return "freezing rain"
			case .freezeTemperature: return "freeze (temperature)"
			case .extremeWindChill: return "extreme wind chill"
			case .wildfire_8: return "wildfire"
			case .seiche: return "seiche"
			case .highSustainedWinds: return "high sustained winds"
			case .downburst: return "downburst"
			case .funnelCloud: return "funnel cloud"
			case .thunderstormWindDamage: return "thunderstorm wind damage"
			case .flood: return "flood"
			case .flashFlood: return "flash flood"
			case .thunderstormWindGust: return "thunderstorm wind gust"
			case .hail: return "hail"
			case .excessiveHeat: return "excessive heat"
			case .denseFog: return "dense fog"
			case .lightning: return "lightning"
			case .marineThunderstormWind: return "marine thunderstorm wind"
			case .nonThunderstormWindGust: return "non-thunderstorm wind gust"
			case .nonThunderstormWindDamage: return "non-thunderstorm wind damage"
			case .ripCurrents: return "rip currents"
			case .tropicalStorm: return "tropical storm"
			case .heavyRain: return "heavy rain"
			case .snowHeavySnow: return "snow / heavy snow"
			case .tornado: return "tornado"
			case .wildfire_U: return "wildfire"
			case .avalanche: return "avalanche"
			case .waterSpout: return "water spout"
			case .wallCloud: return "wall cloud"
			case .blizzard: return "blizzard"
			case .blowingSnow: return "blowing snow"
			case .sleet: return "sleet"
			case .sneakerWave: return "sneaker wave"
			case .lakeshoreFlood: return "lakeshore flood"
			case .coastalFlood: return "coastal flood"
			case .debrisFlow: return "debris flow"
			case .volcanicAshfall: return "volcanic ashfall"
			
			case .stormCodeWasNotReported: return "storm code was not reported"
		}
	}
	
}
