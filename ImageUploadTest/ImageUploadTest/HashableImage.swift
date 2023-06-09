//
//  HashableImage.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 09/06/2023.
//

import Foundation
import SwiftUI

struct HashableImage: Hashable, Equatable {
  let id: String
  let image: Image
  
  init(id: String?, image: Image) {
    self.id = id ?? UUID().uuidString
    self.image = image
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func ==(lhs: HashableImage, rhs: HashableImage) -> Bool {
    return lhs.id == rhs.id
  }
}
