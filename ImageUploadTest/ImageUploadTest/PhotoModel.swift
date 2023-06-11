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
}
