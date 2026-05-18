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
        let todoListView = TodoListView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: todoListView)
        navigationController.pushViewController(hostingController, animated: true)
    }
}

