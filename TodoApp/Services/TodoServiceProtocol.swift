//
//  TodoServiceProtocol.swift
//  TodoApp
//
//  Created by Euglen on 16.5.26.
//

import Foundation

protocol TodoServiceProtocol {
    
    func fetchTodos() -> [TodoItem]
    
    func addTodo(_ todo: TodoItem)
    
    func updateTodo(_ todo: TodoItem)
    
    func deleteTodo(id: UUID)
    
    func toggleCompleted(id: UUID)
    
    func saveTodos()
    
    func loadTodos()
    
}
