//
//  LocationError.swift
//  AppleMaps
//
//  Created by Quien on 2023-10-15.
//

import Foundation

enum LocationError: LocalizedError {
  case authorizationRestricted
  case authorizationDenied
  case unknownLocation
  case accessDenied
  case network
  case operationFailed
  
  var errorDescription: String? {
    switch self {
    case .authorizationRestricted:
      return NSLocalizedString("Location access restricted.", comment: "")
    case .authorizationDenied:
      return NSLocalizedString("Location access denied.", comment: "")
    case .unknownLocation:
      return NSLocalizedString("Unknown location.", comment: "")
    case .accessDenied:
      return NSLocalizedString("Access denied.", comment: "")
    case .network:
      return NSLocalizedString("Network failed.", comment: "")
    case .operationFailed:
      return NSLocalizedString("Operation failed.", comment: "")
    }
  }
}
