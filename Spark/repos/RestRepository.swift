//
//  RestImageRepository.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import Foundation
import UIKit

class RestRepository {
    
    let baseUrl: String = "https://hackathon2023-spark.vercel.app"
    
    func uploadImage(image: UIImage) async throws {
        // convert image into base 64
        
        let uiImage: UIImage = image
        let imageData: Data = uiImage.jpegData(compressionQuality: 0.1) ?? Data()
        let imageStr: String = imageData.base64EncodedString()
        
        let recognizer = ImageIdRecognizer()
        let id = recognizer.extractPanelIdFromImage(image: image)
        
        let urlSuffix = "/api/img"
        
        guard let encoded = "\(baseUrl)\(urlSuffix)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            print("encoded failed")
            return
        }
        
        // send request to server
        guard let myURL = URL(string: encoded) else {
            print("invalid URL")
            return
        }
                
        // create parameters
        let paramStr: String = "image=\(imageStr)"
//        let paramData: Data = paramStr.data(using: .utf8) ?? Data()
        
        let json: [String: Any] = ["image": "\(paramStr)", "id": "\(String(describing: id.first!))"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var urlRequest: URLRequest = URLRequest(url: myURL)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        
        // required for sending large data
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // required for sending large data
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // send the request
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            guard let data = data else {
                print("invalid data")
                return
            }
            
            // show response in string
            let responseStr: String = String(data: data, encoding: .utf8) ?? ""
            print(responseStr)
        })
        .resume()
    }
}
