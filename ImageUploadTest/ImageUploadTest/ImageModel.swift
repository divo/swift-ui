//
//  HashableImage.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 09/06/2023.
//

import Foundation
import SwiftUI


struct ImageModel: Hashable, Equatable {
  let id: String
  let uiImage: UIImage
  let metadata: [String : Any]?
  let image: Image
  
  init(id: String?, uiImage: UIImage, metadata: [String : Any]?) {
    self.id = id ?? UUID().uuidString
    self.image = Image(uiImage: uiImage) // Doesn't seem to use extra memory, runtime is doing something intelligent
    self.uiImage = uiImage
    self.metadata = metadata
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

   static func ==(lhs: ImageModel, rhs: ImageModel) -> Bool {
    return lhs.id == rhs.id
  }
}

extension ImageModel { 
  func jpegData() -> Data? {
    guard let data = uiImage.jpegData(compressionQuality: 0.9) else {
      print("Unable ebale to encode JPEG data")
      return nil
    }
    return data
  }
}

import CoreLocation

extension ImageModel {
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
