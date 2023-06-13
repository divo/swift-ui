//
//  ContentView.swift
//  WebViewExperiment
//
//  Created by Steven Diviney on 13/06/2023.
//

import SwiftUI
import WebKit
import UIKit

struct ContentView: View {
    var body: some View {
      WebView(url: URL(string: "https://mementos.ink")!)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WebView: UIViewRepresentable {
  let url: URL
  
  func makeUIView(context: Context) -> some UIView {
    return WKWebView()
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    let request = URLRequest(url: url)
    (uiView as? WKWebView)?.load(request)
  }
}
