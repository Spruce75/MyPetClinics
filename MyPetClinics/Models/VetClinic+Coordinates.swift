//
//  VetClinic+Coordinates.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 11.8.2025.
//

import CoreLocation

extension VetClinic {
    var hasValidCoordinates: Bool {
        let isLatitudeValid  = (-90.0...90.0).contains(latitude)
        let isLongitudeValid = (-180.0...180.0).contains(longitude)
        let isNotZeroPair    = !(latitude == 0 && longitude == 0)
        return isLatitudeValid && isLongitudeValid && isNotZeroPair
    }
    
    var fullAddressString: String {
        "\(address), \(postalCode), \(city), \(country)"
    }
}
