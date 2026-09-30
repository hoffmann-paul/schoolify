//
//  themeDetail.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 26.05.26.
//

import SwiftUI

struct themeDetail: View {
    
    @Binding var theme: ThemeEntry //Für bearbeiten z.b. theme.done = true
    @State private var refreshAlert: Bool = false
    
    var body: some View {
        VStack() {
            List() {
                HStack() {
                    Text("Name")
                        .bold()
                    
                    Spacer()
                    
                    Text(theme.name)
                }
                
                HStack() {
                    Text("Menge")
                        .bold()
                    
                    Spacer()
                    
                    if theme.quantity == 0 {
                        Text("Wenig")
                            .foregroundStyle(Color.green)
                    } else {
                        if theme.quantity == 1 {
                            Text("Mittel")
                                .foregroundStyle(Color.yellow)
                        } else {
                            if theme.quantity == 2 {
                                Text("Viel")
                                    .foregroundStyle(Color.red)
                            }
                        }
                    }
                }
                
                HStack() {
                    Text("Gelernt")
                        .bold()
                    
                    Spacer()
                    
                    if theme.done {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.green)
                    } else {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.red)
                    }
                }
                
                if theme.done {
                    HStack() {
                        Text("Lernstand")
                            .bold()
                        
                        Spacer()
                        
                        if theme.state == 0 {
                            Text("Schlecht")
                                .foregroundStyle(Color.red)
                        } else {
                            if theme.state == 1 {
                                Text("Mittel")
                                    .foregroundStyle(Color.yellow)
                            } else {
                                if theme.state == 2 {
                                    Text("Gut")
                                        .foregroundStyle(Color.green)
                                }
                            }
                        }
                    }
                }
            }
            if theme.done {
                ZStack() {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.accentColor)
                        .frame(height: 50)
                    
                    Text("Lernstand aktualisieren")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundStyle(Color.white)
                }
                .onTapGesture(perform: requestRefreshLearnState)
            } else {
                ZStack() {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.accentColor)
                        .frame(height: 50)
                    
                    Text("\(theme.name) lernen")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundStyle(Color.white)
                }
                .onTapGesture(perform: markTheme)
            }
        }
        .alert("Lernstand aktualisieren", isPresented: $refreshAlert) {
            Button("Schlecht") {
                refreshLearnState(Int: 0)
            }
            Button("Mittel") {
                refreshLearnState(Int: 1)
            }
            Button("Gut") {
                refreshLearnState(Int: 2)
            }
        } message: {
            Text("Wie gut kannst du \(theme.name)")
        }
        .padding()
        .navigationTitle(theme.name)
    }
    
    func requestRefreshLearnState() {
        refreshAlert = true
    }
    
    func refreshLearnState(Int newState: Int) {
        theme.state = newState
    }
    
    func markTheme() {
        theme.done = true
        
        refreshAlert = true
    }
}

#Preview {
    @Previewable @State var theme = ThemeEntry(
            name: "Algebra", quantity: 1, done: false, state: 0
        )
        themeDetail(theme: $theme)
}
