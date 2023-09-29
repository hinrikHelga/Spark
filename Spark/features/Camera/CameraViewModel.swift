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
    @Published var incident: PaneIncidentDTO?
    
    private let imgRepo: RestRepository = .init()
    
    func uploadImage(selectedImage: UIImage) async throws {
        if state == .loading { return }
                
        state = .loading
        
        do {
            let incident = try await imgRepo.uploadImage(image: selectedImage)
            self.incident = incident
            
            state = .loaded
        } catch {
            state = .error(msg: error.localizedDescription)
        }
    }
}
