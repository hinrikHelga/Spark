//
//  DTOs.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation

struct PaneIncidentDTO: Codable, Equatable {
    let paneId: String?
    let location: Coordinates?
    let priority: String?
    let category: String?
    let description: String?
    let sap: SAPData?
    
    init(paneId: String? = nil, location: Coordinates? = nil, priority: String? = nil, category: String? = nil, description: String? = nil, sap: SAPData? = nil) {
        self.paneId = paneId
        self.location = location
        self.priority = priority
        self.category = category
        self.description = description
        self.sap = sap
    }
}

struct Coordinates: Codable, Equatable {
    let lat: Double?
    let lng: Double?
}

struct SAPData: Codable, Equatable {
    let NotificationNumber: String?
    let OrderNumber: String?
    let NotificationType: String?
    let Description: String?
    let ReportedBy: String?
    let CatalogProfile: String?
    let CatalogType: String?
    let Phase: String?
    let ObjectNumber: String?
    let SerialNumber: String?
    let EquipmentNumber: String?
    let Latitude: String?
    let Longitude: String?
}

