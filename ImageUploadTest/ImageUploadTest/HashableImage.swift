//
//  HashableImage.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 09/06/2023.
//

import Foundation
import SwiftUI

struct HashableImage: Hashable, Equatable {
  let id: String
  let image: Image
  let metadata: [String : Any]?
  
  init(id: String?, image: Image, metadata: [String : Any]?) {
    self.id = id ?? UUID().uuidString
    self.image = image
    self.metadata = metadata
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func ==(lhs: HashableImage, rhs: HashableImage) -> Bool {
    return lhs.id == rhs.id
  }
}

import CoreLocation

extension HashableImage {
  func gpsDictionary() -> CLLocationCoordinate2D? {
    guard let imageProperties = metadata else { return nil }
    
    if let gpsDictionary = imageProperties[kCGImagePropertyGPSDictionary as String] as? [String: Any],
       let latitudeRef = gpsDictionary[kCGImagePropertyGPSLatitudeRef as String] as? String,
       let latitude = gpsDictionary[kCGImagePropertyGPSLatitude as String] as? Double,
       let longitudeRef = gpsDictionary[kCGImagePropertyGPSLongitudeRef as String] as? String,
       let longitude = gpsDictionary[kCGImagePropertyGPSLongitude as String] as? Double {
      
      var coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      
      if latitudeRef == "S" {
        coordinate.latitude *= -1
      }
      
      if longitudeRef == "W" {
        coordinate.longitude *= -1
      }
      
      return coordinate
    }
    
    return nil
  }
}
