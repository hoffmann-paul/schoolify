//
//  Settings.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 16.05.26.
//

import SwiftUI

struct Settings: View {
    
    @State private var allData: String = ""
    
    enum tabs: String, CaseIterable, Identifiable {
        case zero = "Hausaufgaben"
        case one = "Tagebuch"
        case two = "Lernen"
        case three = "Vokabeln"
        
        
        var id: Self { self }
        var description: String { self.rawValue }
    }
        
    
    @State private var selectedTab: tabs = .zero
    
    var body: some View {
        VStack() {
            
// MARK: - Standard Tab
            VStack() {
                Text("Standard Tab")
                    .font(.title)
                    .bold()
                    .onAppear( perform: loadRecentTab )
                
                Picker("", selection: $selectedTab) {
                    ForEach(tabs.allCases) {
                        Text($0.description)
                            .tag($0)
                    }
                }
                .padding()
                .pickerStyle(.segmented)
                .onChange(of: selectedTab) {
                    standardTab()
                }
    
            }
            Divider()
                .frame(height: 10)
            
// MARK: - Exportieren
            
            ZStack() {
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.accentColor)
                    .glassEffect()
                
                ShareLink(
                    item: allData,
                    preview: SharePreview("data.txt", image: Image(systemName: "doc.text"))
                ) {
                    Text("Daten exportieren")
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(width: 380,height: 50)
            .onAppear { loadData() }
            
            Divider()
                .frame(height: 10)
            
// MARK: - Fächer
            VStack() {
                Text("Fächer")
                    .font(.title)
                    .bold()
                
                List() {
                    HStack() {
                        Text("Chemie")
                        
                        Spacer()
                        
                        Image(systemName: "testtube.2")
                            .foregroundColor(.orange)
                    }
                    
                    HStack() {
                        Text("Musik")
                        
                        Spacer()
                        
                        Image(systemName: "music.note")
                            .foregroundColor(.white)
                    }
                    
                    HStack() {
                        Text("Mathe")
                        
                        Spacer()
                        
                        Image(systemName: "function")
                            .foregroundColor(.red)
                    }
                    
                    HStack() {
                        Text("Nwt")
                        
                        Spacer()
                        
                        Image(systemName: "wrench.and.screwdriver")
                            .foregroundColor(.orange)
                    }
                    
                    HStack() {
                        Text("Französisch")
                        
                        Spacer()
                        
                        Image(systemName: "flag")
                            .foregroundColor(.blue)
                    }
                    
                    HStack() {
                        Text("Englisch")
                        
                        Spacer()
                        
                        Image(systemName: "flag.fill")
                            .foregroundColor(.blue)
                    }
                    
                    HStack() {
                        Text("Deutsch")
                        
                        Spacer()
                        
                        Image(systemName: "list.bullet")
                            .foregroundColor(.blue)
                    }
                    
                    HStack() {
                        Text("Geschichte")
                        
                        Spacer()
                        
                        Image(systemName: "building.columns")
                            .foregroundColor(.green)
                    }
                    
                    HStack() {
                        Text("Sport")
                        
                        Spacer()
                        
                        Image(systemName: "basketball")
                            .foregroundColor(.brown)
                    }
                    
                    HStack() {
                        Text("Physik")
                        
                        Spacer()
                        
                        Image(systemName: "globe.europe.africa")
                            .foregroundColor(.yellow)
                    }
                    
                    HStack() {
                        Text("Gemeinschaftskunde")
                        
                        Spacer()
                        
                        Image(systemName: "person.3")
                            .foregroundColor(.green)
                    }
                    
                    HStack() {
                        Text("Wirtschaft Beruf- und Studienorientierung")
                        
                        Spacer()
                        
                        Image(systemName: "dollarsign.circle")
                            .foregroundColor(.green)
                    }
                    
                    HStack() {
                        Text("Religion")
                        
                        Spacer()
                        
                        Image(systemName: "hands.and.sparkles")
                            .foregroundColor(.green)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
    
// MARK: - func
    
    func loadRecentTab() {
        switch UserDefaults.standard.integer(forKey: "standardTab") {
            case 0: selectedTab = .zero
            case 1: selectedTab = .one
            case 2: selectedTab = .two
            case 3: selectedTab = .three
            default: break
            }
    }
    
    func standardTab() {
        let userInteger: Int
            switch selectedTab {
            case .zero: userInteger = 0
            case .one:  userInteger = 1
            case .two:  userInteger = 2
            case .three: userInteger = 3
            }
            UserDefaults.standard.set(userInteger, forKey: "standardTab")
    }
    
    func loadData() {
        let todos = UserDefaults.standard.string(forKey: "todos") ?? ""
        let diary = UserDefaults.standard.string(forKey: "diaryEntries") ?? ""
        allData = todos + diary
    }
    
}

#Preview {
    Settings()
}
