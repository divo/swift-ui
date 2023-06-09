//
//  PhotoModel.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 09/06/2023.
//

import Foundation
import SwiftUI
import PhotosUI
import Alamofire

class PhotoModel: ObservableObject {
  @Published var images: [HashableImage] = []
  var ui_images: [UIImage] = []
  
  @Published var imageSelections: [PhotosPickerItem] = [] {
    didSet {
      for item in imageSelections {
        loadTransferable(from: item)
      }
    }
  }
  
  struct TransferableImage: Transferable {
    let image: UIImage
    
    enum TransferError: Error {
      case importFailed
    }
    
    static var transferRepresentation: some TransferRepresentation {
      DataRepresentation(importedContentType: .image) { data in
        guard let uiImage = UIImage(data: data) else {
          throw TransferError.importFailed
          
        }
        return TransferableImage(image: uiImage)
      }
    }
  }
  
  private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
    return imageSelection.loadTransferable(type: TransferableImage.self) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let trans_image?):
          let h_image = HashableImage(id: imageSelection.itemIdentifier, image: Image(uiImage: trans_image.image))
          if !self.images.contains(h_image) {
            self.images.append(h_image)
            self.ui_images.append(trans_image.image)
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
  
  func upload_images() {
    uploadImageToServer(ui_images.first!)
  }
  
  struct DecodableType: Decodable { let url: String }

  private func uploadImageToServer(_ image: UIImage) {
    guard let imageData = image.jpegData(compressionQuality: 0.9) else {
      print("Failed to convert image to data")
      return
    }
    
    let url = "http://192.168.0.88:8000/upload"
//    let url = "https://httpbin.org/post"
//    let url = "https://entayykiw4hk9.x.pipedream.net"

    AF.upload(multipartFormData: { multipartFormData in
      multipartFormData.append(imageData, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
    }, to: url)
    .uploadProgress { progress in
      print("Upload Progress: \(progress.fractionCompleted)")
    }
    .responseDecodable(of: DecodableType.self) { response in
      debugPrint(response)
    }
  }
}
