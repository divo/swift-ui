//
//  Remote.swift
//  ImageViewer
//
//  Created by Steven Diviney on 04/06/2023.
//

import Foundation

class Remote: ObservableObject {
  let url : URL
  @Published var data: [Photo]?
  
  init(url: URL) {
    self.url = url
    self.data = nil
  }
  
  func load() {
    URLSession.shared.dataTask(with: url) { data, response, error in
      if let data = data {
        if let decodedResponse = try? JSONDecoder().decode([Photo].self, from: data) {
          DispatchQueue.main.async {
            self.data = decodedResponse
          }
          return
        }
      }
    }.resume()
  }
}
