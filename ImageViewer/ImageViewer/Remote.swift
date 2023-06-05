//
//  Remote.swift
//  ImageViewer
//
//  Created by Steven Diviney on 04/06/2023.
//

import Foundation

class Remote: ObservableObject {
  var urlComponents : URLComponents
  var current_page = 0
  
  @Published var data: [Photo] = []
  
  init(url: URL) {
    self.urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
  }
  
  func load(page: Int = 0) {
    let query = URLQueryItem(name: "page", value: String(page))
    urlComponents.queryItems = [query]
    URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
      if let data = data {
        if let decodedResponse = try? JSONDecoder().decode([Photo].self, from: data) {
          DispatchQueue.main.async {
            self.data += decodedResponse
          }
          return
        }
      }
    }.resume()
  }
  
  func page() {
    current_page += 1
    load(page: current_page)
  }
}
