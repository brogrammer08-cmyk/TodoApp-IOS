//
//  TodoItem.swift
//  TodoApp
//
//  Created by Euglen on 16.5.26.
//

import Foundation

struct TodoItem: Identifiable, Equatable {
    let id: UUID
    let title: String
    let todoDescription: String?
    let dueDate: Date
    var isCompleted: Bool
    let reminderType: ReminderType?
    let createdAt: Date
    
    init(
        id: UUID = UUID(),
        title: String,
        todoDescription: String? = nil,
        dueDate: Date,
        isCompleted: Bool = false,
        reminderType: ReminderType? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.todoDescription = todoDescription
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.reminderType = reminderType
        self.createdAt = createdAt
    }
    
    // Equatable conformance - compares only id
    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        lhs.id == rhs.id
    }
}
