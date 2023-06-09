//
//  ContentView.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 07/06/2023.
//

import SwiftUI
import PhotosUI

class PhotoModel: ObservableObject {
  @Published var imageSelection: PhotosPickerItem? = nil {
    didSet {
      if let imageSelection {
      }
    }
  }
}

struct ContentView: View {
  @ObservedObject var viewModel = PhotoModel()
  
  var body: some View {
    PhotosPicker(selection: $viewModel.imageSelection, matching: .images, photoLibrary: .shared()) {
      Text("Select Photos")
    }
  }
}
