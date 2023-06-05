//
//  PhotoView.swift
//  ImageViewer
//
//  Created by Steven Diviney on 05/06/2023.
//

import SwiftUI

struct PhotoView: View {
  let url: URL
  
  init(url_string: String) {
    self.url = URL(string: url_string)! // Handle better
  }
  
  var body: some View {
    VStack {
      // TODO: Implement own version of this
      AsyncImage(url: url) { image in
        image.resizable().aspectRatio(contentMode: .fit)
      } placeholder: {
        ProgressView()
      }
    }
  }
}
