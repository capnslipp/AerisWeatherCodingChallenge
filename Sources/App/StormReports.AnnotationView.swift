//
//  StormReports.AnnotationView.swift
//  App
//
//  Created by Cap'n Slipp on 3/19/23.
//

import Foundation
import MapKit



extension StormReports
{
	public class AnnotationView : MKAnnotationView
	{
		public override init(annotation: MKAnnotation?, reuseIdentifier: String?)
		{
			super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
			
			self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: 10, height: 10))
			
			func style(caLayer: CALayer) {
				caLayer.backgroundColor = UIColor(hue: 210.0 / 360, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
				caLayer.cornerRadius = 5
				caLayer.borderWidth = 1.0
				caLayer.borderColor = UIColor(hue: 210.0 / 360, saturation: 1.0, brightness: 0.8, alpha: 1.0).cgColor
			}
			style(caLayer: self.layer)
			
			self.canShowCallout = true
		}
		
		
		required init?(coder aDecoder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}
