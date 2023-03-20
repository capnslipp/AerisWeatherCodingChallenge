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
		enum Error : Swift.Error {
			case annotationIsNotAStormReport
		}
		
		
		public override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
			super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		}
		
		required init?(coder aDecoder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		
		var inDarkMode: Bool { self.traitCollection.userInterfaceStyle == .dark }
		
		public func configureForStormReport() throws
		{
			guard let report = self.annotation as? Report else {
				throw Error.annotationIsNotAStormReport
			}
			
			self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: 10, height: 10))
			
			func style(caLayer: CALayer) {
				let baseColor = report.category.annotationBaseColor
				let borderColor = self.inDarkMode ? baseColor.lightened() : baseColor.darkened()
				
				caLayer.backgroundColor = baseColor.cgColor
				caLayer.cornerRadius = 5
				caLayer.borderWidth = 1.0
				caLayer.borderColor = borderColor.cgColor
			}
			style(caLayer: self.layer)
			
			self.canShowCallout = true
		}
	}
}



extension StormReports.Report.Properties.Report.Cat
{
	var annotationBaseColor: UIColor {
		return UIColor(named: "StormReportAnnotation_\(self.rawValue)")!
	}
}
