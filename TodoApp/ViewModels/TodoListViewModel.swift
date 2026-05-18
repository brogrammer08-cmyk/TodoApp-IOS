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
        let fetchedTodos = todoService.fetchTodos()
            
            switch currentSortOption {
            case .dueDateAscending:
                todos = fetchedTodos.sorted { $0.dueDate < $1.dueDate }
            case .dueDateDescending:
                todos = fetchedTodos.sorted { $0.dueDate > $1.dueDate }
            case .recentlyCreated:
                todos = fetchedTodos.sorted { $0.createdAt > $1.createdAt }
            case .completedFirst:
                todos = fetchedTodos.sorted { $0.isCompleted && !$1.isCompleted }
            case .pendingFirst:
                todos = fetchedTodos.sorted { !$0.isCompleted && $1.isCompleted }
            }
    }
    
    func changeSortOption(to option: SortOption) {
        currentSortOption = option
        applySort()
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
