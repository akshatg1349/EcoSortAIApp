# EcoSortAIApp README
EcoSortAIApp is an iOS application built with Swift, SwiftUI, Core ML, and Apple’s Vision framework. It combines real-time camera detection with AI-powered classification to guide users toward proper waste sorting in categories- recyclable, biodegradable, and landfill.

The project integrates a custom-trained YOLOv9c model converted to Core ML (FP16) for efficient on-device inference enabling fast, offline waste recognition directly on iPhones.

   ```
## Features
Real-time Detection: Instantly classifies waste into recyclable, biodegradable, or landfill categories using the camera

AI Chat Assistant: Built-in assistant powered by OpenAI API that answers location-specific recycling questions

On-device AI: YOLOv9c Core ML model optimized for performance and low latency

Educational Guidance: Explains why an item belongs to a specific bin, promoting sustainable habits

Modern SwiftUI Design: Clean, minimal, and intuitive user interface

Modern architecture: Built with a clean, modular SwiftUI structure using MVVM and async/await for smooth, maintainable performance

## Requirements

- Xcode 26.0.1 or later
- Swift 6
- Minimum OS versions: iOS 18
- OpenAI API Key for Chat Assistant
 
## Getting Started

1. Clone the repository:
   git clone https://github.com/akshatg1349/EcoSortAIApp.git
   cd EcoSortAIApp
2. In ChatService.swift, please put your OpenAI API key in 'apiKey' variable. This is required for AI Chat Assistant functionality to work.
3. Build and run the app in Xcode on a physical device (recommended for camera access)
   ```
