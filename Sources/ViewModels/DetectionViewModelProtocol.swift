//
//  DetectionViewModelProtocol.swift
//  AIDetector
//
//  Created by Çağatay Eğilmez on 3.03.2026.
//

import PhotosUI
import SwiftUI
import UIKit

@MainActor
protocol DetectionViewModelProtocol: AnyObject {

    /// The currently selected image from the device
    var selectedImage: UIImage? { get set }

    /// The result of the AI detection analysis
    var result: DetectionResult? { get }

    /// Indicates whether an analysis is currently in progress
    var isAnalyzing: Bool { get }

    /// Error message to display if analysis fails
    var errorMessage: String? { get }

    /// The selected photo item from the Photos picker
    var photoItem: PhotosPickerItem? { get set }

    /// Initiates the AI detection analysis on the selected image
    func analyzeImage()
}
