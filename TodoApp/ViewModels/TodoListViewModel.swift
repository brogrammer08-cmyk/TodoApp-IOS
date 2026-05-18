//
//  TodoListViewModel.swift
//  TodoApp
//
//  Created by Euglen on 18.5.26.
//

import Foundation
import Combine

class TodoListViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var currentSortOption: SortOption = .dueDateAscending
    
    private let todoService: TodoServiceProtocol
    
    // Navigation closure
    var onAddTodo: (() -> Void)?
    
    enum SortOption {
        case dueDateAscending
        case dueDateDescending
        case recentlyCreated
        case completedFirst
        case pendingFirst
    }
    
    init(todoService: TodoServiceProtocol) {
        self.todoService = todoService
        loadTodos()
    }
    
    func loadTodos() {
        applySort()
    }
    
    func applySort() {
        // You will implement sorting logic here
        // For now, just assign fetched todos
        todos = todoService.fetchTodos()
    }
    
    func toggleCompleted(for todo: TodoItem) {
        todoService.toggleCompleted(id: todo.id)
        loadTodos()
    }
    
    func deleteTodo(at offsets: IndexSet) {
        let idsToDelete = offsets.map { todos[$0].id }
        for id in idsToDelete {
            todoService.deleteTodo(id: id)
        }
        loadTodos()
    }
    
    func addTodo(_ todo: TodoItem) {
        todoService.addTodo(todo)
        loadTodos()
    }
    
    // - Navigation Actions
    
    func addButtonTapped() {
        onAddTodo?()
    }
}
