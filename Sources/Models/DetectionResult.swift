//
//  DetectionResult.swift
//  AIDetector
//
//  Created by Çağatay Eğilmez on 3.03.2026.
//

struct DetectionResult {

    let label: DetectionLabel
    let artificialScore: Float
    let notArtificialScore: Float

    var isAI: Bool {
        if case .artificial = label {
            return true
        }

        return false
    }

    var confidencePercentage: Float {
        switch label {
        case .artificial(let confidence):
            return confidence * 100
        case .notArtificial(let confidence):
            return confidence * 100
        }
    }
}
