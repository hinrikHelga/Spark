//
//  DTOs.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation

struct ImageDTO {
    let paneId: String
    let location: Coordinates
    let priority: String
    let category: String
    let desription: String
}

struct Coordinates {
    let lat: Double
    let lng: Double
}

struct Priority {
    
}

struct Category {
    
}
