//
//  CameraViewmodel.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation
import UIKit

enum CameraState: Equatable {
    case initial
    case loading
    case loaded
    case error(msg: String)
}

@MainActor
class CameraViewModel: ObservableObject {
    @Published private(set) var state: CameraState = .initial
    @Published var selectedImage: UIImage = UIImage()
    
    private let imgRepo: RestRepository = .init()
    
    func uploadImage(selectedImage: UIImage) async throws {
        
        state = .loading
        
        do {
            try await imgRepo.uploadImage(image: selectedImage)
            state = .loaded
        } catch {
            state = .error(msg: error.localizedDescription)
        }
    }
}
