//
//  ContentView.swift
//  EcosortAI
//

import SwiftUI
import CoreML
import Vision

struct ContentView: View {
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var resultText = ""
    @State private var resultImage: UIImage?
    @State private var resultColor: Color = .orange
    
    var body: some View {
        VStack {
            Text("EcoSort AI")
                .font(.title)
                .bold()
                .padding(.top, 20)
            
            Text("Scan an item to check which bin it goes in!")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
            
            Spacer()
            
            if let image = inputImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 5)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 350, height: 350)
                    .overlay(
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    )
                    .padding(.bottom, 5)
            }
            
            HStack(alignment: .center, spacing: 10) {
                if let image = resultImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                Text(resultText)
                    .font(.title)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 10)
            
            // Take Photo Button
            Button(action: {
                showImagePicker = true
            }) {
                Text("Take Photo")
                    .font(.headline)
                    .bold()
                    .padding(.vertical, 10)
                    .padding(.horizontal, 30)
                    .background(Color.green.opacity(0.85))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $inputImage, onImagePicked: classifyImage)
        }
    }
    
    func classifyImage(_ uiImage: UIImage) {
        guard let buffer = uiImage.toCVPixelBuffer() else { return }
        
        do {
            let model = try best(configuration: MLModelConfiguration())
            
            let prediction = try model.prediction(image: buffer,
                                                  iouThreshold: 0.7,
                                                  confidenceThreshold: 0.1)
            
            let confidences = prediction.confidence
            let confPointer = UnsafeMutablePointer<Float32>(OpaquePointer(confidences.dataPointer))
            let confArray = Array(UnsafeBufferPointer(start: confPointer,
                                                      count: confidences.count))
            
            let numClasses = confidences.shape[1].intValue
            var bestLabel: String?
            var bestScore: Float32 = 0
            
            for i in 0..<confidences.shape[0].intValue {
                let start = i * numClasses
                let scores = confArray[start..<start+numClasses]
                
                if let (maxIdx, maxVal) = scores.enumerated().max(by: { $0.element < $1.element }) {
                    if maxVal > bestScore {
                        bestScore = maxVal
                        bestLabel = model.model.modelDescription.classLabels?[maxIdx] as? String
                    }
                }
            }
            
            DispatchQueue.main.async {
                if let label = bestLabel {
                    
                    let lowerLabel = label.lowercased()
                            
                            if lowerLabel.contains("non") {
                                self.resultText = "Landfill"
                                self.resultImage = UIImage(named: "nonrecyclable")
                            } else if lowerLabel.contains("biodegradable") {
                                self.resultText = "Biodegradable"
                                self.resultImage = UIImage(named: "biodegradable")
                            } else if lowerLabel.contains("recyclable") {
                                self.resultText = "Recyclable"
                                self.resultImage = UIImage(named: "recyclesymbol")
                            } else {
                                self.resultImage = UIImage(systemName: "questionmark.circle.fill")
                            }
                    
                } else {
                    self.resultText = "No object detected"
                }
            }
            
        } catch {
            print("Error: \(error.localizedDescription)")
            self.resultText = "Prediction failed"
        }
    }
}

// MARK: - UIImage to CVPixelBuffer
extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let width = 640
        let height = 640
        
        CVPixelBufferCreate(kCFAllocatorDefault,
                            width,
                            height,
                            kCVPixelFormatType_32BGRA,
                            attrs,
                            &pixelBuffer)
        
        guard let pxBuffer = pixelBuffer else { return nil }
        
        CVPixelBufferLockBaseAddress(pxBuffer, .readOnly)
        let context = CGContext(data: CVPixelBufferGetBaseAddress(pxBuffer),
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(pxBuffer),
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(pxBuffer, .readOnly)
        
        return pxBuffer
    }
}
