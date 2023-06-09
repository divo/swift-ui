//
//  PhotoModel.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 09/06/2023.
//

import Foundation
import SwiftUI
import PhotosUI

class PhotoModel: ObservableObject {
  @Published var images: [HashableImage] = []
  @Published var imageSelections: [PhotosPickerItem] = [] {
    didSet {
      for item in imageSelections {
        loadTransferable(from: item)
      }
    }
  }
  
  struct TransferableImage: Transferable {
    let image: Image
    
    enum TransferError: Error {
        case importFailed
    }
    
    static var transferRepresentation: some TransferRepresentation {
      DataRepresentation(importedContentType: .image) { data in
#if canImport(AppKit)
        guard let nsImage = NSImage(data: data) else {
          throw TransferError.importFailed
        }
        let image = Image(nsImage: nsImage)
        return ProfileImage(image: image)
#elseif canImport(UIKit)
        guard let uiImage = UIImage(data: data) else {
          throw TransferError.importFailed
          
        }
        let image = Image(uiImage: uiImage)
        return TransferableImage(image: image)
#else
        throw TransferError.importFailed
#endif
      }
    }
  }
  
  private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
    return imageSelection.loadTransferable(type: TransferableImage.self) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let image?):
          let h_image = HashableImage(id: imageSelection.itemIdentifier, image: image.image)
          if !self.images.contains(h_image) {
            self.images.append(h_image)
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
