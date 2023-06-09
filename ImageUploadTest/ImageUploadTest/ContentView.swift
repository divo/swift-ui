//
//  ContentView.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 07/06/2023.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
  @ObservedObject var viewModel = PhotoModel()
  
  let gridLayout = [
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]
  
  var body: some View {
    VStack {
      PhotosPicker(selection: $viewModel.imageSelections, matching: .images, photoLibrary: .shared()) {
        Text("Select Photos")
      }
      //      ScrollView {
      //        LazyVGrid(columns: gridLayout, spacing: 16) {
      //          ForEach($viewModel.images, id: \.self) { image in
      //            image.wrappedValue
      //              .resizable()
      //              .aspectRatio(contentMode: .fill)
      //              .frame(height: 120)
      //              .clipped()
      //          }
      //        }
      //        .padding(16)
      //      }
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
