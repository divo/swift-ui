//
//  ImageMetadataUtil.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 12/06/2023.
//

import Foundation
import ImageIO
import CoreLocation
import UniformTypeIdentifiers

struct ImageMetadataUtil {
  public static func extractMetadata(from imageData: Data) -> [String: Any]? {
    guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else {
      print("Failed to create image source")
      return nil
    }
    
    // Using index 0 needed to get all the properties, docs aren't helpful.
    guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] else {
      print("Failed to extract image properties")
      return nil
    }
    
    return imageProperties
  }
  
  public static func gps(from metaData: [String : Any]) -> CLLocationCoordinate2D? {
    if let gpsDictionary = metaData[kCGImagePropertyGPSDictionary as String] as? [String: Any],
       let latitudeRef = gpsDictionary[kCGImagePropertyGPSLatitudeRef as String] as? String,
       let latitude = gpsDictionary[kCGImagePropertyGPSLatitude as String] as? Double,
       let longitudeRef = gpsDictionary[kCGImagePropertyGPSLongitudeRef as String] as? String,
       let longitude = gpsDictionary[kCGImagePropertyGPSLongitude as String] as? Double {
      
      var coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      
      if latitudeRef == "S" {
        coordinate.latitude *= -1
      }
      
      if longitudeRef == "W" {
        coordinate.longitude *= -1
      }
      
      return coordinate
    }
    
    return nil
  }
  
  public static func writeMetadataToImageData(sourceData: Data, metadata: [String: Any]) -> Data {
    let outputData = NSMutableData() // Create source to read from and destination to update
    guard let imageSource = CGImageSourceCreateWithData(sourceData as CFData, nil),
          let imageDestination = CGImageDestinationCreateWithData(outputData, UTType.jpeg.identifier as CFString, 1, nil)
    else {
      print("Failed to create image source or destination")
      return sourceData
    }
    
    let mutableMetadata = NSMutableDictionary(dictionary: metadata)
    
    // Add existing metadata to preserve it
    if let currentMetadata = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) {
      mutableMetadata.addEntries(from: currentMetadata as! [AnyHashable: Any])
    }
    
    CGImageDestinationAddImageFromSource(imageDestination, imageSource, 0, mutableMetadata)
    
    if CGImageDestinationFinalize(imageDestination) {
      return outputData as Data
    } else {
      print("Failed to write metadata to the image")
      return sourceData
    }
  }
}
