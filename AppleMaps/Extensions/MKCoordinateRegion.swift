//
//  MKCoordinateRegion.swift
//  AppleMaps
//
//  Created by Quien on 2023-10-15.
//

import Foundation
import MapKit

extension MKCoordinateRegion: Equatable {
  
  public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
    if lhs.center.latitude == rhs.center.latitude &&
        lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
        lhs.span.longitudeDelta == rhs.span.longitudeDelta {
      return true
    }
    return false
  }
  
}
