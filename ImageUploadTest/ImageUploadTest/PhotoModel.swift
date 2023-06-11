//
//  PhotoModel.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 09/06/2023.
//

import Foundation
import SwiftUI
import PhotosUI
import ImageIO

class PhotoModel: ObservableObject {
  @Published var images: [HashableImage] = []
  
  @Published var imageSelections: [PhotosPickerItem] = [] {
    didSet {
      for item in imageSelections {
        loadTransferable(from: item)
      }
    }
  }
 
  private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
    return imageSelection.loadTransferable(type: TransferableImageWithMetadata.self) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let trans_image?):
          // I want to extract the metadata, compress the image and add the metadata back in
          let hashableImage = HashableImage(id : imageSelection.itemIdentifier,
                                            image: trans_image.image,
                                            metadata: trans_image.metadata)
          if !self.images.contains(hashableImage) {
            self.images.append(hashableImage)
          }
        case .success(nil):
          // TODO: Add states for images
          print("Failed to get image")
        case .failure(let error):
          print("Failed to get image " + error.localizedDescription)
        }
      }
    }
  }
  
  
  
  
  
  func extractGPSData(from imageData: Data) -> CLLocationCoordinate2D? {
    guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else {
      print("Failed to create image source")
      return nil
    }
    
    guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] else {
      print("Failed to extract image properties")
      return nil
    }
    
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
