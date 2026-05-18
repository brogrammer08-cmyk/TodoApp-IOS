//
//  AddTodoViewModel.swift
//  TodoApp
//
//  Created by Euglen on 18.5.26.
//

import Foundation
import Combine

class AddTodoViewModel: ObservableObject {
    @Published var title = ""
    @Published var todoDescription = ""
    @Published var dueDate = Date()
    @Published var selectedReminderType: ReminderType?
    @Published var errorMessage: String?
    
    var onSave: ((TodoItem) -> Void)?
    var onCancel: (() -> Void)?
    
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
        
        // Create todo
        let newTodo = TodoItem(
            title: trimmedTitle,
            todoDescription: todoDescription.isEmpty ? nil : todoDescription,
            dueDate: dueDate,
            isCompleted: false,
            reminderType: selectedReminderType
        )
        
        // Schedule notification if reminder is set
            if selectedReminderType != nil {
                NotificationService.shared.scheduleNotification(for: newTodo)
            }
        
        onSave?(newTodo)
    }
    
    func cancel() {
        onCancel?()
    }
}
