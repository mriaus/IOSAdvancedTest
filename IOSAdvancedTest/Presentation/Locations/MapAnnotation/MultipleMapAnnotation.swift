//
//  MultipleMapAnnotation.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 28/10/23.
//

import Foundation
import MapKit
class MultipleMapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var info: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String? = nil, info: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.info = info
    }
}
