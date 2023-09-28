//
//  SparkApp.swift
//  Spark
//
//  Created by Hinrik Helgason on 28/09/2023.
//

import SwiftUI

@main
struct SparkApp: App {
    var body: some Scene {
        WindowGroup {
            CameraView(viewModel: CameraViewModel())
        }
    }
}
