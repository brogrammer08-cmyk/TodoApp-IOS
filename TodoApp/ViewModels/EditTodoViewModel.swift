//
//  EditTodoViewModel.swift
//  TodoApp
//
//  Created by Euglen on 19.5.26.
//

import Foundation
import Combine

class EditTodoViewModel: ObservableObject {
    @Published var title: String
    @Published var todoDescription: String
    @Published var dueDate: Date
    @Published var selectedReminderType: ReminderType?
    @Published var errorMessage: String?
    
    private let originalTodo: TodoItem
    private let todoService: TodoServiceProtocol
    
    var onSave: ((TodoItem) -> Void)?
    var onCancel: (() -> Void)?
    
    init(todo: TodoItem, todoService: TodoServiceProtocol) {
        self.originalTodo = todo
        self.todoService = todoService
        self.title = todo.title
        self.todoDescription = todo.todoDescription ?? ""
        self.dueDate = todo.dueDate
        self.selectedReminderType = todo.reminderType
    }
    
    func save() {
        // Validate title
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            errorMessage = "Title is required."
            return
        }
        
        guard trimmedTitle.count <= 100 else {
            errorMessage = "Title must be 100 characters or less."
            return
        }
        
        // Validate due date (cannot be in past)
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dueDateStartOfDay = calendar.startOfDay(for: dueDate)
        
        guard dueDateStartOfDay >= today else {
            errorMessage = "Due date cannot be in the past."
            return
        }
        
        // Create updated todo
        let updatedTodo = TodoItem(
            id: originalTodo.id,
            title: trimmedTitle,
            todoDescription: todoDescription.isEmpty ? nil : todoDescription,
            dueDate: dueDate,
            isCompleted: originalTodo.isCompleted,
            reminderType: selectedReminderType,
            createdAt: originalTodo.createdAt
        )
        
        onSave?(updatedTodo)
    }
    
    func cancel() {
        onCancel?()
    }
}

