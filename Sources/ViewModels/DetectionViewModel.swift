//
//  DetectionViewModel.swift
//  AIDetector
//
//  Created by Çağatay Eğilmez on 3.03.2026.
//

import Observation
import PhotosUI
import SwiftUI

@Observable
@MainActor
final class DetectionViewModel: DetectionViewModelProtocol {

    var selectedImage: UIImage?
    var result: DetectionResult?
    var isAnalyzing: Bool = false
    var errorMessage: String?
    var photoItem: PhotosPickerItem? {
        didSet {
            Task {
                await loadImage(from: photoItem)
            }
        }
    }

    private let classifier: AIClassifierProtocol

    init() {
        do {
            self.classifier = try AIClassifier()
        } catch {
            fatalError("Model yüklenemedi: \(error)")
        }
    }

    func analyzeImage() {
        guard let selectedImage else {
            return
        }

        isAnalyzing = true
        result = nil
        errorMessage = nil

        Task {
            do {
                result = try await classifier.analyze(image: selectedImage)
            } catch {
                errorMessage = "Analiz başarısız oldu. Lütfen tekrar deneyin."
            }
            isAnalyzing = false
        }
    }

    /// Loads an image from a PhotosPickerItem and updates the selected image
    ///
    /// - Parameter item: The PhotosPickerItem containing the image to load
    private func loadImage(from item: PhotosPickerItem?) async {
        guard let item else {
            return
        }

        result = nil
        errorMessage = nil

        if let data = try? await item.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
            selectedImage = image
        }
    }
}
