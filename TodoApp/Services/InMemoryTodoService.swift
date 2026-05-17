//
//  InMemoryTodoService.swift
//  TodoApp
//
//  Created by Euglen on 16.5.26.
//

import Foundation

class InMemoryTodoService: TodoServiceProtocol{
    
    
    private var todos: [TodoItem] = []
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        let now = Date()
        let calendar = Calendar.current
        
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now) ?? now
                let todo1 = TodoItem(
                    title: "Buy groceries",
                    todoDescription: "Milk, eggs, bread, and butter",
                    dueDate: yesterday,
                    isCompleted: true,
                    reminderType: nil,
                    createdAt: calendar.date(byAdding: .day, value: -2, to: now) ?? now
                )
        
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) ?? now
                let todo2 = TodoItem(
                    title: "Finish iOS project",
                    todoDescription: "Complete the MVVM-C to-do app",
                    dueDate: tomorrow,
                    isCompleted: false,
                    reminderType: nil,
                    createdAt: now
                )
        
        let nextWeek = calendar.date(byAdding: .day, value: 7, to: now) ?? now
                let todo3 = TodoItem(
                    title: "Doctor appointment",
                    todoDescription: "Annual checkup",
                    dueDate: nextWeek,
                    isCompleted: false,
                    reminderType: .oneDayBefore,
                    createdAt: now
                )
        
        todos = [todo1, todo2, todo3]
    }
    
    
    func fetchTodos() -> [TodoItem] {
            return todos
        }
        
    func addTodo(_ todo: TodoItem) {
            todos.append(todo)
        }
    
    func updateTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
        }
    }
        
    func deleteTodo(id: UUID) {
        todos.removeAll { $0.id == id }
            }
        
    func toggleCompleted(id: UUID) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
                    var todo = todos[index]
                    todo.isCompleted.toggle()  // Flips true/false
                    todos[index] = todo
                }
        }
        
    func saveTodos() {
                // TODO: Implement persistence later (bonus)
                print("saveTodos() called - persistence not yet implemented")
            }
            
    func loadTodos() {
        // TODO: Implement persistence later (bonus)
        print("loadTodos() called - persistence not yet implemented")
        }
    }
    
    

