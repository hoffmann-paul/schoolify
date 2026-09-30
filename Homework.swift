//
//  Homework.swift
//  Schoolify
//
//  Created by Paul Hoffmann on 16.05.26.
//

import SwiftUI

struct TodoItem: Codable, Identifiable {
    let id: UUID
    var text: String
    var subject: String

    init(text: String, subject: String) {
        self.id = UUID()
        self.text = text
        self.subject = subject
    }
}

struct Homework: View {
    
    @State private var todos: [TodoItem] = []
    @State private var field: String = ""
    @State private var todoToDelete: TodoItem? = nil
    @State private var showDeleteAlert = false
    enum subjects: String, CaseIterable, Identifiable {
        case chemic = "Chemie"
        case music = "Musik"
        case math = "Mathe"
        case nwt = "Nwt"
        case french = "Französisch"
        case english = "Englisch"
        case german = "Deutsch"
        case history = "Geschichte"
        case pe = "Sport"
        case physics = "Physik"
        case gk = "Gemeinschaftskunde"
        case wbs = "Wirtschaft Beruf- und Studienorientierung"
        case religion = "Religion"
        
        var id: Self { self }
        var description: String { self.rawValue }
    }
        
    @State private var selectedSubject: subjects = .math

// MARK: - Body
    var body: some View {
        VStack() {
            
// MARK: - Neu erstellen
            VStack() {
                HStack() {
                    TextField("", text: $field)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(.primary, lineWidth: 2)
                                .padding(-5)
                                .frame(height: 30)
                        )
                        .padding()
                        .frame(width: 345, height: 30)
                    
                    ZStack() {
                        Circle()
                            .fill(.blue)
                            .opacity(0.5)
                            .glassEffect()
                        
                        Image(systemName: "plus")
                            .colorScheme(.dark)
                            .bold()
                    }
                    .frame(width: 50, height: 50)
                    .onTapGesture { addToDo() }
                }
                
                Picker("", selection: $selectedSubject) {
                    ForEach(subjects.allCases) {
                        Text($0.description)
                            .tag($0)
                    }
                }
                .overlay() {
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(.blue, lineWidth: 2)
                        .frame(width: 380, height: 30)
                }
                .pickerStyle(.menu)
            }
            .padding()
            
// MARK: - Liste
            List {
                ForEach(todos) { todo in
                    HStack() {
                        let subject = todo.subject
                        
                        if subject == "Chemie" {
                            Image(systemName: "testtube.2")
                                .foregroundColor(.orange)
                        }
                        if subject == "Musik" {
                            Image(systemName: "music.note")
                                .foregroundColor(.white)
                        }
                        if subject == "Mathe" {
                            Image(systemName: "function")
                                .foregroundColor(.red)
                        }
                        if subject == "Nwt" {
                            Image(systemName: "wrench.and.screwdriver")
                                .foregroundColor(.orange)
                        }
                        if subject == "Französisch" {
                            Image(systemName: "flag")
                                .foregroundColor(.blue)
                        }
                        if subject == "Englisch" {
                            Image(systemName: "flag.fill")
                                .foregroundColor(.blue)
                        }
                        if subject == "Deutsch" {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.blue)
                        }
                        if subject == "Geschichte" {
                            Image(systemName: "building.columns")
                                .foregroundColor(.green)
                        }
                        if subject == "Sport" {
                            Image(systemName: "basketball")
                                .foregroundColor(.brown)
                        }
                        if subject == "Physik" {
                            Image(systemName: "globe.europe.africa")
                                .foregroundColor(.yellow)
                        }
                        if subject == "Gemeinschaftskunde" {
                            Image(systemName: "person.3")
                                .foregroundColor(.green)
                        }
                        if subject == "Wirtschaft Beruf- und Studienorientierung" {
                            Image(systemName: "dollarsign.circle")
                                .foregroundColor(.green)
                        }
                        if subject == "Religion" {
                            Image(systemName: "hands.and.sparkles")
                                .foregroundColor(.green)
                        }
                        
                        
                        Text(todo.text)
                        
                        Spacer()
                        
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                            .onTapGesture { toggleTodo(todo: todo) }
                            .padding()
                            .glassEffect()
                    }
                }
            }
            .alert("Hausaufgabe löschen?", isPresented: $showDeleteAlert) {
                Button("Löschen", role: .destructive) {
                    confirmDelete()
                }
                Button("Abbrechen", role: .cancel) {
                    todoToDelete = nil
                }
            } message: {
                Text("Möchtest du diese Hausaufgabe wirklich löschen?")
            }
            
            Spacer()
        }
        .onAppear(perform: loadToDos)
       
    }
    
// MARK: - func
    
    // Json -> Array
    func loadToDos() {
        let savedTodos = UserDefaults.standard.string(forKey: "todos") ?? "[]"
        let data = Data(savedTodos.utf8)
        do {
            todos = try JSONDecoder().decode([TodoItem].self, from: data)
        } catch {
            todos = []
        }
    }
    
    func addToDo() {
        
        loadToDos()
        
        if field.isEmpty {
            return
        }
        
        let newItem = TodoItem(text: field, subject: selectedSubject.rawValue)
        todos.append(newItem)
        field = ""
        
        // Array -> Json
        if let newData = try? JSONEncoder().encode(todos),
           let jsonString = String(data: newData, encoding: .utf8) {
            UserDefaults.standard.set(jsonString, forKey: "todos")
        }
    }
    
    func toggleTodo(todo: TodoItem) {
        todoToDelete = todo
        showDeleteAlert = true
    }

    func confirmDelete() {
        guard let todo = todoToDelete else { return }
        
        loadToDos()
        todos.removeAll { $0.id == todo.id }
        
        // Array -> Json
        if let newData = try? JSONEncoder().encode(todos),
           let jsonString = String(data: newData, encoding: .utf8) {
            UserDefaults.standard.set(jsonString, forKey: "todos")
        }
        
        todoToDelete = nil
    }
    
}

#Preview {
    Homework()
}
