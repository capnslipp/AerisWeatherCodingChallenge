//
//  CachingTileOverlay.swift
//  App
//
//  Created by Cap'n Slipp on 3/20/23.
//

import MapKit



class CachingTileOverlay : MKTileOverlay
{
	let _cache = NSCache<NSURL, NSData>()
	let _operationQueue = OperationQueue()
	
	override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void)
	{
		let url = url(forTilePath: path)
		
		// Use cached data for the URL if we have it.
		if let cachedData = _cache.object(forKey: url as NSURL) {
			result(cachedData as Data, nil)
		}
		// Otherwise, make a network request and save it in the cache.
		else {
			let request = URLRequest(url: url)
			URLSession.shared.dataTask(with: request){ [weak self] (data, response, error) in
				guard let data else { return }
				guard let self else { return }
				self._cache.setObject(data as NSData, forKey: url as NSURL)
				result(data, error)
			}
		}
	}
}
