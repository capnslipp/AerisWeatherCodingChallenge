//
//  Secrets.swift
//  App
//
//  Created by Cap'n Slipp on 3/21/23.
//

import Foundation



struct Secrets
{
	init() { fatalError("\(Self.self) is static-only") }
	
	
	static let AerisWeatherClientID = "FILL_IN_WITH_CLIENT_ID"
	static let AerisWeatherClientSecret = "FILL_IN_WITH_CLIENT_SECRET"
	
	
	static let StadiaMapsAPIKey = "FILL_IN_WITH_API_KEY"
}
