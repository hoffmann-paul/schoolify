//
//  VocabularyMenu.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 18.05.26.
//

import SwiftUI

struct VocabularyMenu: View {
    
    @State private var vocabulary: [VocabelEntry] = []
    
    var body: some View {
        NavigationStack() {
            VStack() {
                
                // Menü Buttons
                NavigationLink(destination: EditVocabulary()) {
                    ZStack() {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.accentColor)
                            .frame(height: 50)
                            .glassEffect()
                        
                        Text("Vokabeln bearbeiten")
                            .foregroundStyle(.black)
                            .bold()
                        
                    }
                }
                
                NavigationLink(destination: StartVocabularyQueue()) {
                    ZStack() {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.accentColor)
                            .frame(height: 50)
                            .glassEffect()
                        
                        Text("Durchgang starten")
                            .foregroundStyle(.black)
                            .bold()
                    }
                }
                
                List() {
                    ForEach(vocabulary) { vocabel in
                        HStack() {
                            Text(vocabel.otherLang)
                            
                            Spacer()
                            
                            Text(vocabel.german)
                                .foregroundStyle(Color.secondary)
                        }
                    }
                }
                .onAppear( perform: loadVocabulary )
                
                Spacer()
            }
            .padding()
        }
    }
    
// MARK: - func
    func loadVocabulary() {
        let savedVocabulary = UserDefaults.standard.string(forKey: "vocabulary") ?? "[]"
        let data = Data(savedVocabulary.utf8)
        do {
            vocabulary = try JSONDecoder().decode([VocabelEntry].self, from: data)
        } catch {
            vocabulary = []
        }
    }
    
}

#Preview {
    VocabularyMenu()
}
