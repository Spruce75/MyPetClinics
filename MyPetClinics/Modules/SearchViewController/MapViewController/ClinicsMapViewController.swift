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

    // MARK: - Zoom controls
    private lazy var zoomInButton = Buttons(
        style: .actionButtonStyle(title: "", systemIconName: "plus"),
        target: self,
        action: #selector(zoomInTapped)
    )
    private lazy var zoomOutButton = Buttons(
        style: .actionButtonStyle(title: "", systemIconName: "minus"),
        target: self,
        action: #selector(zoomOutTapped)
    )
    private let zoomControlsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let minimumZoomDistance: CLLocationDistance = 200
    private let maximumZoomDistance: CLLocationDistance = 500_000

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

        if #available(iOS 13.0, *) {
            let range = MKMapView.CameraZoomRange(
                minCenterCoordinateDistance: minimumZoomDistance,
                maxCenterCoordinateDistance: maximumZoomDistance
            )
            mapView.setCameraZoomRange(range, animated: false)
        }
    }

    // MARK: - Actions
    @objc private func closeTapped() {
        if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc private func zoomInTapped()  { adjustZoom(byFactor: 0.5) }  // ближе
    @objc private func zoomOutTapped() { adjustZoom(byFactor: 2.0) }  // дальше
}

// MARK: - Layout
private extension ClinicsMapViewController {
    func setupViewsAndConstraints() {
        [mapView, closeButton, zoomControlsStackView].forEach { view.addSubview($0) }
        [zoomInButton, zoomOutButton].forEach { zoomControlsStackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            closeButton.widthAnchor.constraint(equalToConstant: 32),

            zoomControlsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            zoomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            zoomInButton.widthAnchor.constraint(equalToConstant: 32),
            zoomOutButton.widthAnchor.constraint(equalToConstant: 32)
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
                geocodingService.geocodeAddressString(clinic.fullAddressString) { [weak self] coordinate in
                    defer { dispatchGroup.leave() }
                    guard let _ = self, let coordinate = coordinate else { return }
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
            let point = MKMapPoint(annotation.coordinate)
            let tinyRect = MKMapRect(x: point.x, y: point.y, width: 0.01, height: 0.01)
            visibleMapRect = visibleMapRect.union(tinyRect)
        }
        mapView.setVisibleMapRect(
            visibleMapRect,
            edgePadding: UIEdgeInsets(top: 80, left: 40, bottom: 80, right: 40),
            animated: true
        )
    }

    func adjustZoom(byFactor factor: Double) {
        let current = mapView.camera.centerCoordinateDistance
        let clamped = max(min(current * factor, maximumZoomDistance), minimumZoomDistance)
        let camera = mapView.camera
        camera.centerCoordinateDistance = clamped
        mapView.setCamera(camera, animated: true)
    }

    func openDetails(for clinic: VetClinic) {
        if presentingViewController != nil {
            dismiss(animated: true) { [weak self] in
                self?.onClinicSelected?(clinic)
            }
            return
        }
        if let navigationController = navigationController {
            CATransaction.begin()
            CATransaction.setCompletionBlock { [weak self] in
                self?.onClinicSelected?(clinic)
            }
            navigationController.popViewController(animated: true)
            CATransaction.commit()
            return
        }
        onClinicSelected?(clinic)
    }
}

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
        markerView.markerTintColor = .systemRed
        markerView.titleVisibility = .adaptive
        markerView.subtitleVisibility = .adaptive
        
        let websiteTitle = clinicAnnotation.clinic.websiteURL.absoluteString
        
        let tapAction = UIAction { [weak self] _ in
            self?.openDetails(for: clinicAnnotation.clinic)
        }
        
        let calloutButton: UIButton
        if #available(iOS 15.0, *) {
            var calloutButtonConfiguration = UIButton.Configuration.plain()
            calloutButtonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            calloutButtonConfiguration.title = websiteTitle
            
            var calloutAttributedTitle = AttributedString(websiteTitle)
            calloutAttributedTitle.font = .systemFont(ofSize: 13)
            calloutButtonConfiguration.attributedTitle = calloutAttributedTitle
            calloutButtonConfiguration.baseForegroundColor = .systemBlue
            
            calloutButton = UIButton(configuration: calloutButtonConfiguration, primaryAction: tapAction)
        } else {
            let legacyCalloutButton = UIButton(type: .system)
            legacyCalloutButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            legacyCalloutButton.titleLabel?.font = .systemFont(ofSize: 13)
            legacyCalloutButton.setTitle(websiteTitle, for: .normal)
            legacyCalloutButton.setTitleColor(.systemBlue, for: .normal)
            legacyCalloutButton.addAction(tapAction, for: .touchUpInside)
            calloutButton = legacyCalloutButton
        }
        
        markerView.detailCalloutAccessoryView = calloutButton
        
        let infoButton = UIButton(type: .detailDisclosure)
        markerView.rightCalloutAccessoryView = infoButton
        
        return markerView
    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        guard let clinicAnnotation = view.annotation as? ClinicMapAnnotation else { return }
        openDetails(for: clinicAnnotation.clinic)
    }
}
