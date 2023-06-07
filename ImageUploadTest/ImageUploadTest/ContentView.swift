//
//  ContentView.swift
//  ImageUploadTest
//
//  Created by Steven Diviney on 07/06/2023.
//

import SwiftUI
import PhotosUI
import UIKit

struct ContentView: View {
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            Button(action: {
                isShowingImagePicker = true
            }) {
                Text("Select Image")
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }
            
            Button(action: {
                if let image = selectedImage {
                    uploadImage(image)
                }
            }) {
                Text("Upload Image")
            }
        }
    }

    func uploadImage(_ image: UIImage) {
        // Perform the image upload
        // ...
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()

            guard let itemProvider = results.first?.itemProvider else { return }

        }
    }
}
