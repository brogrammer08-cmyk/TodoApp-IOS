//
//  EditTodoView.swift
//  TodoApp
//
//  Created by Euglen on 19.5.26.
//

import SwiftUI

struct EditTodoView: View {
    @StateObject var viewModel: EditTodoViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Todo Details")) {
                    TextField("Title *", text: $viewModel.title)
                        .textInputAutocapitalization(.sentences)
                        .onChange(of: viewModel.title) {
                            viewModel.errorMessage = nil
                        }
                    
                    TextField("Description (optional)", text: $viewModel.todoDescription, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker("Select date and time",
                               selection: $viewModel.dueDate,
                               in: Date()...,
                               displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("Reminder")) {
                    Picker("Remind me", selection: $viewModel.selectedReminderType) {
                        Text("No reminder").tag(nil as ReminderType?)
                        ForEach(ReminderType.allCases, id: \.self) { reminder in
                            Text(reminder.displayName).tag(reminder as ReminderType?)
                        }
                    }
                }
                
                if let error = viewModel.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Edit Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.cancel()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save()
                    }
                    .bold()
                }
            }
        }
    }
}

#Preview {
    let mockService = InMemoryTodoService()
    let sampleTodo = mockService.fetchTodos().first!
    let viewModel = EditTodoViewModel(todo: sampleTodo, todoService: mockService)
    return EditTodoView(viewModel: viewModel)
}
