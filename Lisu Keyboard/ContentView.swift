//
//  ContentView.swift
//  Lisu Keyboard
//
//  Created by Lar May See on 14/01/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Keyboard Setup Instructions")) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("1. Go to Settings → General → Keyboard")
                            .padding(.vertical, 2)
                        Text("2. Tap on 'Keyboards'")
                            .padding(.vertical, 2)
                        Text("3. Select 'Add New Keyboard'")
                            .padding(.vertical, 2)
                        Text("4. Find and select 'Lisu Keyboard'")
                            .padding(.vertical, 2)
                        Text("5. Enable the keyboard")
                            .padding(.vertical, 2)
                        
                        Text("To use the keyboard:")
                            .font(.headline)
                            .padding(.top)
                        Text("• Tap the globe icon 🌐 on your keyboard to switch between keyboards")
                            .padding(.vertical, 2)
                    }
                    .padding(.vertical)
                }
                
                Section {
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
            .navigationTitle("Lisu Keyboard")
        }
    }
}

#Preview {
    ContentView()
}
