//
//  ContentView.swift
//  AIDetector
//
//  Created by Çağatay Eğilmez on 3.03.2026.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var viewModel: DetectionViewModelProtocol

    init(viewModel: DetectionViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                imageSection
                actionSection
                resultSection
            }
            .padding()
            .navigationTitle("AI Detector")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Image Section

    private var imageSection: some View {
        Group {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 8)
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 300)
                    .overlay {
                        VStack(spacing: 12) {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 48))
                                .foregroundStyle(.secondary)
                            Text("Görsel seç")
                                .foregroundStyle(.secondary)
                        }
                    }
            }
        }
    }

    // MARK: - Action Section

    private var actionSection: some View {
        HStack(spacing: 16) {
            PhotosPicker(selection: $viewModel.photoItem, matching: .images) {
                Label("Galeriden Seç", systemImage: "photo.on.rectangle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Button {
                viewModel.analyzeImage()
            } label: {
                Group {
                    if viewModel.isAnalyzing {
                        ProgressView()
                    } else {
                        Label("Analiz Et", systemImage: "sparkle.magnifyingglass")
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.selectedImage == nil || viewModel.isAnalyzing)
        }
    }

    // MARK: - Result Section

    @ViewBuilder private var resultSection: some View {
        if let error = viewModel.errorMessage {
            Label(error, systemImage: "exclamationmark.triangle")
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
        } else if let result = viewModel.result {
            ResultView(result: result)
        }
    }
}
