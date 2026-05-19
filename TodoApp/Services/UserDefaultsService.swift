//
//  UserDefaultsService.swift
//  TodoApp
//
//  Created by Euglen on 19.5.26.
//


import Foundation

class UserDefaultsService {
    
    private let userDefaults = UserDefaults.standard
    private let todosKey = "saved_todos"
    
    // Save todos array to UserDefaults
    func saveTodos(_ todos: [TodoItem]) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(todos)
            userDefaults.set(data, forKey: todosKey)
            print(" Saved \(todos.count) todos to UserDefaults")
        } catch {
            print(" Failed to save todos: \(error.localizedDescription)")
        }
    }
    
    // Load todos array from UserDefaults
    func loadTodos() -> [TodoItem] {
        guard let data = userDefaults.data(forKey: todosKey) else {
            print(" No saved todos found, returning empty array")
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let todos = try decoder.decode([TodoItem].self, from: data)
            print(" Loaded \(todos.count) todos from UserDefaults")
            return todos
        } catch {
            print(" Failed to load todos: \(error.localizedDescription)")
            return []
        }
    }
    
    // Check if there are saved todos
    func hasSavedTodos() -> Bool {
        return userDefaults.data(forKey: todosKey) != nil
    }
    
    // Clear all saved todos (for testing)
    func clearAllTodos() {
        userDefaults.removeObject(forKey: todosKey)
        print("🗑️ Cleared all saved todos from UserDefaults")
    }
}
