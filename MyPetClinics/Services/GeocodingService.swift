//
//  GeocodingService.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 11.8.2025.
//

import CoreLocation

protocol GeocodingServiceProtocol: AnyObject {
    func geocodeAddressString(_ addressString: String, completion: @escaping (CLLocationCoordinate2D?) -> Void)
}

final class GeocodingService: GeocodingServiceProtocol {
    private let geocoder = CLGeocoder()
    private var coordinatesCache: [String: CLLocationCoordinate2D] = [:]
    private let geocodingQueue = DispatchQueue(label: "GeocodingService.queue", qos: .userInitiated)
    
    func geocodeAddressString(_ addressString: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        if let cached = coordinatesCache[addressString] {
            completion(cached)
            return
        }
        geocodingQueue.async { [weak self] in
            guard let self = self else { return }
            self.geocoder.geocodeAddressString(addressString) { placemarks, _ in
                let coordinate = placemarks?.first?.location?.coordinate
                if let coordinate = coordinate {
                    self.coordinatesCache[addressString] = coordinate
                }
                DispatchQueue.main.async { completion(coordinate) }
            }
        }
    }
}
