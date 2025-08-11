//
//  ClinicMapAnnotation.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 11.8.2025.
//

import Foundation
import MapKit

final class ClinicMapAnnotation: NSObject, MKAnnotation {
    let clinic: VetClinic
    let coordinate: CLLocationCoordinate2D
    var title: String? { clinic.name }
    var subtitle: String? { "\(clinic.address), \(clinic.city)" }
    
    init(clinic: VetClinic, coordinate: CLLocationCoordinate2D) {
        self.clinic = clinic
        self.coordinate = coordinate
        super.init()
    }
}
