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
                VStack(alignment: .center) {
                    switch viewModel.state {
                    case .initial:
                        Spacer()
                        Image(systemName: "sun.max")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                    case .loading:
                        Spacer()
                        ProgressView()
                        Spacer()
                    case .loaded:
                        ScrollView {
                            VStack {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Rectangle())
                                    .frame(width: 300, height: 300)
                                    .padding()
                                
                                Text(viewModel.incident?.description ?? "")
                                    .frame(maxHeight: .infinity)
                                    .padding()
                            }
                        }
                        
                        NavigationLink(destination: ReportView(incident: viewModel.incident ?? PaneIncidentDTO(), image: viewModel.selectedImage)) {
                            Text("Approve")
                        }.padding()
                        
                        NavigationLink(destination: ReportView(incident: PaneIncidentDTO(paneId: viewModel.incident?.paneId), image: viewModel.selectedImage)) {
                            Text("Create own report")
                        }.padding()
                    case .error(msg: let msg):
                        VStack {
                            Spacer()
                            Text(msg)
                            Spacer()
                        }
                        
                    }
                    
                    if viewModel.state != .loading {
                        Spacer()
                        Button(viewModel.state == .initial ? "Use camera" : "Retake photo") {
                            self.sourceType = .camera
                            self.isImagePickerDisplay.toggle()
                        }

                        .padding()
                    }
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
            }.animation(.linear, value: viewModel.state)
    }
}
