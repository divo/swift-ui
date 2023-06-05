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
      if let photos = remote.data {
        List {
          ForEach(photos) { photo in
            Text(photo.author)
          }
        }
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
