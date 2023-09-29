//
//  ReportView.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import SwiftUI

enum Priority: String, CaseIterable, Identifiable {
    var id: Self {
        return self
    }

    case ci = "CRITICAL_IMPACT"
    case hi = "HIGH_IMPACT"
    case mi = "MODERATE_IMPACT"
    case li = "LOW_IMPACT"
    case ni = "NEGLIGIBLE_IMPACT"
    case mr = "MAINTENANCE_REQUIRED"
}

struct ReportView: View {
    var incident: PaneIncidentDTO
    var approvedImage: UIImage
    
    @State var paneId: String
    @State var category: String
    @State var description: String
    @State var latitude: String
    @State var longitude: String
    @State var priority: Priority = .li

    init(incident: PaneIncidentDTO, image: UIImage) {
        self.incident = incident
        self.approvedImage = image
        _paneId = State(initialValue: incident.paneId ?? "")
        _category = State(initialValue: incident.category ?? "")
        let pr = Priority(rawValue: incident.priority ?? "LOW_IMPACT")!
        
        _priority = State(initialValue: pr)
        _description = State(initialValue: incident.description ?? "")
        _latitude = State(initialValue: "")
        _longitude = State(initialValue: "")
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
                    LabeledContent("ID", value: incident.paneId ?? "")
                } header: {
                    Text("Pane")
                }
                
                if let lat = incident.location?.lat, let lng = incident.location?.lng {
                    Section {
                        LabeledContent("Latitude", value: "\(lat)")
                        LabeledContent("Longitude", value: "\(lng)")
                    } header: {
                        Text("Location")
                    }
                } else {

                    Section {
                        TextField("Latitude", text: $latitude)
                    } header: {
                        Text("Latitude")
                    }
                    
                    Section {
                        TextField("Longitude", text: $longitude)
                    } header: {
                        Text("Longitude")
                    }
                }

                Section {
                    TextField("Category", text: $category)
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases) { option in
                            Text(option.rawValue)
                        }
                    }
                } header: {
                    Text("Category")
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
