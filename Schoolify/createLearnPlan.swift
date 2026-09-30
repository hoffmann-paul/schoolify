//
//  createLearnPlan.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 25.05.26.
//

import SwiftUI

struct createLearnPlan: View {
    
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("learnPlans") private var entriesData: String = "[]"
    
    @State private var count: Int = 1
    @State private var themes: [ThemeEntry] = []
    @State private var field: String = ""
    @State private var submitAlert: Bool = false
    
    var body: some View {
       
            VStack() {
                
                TextField("Name", text: $field)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(.primary, lineWidth: 2)
                            .padding(-5)
                            .frame(height: 30)
                    )
                    .padding()
                
                HStack() {
                    Text("Tage üprig:")
                        .bold()
                    Text("\(count)")
                    Stepper("",
                            value: $count,
                            in: 1...14
                    )
                }
                
                List() {
                    NavigationLink(destination: createTheme()) {
                        HStack() {
                            Image(systemName: "plus")
                                .foregroundStyle(Color.blue)
                            Text("Neues Thema")
                                .foregroundStyle(Color.blue)
                        }
                    }
                    
                    ForEach(themes) { theme in
                        HStack() {
                            Text(theme.name)
                            
                            Spacer()
                            
                            if theme.quantity == 0 {
                                Image(systemName: "circle.fill")
                                    .foregroundStyle(Color.green)
                            } else {
                                if theme.quantity == 1 {
                                    Image(systemName: "circle.fill")
                                        .foregroundStyle(Color.yellow)
                                } else {
                                    if theme.quantity == 2 {
                                        Image(systemName: "circle.fill")
                                            .foregroundStyle(Color.red)
                                    }
                                }
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                removeTheme(String: theme.name)
                            } label: {
                                Label("Löschen", systemImage: "trash")
                            }
                        }
                    }
                }
                .onAppear(perform: loadThemes )
                
                Spacer()
                
                ZStack() {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.accentColor)
                        .frame(height: 50)
                    
                    Text("Lernplan erstellen")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundStyle(Color.white)
                }
                .onTapGesture ( perform: submitLearnPlan )
                .alert("Lernplan wurde erstellt", isPresented: $submitAlert) {
            
                    Button("Ok", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Neuer Lernplan")
            .padding()
        }
    
    
    func loadThemes() {
        let savedThemes = UserDefaults.standard.string(forKey: "temporaryThemes") ?? "[]"
        let data = Data(savedThemes.utf8)
        do {
            themes = try JSONDecoder().decode([ThemeEntry].self, from: data)
        } catch {
            themes = []
        }
    }
    
    func removeTheme(String the: String) {
        if let index = themes.firstIndex(where: { $0.name == the }) {
            themes.remove(at: index)
            submitThemes()
        }
    }
    
    func submitThemes() {
        if let newData = try? JSONEncoder().encode(themes),
           let jsonString = String(data: newData, encoding: .utf8) {
            UserDefaults.standard.set(jsonString, forKey: "temporaryThemes")
        }
    }
    
    func submitLearnPlan() {
        let newEntry = LearnPlanEntry(
            name: field,
            days: count,
            themes: themes
        )
        
        var allEntries: [LearnPlanEntry] = []

        if let data = entriesData.data(using: .utf8) {
            let decoder = JSONDecoder()
            allEntries = (try? decoder.decode([LearnPlanEntry].self, from: data)) ?? []
        }

        allEntries.append(newEntry)

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allEntries),
           let jsonString = String(data: encoded, encoding: .utf8) {
            entriesData = jsonString
        }
        
        UserDefaults.standard.set("", forKey: "temporaryThemes")
        
        submitAlert = true
        
    }
}

#Preview {
    createLearnPlan()
}
