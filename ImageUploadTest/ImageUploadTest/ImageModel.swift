//
//  HashableImage.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 09/06/2023.
//

import Foundation
import SwiftUI
import CoreLocation

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
    
    guard let metadata = self.metadata else {
      return data
    }
    
    return ImageMetadataUtil.writeMetadataToImageData(sourceData: data, metadata: metadata)
  }
}

extension ImageModel {
  func gpsDictionary() -> CLLocationCoordinate2D? {
    guard let imageProperties = metadata else { return nil }
    
    return ImageMetadataUtil.gps(from: imageProperties)
  }
}
