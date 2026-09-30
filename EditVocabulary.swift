//
//  EditVocabulary.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 18.05.26.
//

import SwiftUI

struct EditVocabulary: View {
    
    @State private var germanField: String = ""
    @State private var otherLangField: String = ""
    @State private var vocabulary: [VocabelEntry] = []
    @State private var showRemoveAllAlert = false
    @State private var showFillFieldsAlert = false
    
    var body: some View {
        VStack() {
            TextField("Deutsch", text: $germanField)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(.primary, lineWidth: 2)
                        .padding(-5)
                        .frame(height: 30)
                )
                .padding()
            
            TextField("Übersetzung", text: $otherLangField)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(.primary, lineWidth: 2)
                        .padding(-5)
                        .frame(height: 30)
                )
                .padding()
            
            ZStack() {
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.accentColor)
                    .frame(height: 50)
                    .glassEffect()
                
                Text("Vokabeln hinzufügen")
                    .foregroundStyle(.black)
                    .bold()
                
            }
            .onTapGesture { addVocabel() }
            .padding()
            
            List() {
                ForEach(vocabulary) { vocabel in
                    HStack() {
                        Text(vocabel.otherLang)
                        
                        Spacer()
                        
                        Text(vocabel.german)
                            .foregroundStyle(Color.secondary)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            removeVocabel(String: vocabel.german)
                        } label: {
                            Label("Löschen", systemImage: "trash")
                        }
                    }
                }
            }
            .alert("Alles Löschen", isPresented: $showRemoveAllAlert) {
                Button("Löschen", role: .destructive) {
                   removeAll()
                }
                Button("Abbrechen", role: .cancel) {
                    
                }
            } message: {
                Text("Möchtest du wirklich Alle Vokabeln löschen?")
            }
            .alert("Felder ausfüllen!", isPresented: $showFillFieldsAlert) {
                Button("Ok", role: .cancel) {
                    
                }
            } message: {
                Text("Beide Felder müssen ausgefüllt sein, damit du eine neue Vokabel hinzufügen kannst.")
            }
            
            Spacer()
            
            ZStack() {
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.red)
                    .frame(height: 50)
                    .glassEffect()
                
                Text("Alle löschen")
                    .foregroundStyle(.black)
                    .bold()
                
            }
            .onTapGesture { requestRemoveAll() }
            .padding()
            
        }
        .onAppear(perform: loadVocabulary )
        .navigationTitle("Vokabeln Bearbeiten")
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
    
    func submitVocabulary() {
        if let newData = try? JSONEncoder().encode(vocabulary),
           let jsonString = String(data: newData, encoding: .utf8) {
            UserDefaults.standard.set(jsonString, forKey: "vocabulary")
        }
    }
    
    func addVocabel() {
        if germanField != "" {
            if otherLangField != "" {
                loadVocabulary()
                
                let newVocabel = VocabelEntry(
                    german: germanField,
                    otherLang: otherLangField
                )
                
                vocabulary.append(newVocabel)
                
                submitVocabulary()
                
                germanField = ""
                otherLangField = ""
                
            } else {
                showFillFieldsAlert = true
            }
        } else {
            showFillFieldsAlert = true
        }
    }
    
    func removeVocabel(String voc: String) {
        if let index = vocabulary.firstIndex(where: { $0.german == voc }) {
            vocabulary.remove(at: index)
            submitVocabulary()
        }
    }
    
    func requestRemoveAll() {
        showRemoveAllAlert = true
    }
    
    func removeAll() {
        vocabulary = []
        
        submitVocabulary()
    }
}

#Preview {
    EditVocabulary()
}
