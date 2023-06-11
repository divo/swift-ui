//
//  Client.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 11/06/2023.
//

import Foundation
import Alamofire
import PhotosUI

struct DecodableType: Decodable { let url: String }

class Client {
  public func uploadImagesToServer(_ imageData: [String : Data]) {
    let url = "http://192.168.0.88:8000/upload"
    
    AF.upload(multipartFormData: { multipartFormData in
      imageData.forEach { (name: String, imageData: Data) in
        multipartFormData.append(imageData, withName: "file", fileName: name, mimeType: "image/jpeg")
      }
    }, to: url)
    .uploadProgress { progress in
      print("Upload Progress: \(progress.fractionCompleted)")
    }
    .responseDecodable(of: DecodableType.self) { response in
      debugPrint(response)
    }
  }
}
