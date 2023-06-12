//
//  TransferableImage.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 11/06/2023.
//

import Foundation
import SwiftUI

struct TransferableImageWithMetadata: Transferable {
  let image: UIImage
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
      let metadata = ImageMetadataUtil.extractMetadata(from: data)
      
      return TransferableImageWithMetadata(image: uiImage, metadata: metadata)
    }
  }
}
