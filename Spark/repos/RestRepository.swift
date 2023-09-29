//
//  RestImageRepository.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation
import UIKit

enum RepoError: Error {
    case idIsNull(String)
    case idWasNotFound(String)
    case unknown(String)
}

class RestRepository {
    
    static let baseUrl: String = "https://hackathon2023-spark.vercel.app"
    
    func uploadImage(image: UIImage) async throws -> PaneIncidentDTO? {
        // convert image into base 64
        
        let uiImage: UIImage = image
        let imageData: Data = uiImage.jpegData(compressionQuality: 0.1) ?? Data()
        let imageStr: String = imageData.base64EncodedString()
        
        let recognizer = ImageIdRecognizer()
        let id = recognizer.extractPanelIdFromImage(image: image)
        
        guard let id = id.first else {
            throw RepoError.idIsNull("The ID of the pane was not captured.")
        }
        
        print("Pane Id: \(id)")
                        
        let json: [String: Any] = ["image": "\(imageStr)", "paneId": "\(String(describing: id))"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        return try await makeRequest(id: id, jsonData: jsonData)

    }
    
    func makeRequest(id: String, jsonData: Data?) async throws -> PaneIncidentDTO {
        let urlSuffix = "/api/img"
        
        guard let encoded = "\(RestRepository.baseUrl)\(urlSuffix)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            print("encoded failed")
            return PaneIncidentDTO()
        }
        
        // send request to server
        guard let myURL = URL(string: encoded) else {
            print("invalid URL")
            return PaneIncidentDTO()
        }
        
        var urlRequest: URLRequest = URLRequest(url: myURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        
        // required for sending large data
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
        
        do {
            let (data, resp) = try await URLSession.shared.data(for: urlRequest)
                        
            print(String(data: data, encoding: .utf8)!)

            guard let httpResponse = resp as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                
                if let httpResponse = resp as? HTTPURLResponse, httpResponse.statusCode == 400 || httpResponse.statusCode == 404 {
                    throw RepoError.idWasNotFound("The pane ID: \(id) was not found")
                } else {
                    throw RepoError.unknown("Something went wrong")
                }
              }
            
            let incident = try JSONDecoder().decode(PaneIncidentDTO.self, from: data)
            
            print(incident)
            
            return incident

        } catch {
            throw error
        }
    }
}
