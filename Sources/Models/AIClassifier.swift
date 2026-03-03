//
//  AIClassifier.swift
//  AIDetector
//
//  Created by Çağatay Eğilmez on 3.03.2026.
//

import CoreML
import UIKit
import Vision

final class AIClassifier: AIClassifierProtocol {

    private let model: AIDetector

    init() throws {
        guard let model = try? AIDetector() else {
            throw AIClassifierError.modelLoadingFailed
        }

        self.model = model
    }

    func analyze(image: UIImage) async throws -> DetectionResult {
        guard let multiArray = image.toMLMultiArray() else {
            throw AIClassifierError.invalidImage
        }

        guard let output = try? model.prediction(input: multiArray) else {
            throw AIClassifierError.analysisFailed
        }

        let scores = softmax(output.linear_147)
        let artificialScore = scores[0]
        let notArtificialScore = scores[1]

        let label: DetectionLabel = artificialScore > notArtificialScore
            ? .artificial(confidence: artificialScore)
            : .notArtificial(confidence: notArtificialScore)

        return DetectionResult(label: label,
                               artificialScore: artificialScore,
                               notArtificialScore: notArtificialScore)
    }

    private func softmax(_ logits: MLMultiArray) -> [Float] {
        let a = Float(truncating: logits[0])
        let b = Float(truncating: logits[1])
        let maxVal = max(a, b)
        let expA = exp(a - maxVal)
        let expB = exp(b - maxVal)
        let sum = expA + expB
        return [expA / sum, expB / sum]
    }
}

private extension UIImage {

    func toMLMultiArray() -> MLMultiArray? {
        let size = CGSize(width: 224, height: 224)
        let resized = self.resized(to: size)

        guard let cgImage = resized.cgImage else {
            return nil
        }

        let width = 224
        let height = 224
        let channels = 3

        guard let multiArray = try? MLMultiArray(
            shape: [1, NSNumber(value: channels), NSNumber(value: height), NSNumber(value: width)],
            dataType: .float16
        ) else { return nil }

        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: width * 4,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else {
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let data = context.data else {
            return nil
        }

        let pixels = data.bindMemory(to: UInt8.self, capacity: width * height * 4)

        let mean: [Float] = [0.485, 0.456, 0.406]
        let std: [Float]  = [0.229, 0.224, 0.225]

        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = (y * width + x) * 4
                for c in 0..<channels {
                    let raw = Float(pixels[pixelIndex + c]) / 255.0
                    let normalized = (raw - mean[c]) / std[c]
                    let arrayIndex = c * height * width + y * width + x
                    multiArray[arrayIndex] = NSNumber(value: normalized)
                }
            }
        }

        return multiArray
    }

    func resized(to size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
