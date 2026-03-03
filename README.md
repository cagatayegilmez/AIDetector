# AIDetector

Detect AI-generated images directly on your iPhone — no server, no data upload, full privacy.

## How It Works

AIDetector uses a Swin Transformer model converted from HuggingFace to Core ML. Every analysis happens entirely on-device. Your images never leave your phone.

## Features

- **On-device inference** — zero server cost, zero latency, works offline
- **Full privacy** — images are never uploaded or stored
- **Confidence scoring** — see how likely an image is AI-generated
- **Simple UI** — pick an image, tap Analyze, get results instantly

## Tech Stack

| Layer | Technology |
|---|---|
| UI | SwiftUI |
| Architecture | MVVM |
| ML Runtime | Core ML |
| Base Model | Swin Transformer (umm-maybe/AI-image-detector) |
| Model Conversion | PyTorch → torch.export → Core ML |
| Concurrency | Swift Concurrency (async/await) |

## Requirements

- iOS 16+
- Xcode 15+

## Model

The Core ML model is not included in this repository due to file size (~177MB). To generate it locally:

```bash
cd model-conversion
python3.11 -m venv venv
source venv/bin/activate
pip install transformers torch==2.7.0 coremltools Pillow
python3.11 convert.py
```

This will produce `AIDetector.mlpackage`. Add it to the Xcode project under `Resources/`.

## Project Structure

```
AIDetector/
├── Resources/
│   ├── AIDetectorApp.swift
│   └── Assets.xcassets
└── Sources/
    ├── Models/
    │   └── AIClassifier.swift
    │   └── AIClassifierProtocol.swift
    │   └── AIClassifierError.swift
    │   └── AIClassifierLabel.swift
    │   └── AIClassifierResult.swift
    ├── ViewModels/
    │   └── DetectionViewModel.swift
    │   └── DetectionViewModelProtocol.swift
    └── Views/
        ├── ContentView.swift
        └── ResultView.swift
```

## Roadmap

- [ ] Camera support
- [ ] Video detection (frame-by-frame analysis)
- [ ] Metadata analysis (EXIF)

## License

MIT
