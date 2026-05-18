//
//  TodoDetailsViewModel.swift
//  TodoApp
//
//  Created by Euglen on 19.5.26.
//

import Foundation
import Combine

class TodoDetailsViewModel: ObservableObject {
    @Published var todo: TodoItem
    private let todoService: TodoServiceProtocol
    
    var onTodoUpdated: (() -> Void)?
    var onDelete: (() -> Void)?
    var onEdit: ((TodoItem) -> Void)?
    
    init(todo: TodoItem, todoService: TodoServiceProtocol) {
        self.todo = todo
        self.todoService = todoService
    }
    
    func toggleCompleted() {
        todoService.toggleCompleted(id: todo.id)
        if let updatedTodo = todoService.fetchTodos().first(where: { $0.id == todo.id }) {
            todo = updatedTodo
        }
        onTodoUpdated?()
    }
    
    func deleteTodo() {
        todoService.deleteTodo(id: todo.id)
        onDelete?()
    }
    
    func updateReminder(to reminderType: ReminderType?) {
        var updatedTodo = todo
        updatedTodo.reminderType = reminderType
        todoService.updateTodo(updatedTodo)
        todo = updatedTodo
        onTodoUpdated?()
    }
    
    func disableReminder() {
        updateReminder(to: nil)
    }
    
    func editTapped() {
        onEdit?(todo)
    }
    
    // Formatted strings for display
    var formattedDueDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: todo.dueDate)
    }
    
    var formattedCreatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: todo.createdAt)
    }
    
    var reminderText: String {
        guard let reminderType = todo.reminderType else {
            return "No reminder set"
        }
        return reminderType.displayName
    }
}
