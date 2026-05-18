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
            }
            .onDelete { indexSet in
                viewModel.deleteTodo(at: indexSet)
            }
        }
        .navigationTitle("My Todos")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.addButtonTapped()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    let mockService = InMemoryTodoService()
    let viewModel = TodoListViewModel(todoService: mockService)
    return TodoListView(viewModel: viewModel)
}
