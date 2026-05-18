//
//  TodoListCoordinator.swift
//  TodoApp
//
//  Created by Euglen on 18.5.26.
//

import Foundation
import UIKit
import SwiftUI

class TodoListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let todoService: TodoServiceProtocol
    
    init(navigationController: UINavigationController, todoService: TodoServiceProtocol) {
        self.navigationController = navigationController
        self.todoService = todoService
    }
    
    func start() {
        let viewModel = TodoListViewModel(todoService: todoService)
        
        // Set up navigation closure
        viewModel.onAddTodo = { [weak self] in
            self?.showAddTodoScreen()
        }
        
        viewModel.onTodoSelected = { [weak self] todo in
            self?.showTodoDetails(for: todo)
        }
        
        let todoListView = TodoListView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: todoListView)
        navigationController.pushViewController(hostingController, animated: true)
        
    }
    
    func showAddTodoScreen() {
        let addViewModel = AddTodoViewModel()
        
        addViewModel.onSave = { [weak self] newTodo in
            self?.todoService.addTodo(newTodo)
            self?.navigationController.dismiss(animated: true)
            // Refresh the list
            if let hostingVC = self?.navigationController.viewControllers.first as? UIHostingController<TodoListView> {
                hostingVC.rootView.viewModel.loadTodos()
            }
        }
        
        addViewModel.onCancel = { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        
        let addViewController = AddTodoViewController(viewModel: addViewModel)
        let navController = UINavigationController(rootViewController: addViewController)
        self.navigationController.present(navController, animated: true)
    }
    
    func showTodoDetails(for todo: TodoItem) {
        let detailsViewModel = TodoDetailsViewModel(todo: todo, todoService: todoService)
        
        detailsViewModel.onDelete = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        detailsViewModel.onTodoUpdated = { [weak self] in
            // Refresh the list
            if let hostingVC = self?.navigationController.viewControllers.first as? UIHostingController<TodoListView> {
                hostingVC.rootView.viewModel.loadTodos()
            }
        }
        
        let detailsView = TodoDetailsView(viewModel: detailsViewModel)
        let hostingController = UIHostingController(rootView: detailsView)
        navigationController.pushViewController(hostingController, animated: true)
    }
}

