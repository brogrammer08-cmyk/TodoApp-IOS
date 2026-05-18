//
//  TodoListView.swift
//  TodoApp
//
//  Created by Euglen on 18.5.26.
//

import SwiftUI

struct TodoListView: View {
    @StateObject var viewModel: TodoListViewModel
    
    var body: some View {
        ZStack {
            if viewModel.todos.isEmpty {
                // Empty State
                VStack(spacing: 20) {
                    Image(systemName: "checklist")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No todos yet")
                        .font(.title2)
                        .fontWeight(.medium)
                    Text("Tap + to create your first task.")
                        .font(.body)
                        .foregroundColor(.gray)
                }
            } else {
                // Todo List
                List {
                    ForEach(viewModel.todos, id: \.id) { todo in
                        HStack {
                            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(todo.isCompleted ? .green : .gray)
                                .onTapGesture {
                                    viewModel.toggleCompleted(for: todo)
                                }
                            VStack(alignment: .leading) {
                                Text(todo.title)
                                    .strikethrough(todo.isCompleted)
                                    .foregroundColor(todo.isCompleted ? .gray : .primary)
                                Text(todo.dueDate, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onTapGesture {
                            viewModel.todoSelected(todo)
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.deleteTodo(at: indexSet)
                    }
                }
            }
        }
        .navigationTitle("My Todos")
        .toolbar {
            // Sort button on the left
            ToolbarItem(placement: .navigationBarLeading) {
                Menu {
                    Button("Due Date (Earliest first)") {
                        viewModel.changeSortOption(to: .dueDateAscending)
                    }
                    Button("Due Date (Latest first)") {
                        viewModel.changeSortOption(to: .dueDateDescending)
                    }
                    Button("Recently Created") {
                        viewModel.changeSortOption(to: .recentlyCreated)
                    }
                    Button("Completed First") {
                        viewModel.changeSortOption(to: .completedFirst)
                    }
                    Button("Pending First") {
                        viewModel.changeSortOption(to: .pendingFirst)
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
            }
            
            // Add button on the right
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.addButtonTapped()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            viewModel.onAddTodo = { }
        }
    }
}

#Preview {
    let mockService = InMemoryTodoService()
    let viewModel = TodoListViewModel(todoService: mockService)
    return TodoListView(viewModel: viewModel)
}
