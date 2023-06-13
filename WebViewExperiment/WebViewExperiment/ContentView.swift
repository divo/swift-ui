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
//  let webView = WebView(url: URL(string: "http://192.168.0.87:3000/photo_albums")!)
  let webView = WebView(url: URL(string: "http://localhost:3000/photo_albums")!)
  
    var body: some View {
      Button("Debug") {
        // TODO: Intercept all calls to the auth controllers and grab the cookies after?
        // Or if there are no cookies, force a trip to authenticate and then grab the cookie
        // manage the authenticaion lifecycle on client
        webView.webDataStore.httpCookieStore.getAllCookies { cookies in
          print("Cookies")
        }
        print("Debug")
      }
      webView
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WebView: UIViewRepresentable {
  let url: URL
  let webDataStore = WKWebsiteDataStore.default()
  let configuration: WKWebViewConfiguration
  let webView: WKWebView
  
  init(url: URL) {
    self.url = url
    self.configuration = WKWebViewConfiguration()
    configuration.websiteDataStore = webDataStore
    self.webView = WKWebView(frame: .zero, configuration: configuration)
  }
  
  func makeUIView(context: Context) -> some UIView {
    webView.customUserAgent = "Memenots-iOS"
    return webView
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    let request = URLRequest(url: url)
    (uiView as? WKWebView)?.load(request)
  }
}
