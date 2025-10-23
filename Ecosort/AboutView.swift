//
// AboutView.swift
//  EcosortAI
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("About EcoSortAI")) {
                    Text("EcoSortAI helps you identify whether an item is recyclable or biodegardable or landfill-safe, using AI/ML and your phone’s camera.")
                }
                Section {
                    NavigationLink(destination: CreditsView()) {
                        Text("Credits")
                    }
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct CreditsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("This app uses the Waste Management & Recycling dataset by aasrika on Roboflow Universe, licensed under CC BY 4.0.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Link("View Dataset", destination: URL(string: "https://universe.roboflow.com/aasrika/waste-management-recycling")!)
                    .padding(.top, 5)
            }
            .padding()
        }
        }
}
