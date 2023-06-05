//
//  ContentView.swift
//  ImageViewer
//
//  Created by Steven Diviney on 04/06/2023.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var remote = Remote(url: URL(string: "https://picsum.photos/v2/list")!)
  
  var body: some View {
    NavigationView {
      if !remote.data.isEmpty {
        List {
          ForEach(remote.data) { photo in
            NavigationLink(photo.author, destination: PhotoView(url_string: photo.download_url))
          }
          Rectangle()
            .frame(width: 0, height: 0)
            .onAppear {
            remote.page()
          }
        }.navigationTitle("Photos")
      } else {
        Text("Loading data")
      }
    }.onAppear {
      remote.load()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
