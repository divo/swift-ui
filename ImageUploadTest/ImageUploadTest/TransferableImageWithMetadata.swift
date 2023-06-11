//
//  TransferableImage.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 11/06/2023.
//

import Foundation
import SwiftUI

struct TransferableImageWithMetadata: Transferable {
  let image: Image
  let metadata: [String : Any]?
  
  enum TransferError: Error {
    case importFailed
  }
  
  // Load the image, extract the metadata, compress it and save metadata again
  static var transferRepresentation: some TransferRepresentation {
    DataRepresentation(importedContentType: .image) { data in
      guard let uiImage = UIImage(data: data) else {
        throw TransferError.importFailed
      }
      
      let image = Image(uiImage: uiImage)
      let metadata = extractMetadata(from: data)
      
      return TransferableImageWithMetadata(image: image, metadata: metadata)
    }
  }
  
  private static func extractMetadata(from imageData: Data) -> [String: Any]? {
    guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else {
      print("Failed to create image source")
      return nil
    }
    
    guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] else {
      print("Failed to extract image properties")
      return nil
    }
    
    return imageProperties
  }
}
