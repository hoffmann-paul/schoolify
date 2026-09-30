//
//  createTheme.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 25.05.26.
//

import SwiftUI

struct createTheme: View {
    
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("temporaryThemes") private var temporaryEntriesData: String = "[]"
    
    @State private var field: String = ""
    
    enum difficultys: String, CaseIterable, Identifiable {
        case zero = "Wenig"
        case one = "Mittel"
        case two = "Viel"
        
        var id: Self { self }
        var description: String { self.rawValue }
    }
        
    @State private var submitAlert: Bool = false
    @State private var selectedDifficulty: difficultys = .one
    
    var body: some View {
        VStack() {
            HStack() {
                TextField("Thema", text: $field)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(.primary, lineWidth: 2)
                            .padding(-5)
                            .frame(height: 30)
                    )
                    .padding()
            }
            
            Divider()
            
            Text("Lernmenge")
                .bold()
            
            Picker("", selection: $selectedDifficulty) {
                ForEach(difficultys.allCases) {
                    Text($0.description)
                        .tag($0)
                }
            }
            .padding()
            .pickerStyle(.segmented)
            
            Spacer()
            
            ZStack() {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.accentColor)
                    .frame(height: 50)
                
                Text("Thema hinzufügen")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundStyle(Color.white)
            }
            .onTapGesture { saveTheme() }
            .alert("Thema wurde erstellt", isPresented: $submitAlert) {
        
                Button("Ok", role: .cancel) {
                    dismiss()
                }
            }
            
        }
        .padding()
        .navigationTitle("Neues Thema")
    }
    
//MARK: - func
    
    func saveTheme() {
        
        let difficultyInteger: Int
            switch selectedDifficulty {
            case .zero: difficultyInteger = 0
            case .one:  difficultyInteger = 1
            case .two:  difficultyInteger = 2
            }
        
        let newEntry = ThemeEntry(
            name: field,
            quantity: difficultyInteger,
            done: false,
            state: 0
        )
        
        var allEntries: [ThemeEntry] = []

        if let data = temporaryEntriesData.data(using: .utf8) {
            let decoder = JSONDecoder()
            allEntries = (try? decoder.decode([ThemeEntry].self, from: data)) ?? []
        }

        allEntries.append(newEntry)

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allEntries),
           let jsonString = String(data: encoded, encoding: .utf8) {
            temporaryEntriesData = jsonString   
        }
        
        submitAlert = true
        
    }
    
}

#Preview {
    createTheme()
}
