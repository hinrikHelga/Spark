//
//  ContentView.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    var body: some View {
        NavigationView {
            VStack {
                
                if selectedImage != nil {
                    Image(uiImage: selectedImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Rectangle())
                        .frame(width: 400, height: 400)
                } else {
                    Image(systemName: "sun.max")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 300, height: 300)
                }
                
                Button("Camera") {
                    self.sourceType = .camera
                    self.isImagePickerDisplay.toggle()
                }.padding()
                
                Button("photo") {
                    self.sourceType = .photoLibrary
                    self.isImagePickerDisplay.toggle()
                }.padding()
                
                if let selectedImage = selectedImage {

                    Button(action: {
                        // convert image into base 64
                        
                        let uiImage: UIImage = selectedImage
                        let imageData: Data = uiImage.jpegData(compressionQuality: 0.1) ?? Data()
                        let imageStr: String = imageData.base64EncodedString()
                                                
                        guard let encoded = "https://hackathon2023-spark.vercel.app/api/img".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
                            print("encoded")
                            return
                        }
                        
                        // send request to server
                        guard let myURL = URL(string: encoded) else {
                            print("invalid URL")
                            return
                        }
                        
                        // create parameters
                        let paramStr: String = "image=\(imageStr)"
                        let paramData: Data = paramStr.data(using: .utf8) ?? Data()
                        
                        var urlRequest: URLRequest = URLRequest(url: myURL)
                        urlRequest.httpMethod = "POST"
                        urlRequest.httpBody = paramData
                        
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
                        
                    }, label: {
                        Text("Upload image")
                    }).padding()
                }
            }
            .navigationBarTitle("Spark")
            .sheet(isPresented: self.$isImagePickerDisplay) {
                ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
            }
        }
    }
}
    
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
