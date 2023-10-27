//
//  CharacterAnnotation.swift
//  IOSAdvancedTest
//
//  Created by Marcos on 27/10/23.
//

import Foundation
import MapKit
class CharacterAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var info: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String? = nil, info: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.info = info
    }
}
