//
//  LocationManager.swift
//  AppleMaps
//
//  Created by Quien on 2023-10-15.
//

import Foundation
import MapKit
import Observation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
  let manager = CLLocationManager()
  var region: MKCoordinateRegion = MKCoordinateRegion()
  var error: LocationError? = nil
  
  static let shared = LocationManager()
  
  private override init() {
    super.init()
    self.manager.delegate = self
  }
}

extension LocationManager {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locations.last.map {
      region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
          latitude: $0.coordinate.latitude,
          longitude: $0.coordinate.longitude),
        span: MKCoordinateSpan(
          latitudeDelta: 0.05,
          longitudeDelta: 0.05)
      )
    }
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .notDetermined:
      manager.requestWhenInUseAuthorization()
    case .authorizedAlways, .authorizedWhenInUse:
      manager.requestLocation()
    case .restricted:
      error = .authorizationRestricted
    case .denied:
      error = .authorizationDenied
    @unknown default:
      break
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    if let clError = error as? CLError {
      switch clError.code {
      case .locationUnknown:
        self.error = .unknownLocation
      case .denied:
        self.error = .accessDenied
      case .network:
        self.error = .network
      default:
        self.error = .operationFailed
      }
    }
  }
  
}
