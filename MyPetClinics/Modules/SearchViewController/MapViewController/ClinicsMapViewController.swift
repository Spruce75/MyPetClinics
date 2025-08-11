//
//  ClinicsMapViewController.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 11.8.2025.
//

import UIKit
import MapKit

final class ClinicsMapViewController: UIViewController {
    
    // MARK: - Dependencies
    private let clinicsToDisplay: [VetClinic]
    private let geocodingService: GeocodingServiceProtocol
    private let onClinicSelected: ((VetClinic) -> Void)?
    
    // MARK: - Subviews
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsUserLocation = false
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ClinicMarker")
        return mapView
    }()
    
    private lazy var closeButton = Buttons(
        style: .actionButtonStyle(title: "", systemIconName: "xmark"),
        target: self,
        action: #selector(closeTapped)
    )
    
    // MARK: - Init
    init(
        clinics: [VetClinic],
        geocodingService: GeocodingServiceProtocol = GeocodingService(),
        onClinicSelected: ((VetClinic) -> Void)? = nil
    ) {
        self.clinicsToDisplay = clinics
        self.geocodingService = geocodingService
        self.onClinicSelected = onClinicSelected
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        mapView.delegate = self
        setupViewsAndConstraints()
        addAnnotationsFromClinics()
    }
    
    // MARK: - Actions
    @objc private func closeTapped() { dismiss(animated: true) }
}

// MARK: - Layout
private extension ClinicsMapViewController {
    func setupViewsAndConstraints() {
        [mapView, closeButton].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            closeButton.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
}

// MARK: - Map content
private extension ClinicsMapViewController {
    func addAnnotationsFromClinics() {
        let dispatchGroup = DispatchGroup()
        var createdAnnotations: [MKAnnotation] = []
        
        for clinic in clinicsToDisplay {
            if clinic.hasValidCoordinates {
                let coordinate = CLLocationCoordinate2D(latitude: clinic.latitude, longitude: clinic.longitude)
                let annotation = ClinicMapAnnotation(clinic: clinic, coordinate: coordinate)
                createdAnnotations.append(annotation)
            } else {
                dispatchGroup.enter()
                geocodingService.geocodeAddressString(clinic.fullAddressString) { coordinate in
                    defer { dispatchGroup.leave() }
                    guard let coordinate = coordinate else { return }
                    let annotation = ClinicMapAnnotation(clinic: clinic, coordinate: coordinate)
                    createdAnnotations.append(annotation)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self, !createdAnnotations.isEmpty else { return }
            self.mapView.addAnnotations(createdAnnotations)
            self.zoomToFit(annotations: createdAnnotations)
        }
    }
    
    func zoomToFit(annotations: [MKAnnotation]) {
        var visibleMapRect = MKMapRect.null
        for annotation in annotations {
            let mapPoint = MKMapPoint(annotation.coordinate)
            let tinyRect = MKMapRect(x: mapPoint.x, y: mapPoint.y, width: 0.01, height: 0.01)
            visibleMapRect = visibleMapRect.union(tinyRect)
        }
        mapView.setVisibleMapRect(
            visibleMapRect,
            edgePadding: UIEdgeInsets(top: 80, left: 40, bottom: 80, right: 40),
            animated: true
        )
    }
}

// MARK: - MKMapViewDelegate
extension ClinicsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        guard let clinicAnnotation = annotation as? ClinicMapAnnotation else { return nil }
        
        guard let markerView = mapView.dequeueReusableAnnotationView(
            withIdentifier: "ClinicMarker",
            for: clinicAnnotation
        ) as? MKMarkerAnnotationView else {
            return nil
        }
        
        markerView.canShowCallout = true
        markerView.glyphImage = UIImage(systemName: "stethoscope")
        markerView.markerTintColor = UIColor.systemRed
        
        if #available(iOS 17.0, *) {
            markerView.titleVisibility = .adaptive
            markerView.subtitleVisibility = .adaptive
        }
        
        let detailLabel = UILabel()
        detailLabel.numberOfLines = 0
        detailLabel.font = .systemFont(ofSize: 13)
        detailLabel.text = clinicAnnotation.clinic.websiteURL.absoluteString
        markerView.detailCalloutAccessoryView = detailLabel
        
        let detailDisclosureButton = UIButton(type: .detailDisclosure)
        markerView.rightCalloutAccessoryView = detailDisclosureButton
        
        return markerView
    }
    
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        guard let clinicAnnotation = view.annotation as? ClinicMapAnnotation else { return }
        onClinicSelected?(clinicAnnotation.clinic)
    }
}
