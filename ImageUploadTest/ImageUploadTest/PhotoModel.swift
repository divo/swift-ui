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
import ImageIO

class PhotoModel: ObservableObject {
  @Published var images: [HashableImage] = []
  var image_data: [Data] = []
  
  @Published var imageSelections: [PhotosPickerItem] = [] {
    didSet {
      for item in imageSelections {
        loadTransferable(from: item)
      }
    }
  }
  
  struct TransferableImage: Transferable {
    let image: UIImage
    let data: Data
    
    enum TransferError: Error {
      case importFailed
    }
    
    static var transferRepresentation: some TransferRepresentation {
      DataRepresentation(importedContentType: .image) { data in
        guard let uiImage = UIImage(data: data) else {
          throw TransferError.importFailed
          
        }
        return TransferableImage(image: uiImage, data: data)
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
            self.image_data.append(trans_image.data)
            self.extractGPSData(from: trans_image.data)
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
    uploadImageToServer(image_data.first!)
  }
  
  struct DecodableType: Decodable { let url: String }
  
  private func uploadImageToServer(_ imageData: Data) {
    let url = "http://192.168.0.88:8000/upload"
    let ui_image = UIImage(data: imageData)
    
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
