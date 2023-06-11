//
//  MapView.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 11/06/2023.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
  let coordinate: CLLocationCoordinate2D
  
  func makeUIView(context: Context) -> MKMapView {
    MKMapView()
  }
  
  func updateUIView(_ mapView: MKMapView, context: Context) {
    let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    mapView.setRegion(region, animated: true)
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    mapView.addAnnotation(annotation)
  }
}
