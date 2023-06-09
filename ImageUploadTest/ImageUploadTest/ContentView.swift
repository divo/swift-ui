//
//  ContentView.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 07/06/2023.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
  let readWriteStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
  
  @ObservedObject var viewModel = PhotoModel()
  var body: some View {
    VStack {
      if readWriteStatus != .authorized {
        Button("Allow photo access") {
          PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            // https://developer.apple.com/documentation/photokit/delivering_an_enhanced_privacy_experience_in_your_photos_app
            // TODO: Display status and remind user if it's limited
          }
        }
      }
      PhotosPicker(selection: $viewModel.imageSelections, maxSelectionCount: 150, matching: .images, photoLibrary: .shared()) {
        Text("Select Photos").padding(20)
      }
      
      if !viewModel.image_data.isEmpty {
        Button("Upload images") {
          viewModel.upload_images()
        }.padding(20)
        
      }
      
      List(viewModel.images, id: \.self) { image in
        image.image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(height: 120)
          .clipped()
      }
    }
  }
}
