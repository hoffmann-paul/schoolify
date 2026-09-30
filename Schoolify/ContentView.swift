//
//  ContentView.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 16.05.26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection: Int = UserDefaults.standard.integer(forKey: "standardTab")
    
    var body: some View {
        TabView(selection: $selection) {
            Tab("Hausaufgaben", systemImage: "list.bullet", value: 0) {
                Homework()
            }
            
            Tab("Tagebuch", systemImage: "star.leadinghalf.filled", value: 1) {
                Diary()
            }
            
            Tab("Lernen", systemImage:"books.vertical", value: 2) {
                learnPlan()
            }

            Tab("Vokabeln", systemImage: "text.line.last.and.arrowtriangle.forward", value: 3) {
                VocabularyMenu()
            }
            
            Tab("Einstellungen", systemImage: "gear", value: 4) {
                Settings()
            }
        }
    }
}

#Preview {
    ContentView()
}
