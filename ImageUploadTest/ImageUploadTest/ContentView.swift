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
  let client = Client()
  
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
      
      if !viewModel.images.isEmpty {
        Button("Upload images") {
//          client.uploadImagesToServer()
        }.padding(20)
        
      }
      
      List(viewModel.images, id: \.self) { image in
        HStack {
          image.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 250)
            .clipped()
          
          if let gps = image.gpsDictionary() {
            MapView(coordinate: gps)
              .frame(height: 200)
          }
        }
      }
    }
  }
}
