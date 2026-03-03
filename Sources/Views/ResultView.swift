//
//  ResultView.swift
//  AIDetector
//
//  Created by Çağatay Eğilmez on 3.03.2026.
//

import SwiftUI

struct ResultView: View {

    let result: DetectionResult

    private var isAI: Bool { result.isAI }
    private var score: Float { result.confidencePercentage }

    private var label: String {
        isAI ? "AI Üretimi" : "Gerçek Görsel"
    }

    private var icon: String {
        isAI ? "exclamationmark.triangle.fill" : "checkmark.seal.fill"
    }

    private var tint: Color {
        isAI ? .red : .green
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 56))
                .foregroundStyle(tint)

            Text(label)
                .font(.title2.bold())

            VStack(spacing: 8) {
                scoreRow(title: "AI Üretimi", value: result.artificialScore)
                scoreRow(title: "Gerçek", value: result.notArtificialScore)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(tint.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func scoreRow(title: String, value: Float) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(String(format: "%.1f%%", value * 100))
                .bold()
        }
    }
}
