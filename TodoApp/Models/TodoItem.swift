//
//  TodoItem.swift
//  TodoApp
//
//  Created by Euglen on 16.5.26.
//

import Foundation

struct TodoItem: Identifiable {
    let id =  UUID()
    let title: String
    let todoDescription: String?
    let dueDate: Date
    var isCompleted: Bool
    let reminderType: ReminderType?
    let createdAt: Date
    
    init(
            title: String,
            todoDescription: String? = nil,
            dueDate: Date,
            isCompleted: Bool = false,
            reminderType: ReminderType? = nil,
            createdAt: Date = Date()
        ) {
            self.title = title
            self.todoDescription = todoDescription
            self.dueDate = dueDate
            self.isCompleted = isCompleted
            self.reminderType = reminderType
            self.createdAt = createdAt
        }
}
