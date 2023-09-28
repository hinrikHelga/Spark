//
//  ImageIdRecognizer.swift
//  Spark
//
//  Created by Lasse Skaalum on 28/09/2023.
//

import Foundation
import Vision
import UIKit

class ImageIdRecognizer {
    var completed = false
    var recognizedStrings: [String] = []
    
    func extractPanelIdFromImage(image: UIImage) -> [String] {
        guard let cgImage = image.cgImage else { return [] }
        
        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)


        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)


        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
            while (completed == false) {}
            return recognizedStrings
        } catch {
            print("Unable to perform the requests: \(error).")
            return []
        }
    }
    
    private func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        self.recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        
        completed = true
    }
}
