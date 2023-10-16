//
//  MapUtilities.swift
//  AppleMaps
//
//  Created by Quien on 2023-10-15.
//

import Foundation
import MapKit

func performSearch(searchQuery: String, visibleRegion: MKCoordinateRegion?) async throws -> [MKMapItem] {
  let request = MKLocalSearch.Request()
  request.naturalLanguageQuery = searchQuery
  request.resultTypes = .pointOfInterest
  
  guard let region = visibleRegion else { return [] }
  request.region = region
  
  let search = MKLocalSearch(request: request)
  let response = try await search.start()
  
  return response.mapItems
}

func calculateDirections(from source: MKMapItem, to destination: MKMapItem) async -> MKRoute? {
  let directionsRequest = MKDirections.Request()
  directionsRequest.transportType = .automobile
  directionsRequest.source = source
  directionsRequest.destination = destination
  
  let directions = MKDirections(request: directionsRequest)
  let response = try? await directions.calculate()
  return response?.routes.first
}
