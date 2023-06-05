//
//  Photo.swift
//  ImageViewer
//
//  Created by Steven Diviney on 04/06/2023.
//

import Foundation

struct Photo: Codable, Identifiable {
  var id: String
  var author: String
  var width: Int
  var height: Int
  var url: String
  var download_url: String
}
