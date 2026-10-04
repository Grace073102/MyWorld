//
//  MediaPicker.swift
//  MyWorld
//
//  Created by Grace Chi Yen Chong on 4/10/2026.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct MediaPicker: UIViewControllerRepresentable {

    let onMediaSelected: (Data, String, String) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .any(of: [.images, .videos])
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onMediaSelected: onMediaSelected)
    }

    final class Coordinator: NSObject, PHPickerViewControllerDelegate {

        let onMediaSelected: (Data, String, String) -> Void

        init(onMediaSelected: @escaping (Data, String, String) -> Void) {
            self.onMediaSelected = onMediaSelected
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let result = results.first else {
                return
            }

            let provider = result.itemProvider

            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
                    guard let data else {
                        return
                    }

                    DispatchQueue.main.async {
                        self.onMediaSelected(data, "photo", "jpg")
                    }
                }
            } else if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, _ in
                    guard let url,
                          let data = try? Data(contentsOf: url) else {
                        return
                    }

                    let fileExtension = url.pathExtension.isEmpty ? "mov" : url.pathExtension

                    DispatchQueue.main.async {
                        self.onMediaSelected(data, "video", fileExtension)
                    }
                }
            }
        }
    }
}
