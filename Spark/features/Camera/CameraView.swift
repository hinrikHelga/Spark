//
//  CameraView.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import SwiftUI

struct CameraView: View {
    @ObservedObject var viewModel: CameraViewModel
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var isImagePickerDisplay = false
    
    let imgRepo: RestRepository = .init()
    
    var body: some View {
        let selectedImage = viewModel.selectedImage
        
        NavigationView {
            VStack {
                switch viewModel.state {
                case .initial:
                    Image(systemName: "sun.max")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 300, height: 300)
                case .loading:
                    Spacer()
                    ProgressView()
                    Spacer()
                case .loaded:
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Rectangle())
                        .frame(width: 400, height: 400)
                    NavigationLink(destination: ReportView()) {
                        Text("Approve")
                    }.padding()
                case .error(msg: let msg):
                    VStack {
                        Spacer()
                        Text(msg)
                        Spacer()
                    }
                    
                }
                
                Button(viewModel.state == .initial ? "Use camera" : "Retake photo") {
                    self.sourceType = .camera
                    self.isImagePickerDisplay.toggle()
                }.padding()
            }
            .navigationBarTitle("Spark")
            .onChange(of: viewModel.selectedImage, perform: { img in
                Task {
                    try await viewModel.uploadImage(selectedImage: img)
                }
            })
            .sheet(isPresented: self.$isImagePickerDisplay) {
                ImagePickerView(selectedImage: $viewModel.selectedImage, sourceType: self.sourceType)
            }
        }
    }
}

//struct CameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraView()
//    }
//}
