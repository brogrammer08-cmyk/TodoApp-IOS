//
//  TodoDetailsView.swift
//  TodoApp
//
//  Created by Euglen on 19.5.26.
//

import SwiftUI

struct TodoDetailsView: View {
    @StateObject var viewModel: TodoDetailsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section(header: Text("Todo Information")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Title")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(viewModel.todo.title)
                        .font(.body)
                }
                .padding(.vertical, 4)
                
                if let description = viewModel.todo.todoDescription, !description.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(description)
                            .font(.body)
                    }
                    .padding(.vertical, 4)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Due Date")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(viewModel.formattedDueDate)
                        .font(.body)
                }
                .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Created At")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(viewModel.formattedCreatedDate)
                        .font(.body)
                }
                .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reminder")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(viewModel.reminderText)
                        .font(.body)
                }
                .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Status")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Text(viewModel.todo.isCompleted ? "Completed" : "Pending")
                            .font(.body)
                            .foregroundColor(viewModel.todo.isCompleted ? .green : .orange)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.toggleCompleted()
                        }) {
                            Text(viewModel.todo.isCompleted ? "Mark Pending" : "Mark Complete")
                                .font(.caption)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding(.vertical, 4)
            }
            
            Section(header: Text("Reminder Actions")) {
                Button("Update Reminder") {
                    // Will implement edit screen later
                }
                .disabled(true) // Temporarily disabled until edit screen is built
                
                Button("Disable Reminder") {
                    viewModel.disableReminder()
                }
                .foregroundColor(.red)
            }
            
            Section {
                Button("Edit Todo") {
                    viewModel.editTapped()
                }
                
                Button("Delete Todo") {
                    viewModel.deleteTodo()
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Todo Details")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(viewModel.$todo) { _ in
            // Refresh view when todo updates
        }
        .onDisappear {
            viewModel.onTodoUpdated?()
        }
    }
}

#Preview {
    let mockService = InMemoryTodoService()
    let sampleTodo = mockService.fetchTodos().first!
    let viewModel = TodoDetailsViewModel(todo: sampleTodo, todoService: mockService)
    return NavigationView {
        TodoDetailsView(viewModel: viewModel)
    }
}
