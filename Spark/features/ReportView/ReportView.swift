//
//  ReportView.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import SwiftUI

struct ReportView: View {
    var incident: PaneIncidentDTO
    var approvedImage: UIImage
    
    @State var paneId: String
    @State var category: String
    @State var priority: String
    @State var description: String
    @State var latitude: String
    @State var longitude: String

    init(incident: PaneIncidentDTO, image: UIImage) {
        self.incident = incident
        self.approvedImage = image
        _paneId = State(initialValue: incident.paneId ?? "")
        _category = State(initialValue: incident.category ?? "")
        _priority = State(initialValue: incident.priority ?? "")
        _description = State(initialValue: incident.description ?? "")
        _latitude = State(initialValue: "\(String(describing: incident.location?.lat))")
        _longitude = State(initialValue: "\(String(describing: incident.location?.lng))")
    }
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                Image(uiImage: approvedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Rectangle())
                    .frame(width: 200, height: 200)
                    .padding()

                TextField("Incident description", text: $description, axis: .vertical)
                /* Set the background to that of the grouped background colour */
                    .background(Color(.secondarySystemGroupedBackground))
                    /* Allow the text overlay to be seen and emulate the necessary colour */
                    .opacity(self.description.isEmpty ? 0.7 : 1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(5...15)
                    .padding()

                Section {
                    LabeledContent("Pane ID", value: incident.paneId ?? "")
                } header: {
                    Text("Pane")
                }

                
                Section {
                    TextField("Latitude", text: $latitude)
                    TextField("Longitude", text: $longitude)
                } header: {
                    Text("Location")
                }

                Section {
                    TextField("Category", text: $category)
                } header: {
                    Text("Category")
                }
                
                Section {
                    TextField("Priority", text: $priority)
                } header: {
                    Text("Priority")
                }

                Section {
                    Button("Submit") {
                        // Send report logic
                    }
                }
            }
        }
        .navigationTitle("Incident Report")
        .navigationBarTitleDisplayMode(.inline)
    }
}
