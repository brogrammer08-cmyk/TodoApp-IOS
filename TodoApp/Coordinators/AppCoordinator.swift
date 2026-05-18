//
//  AppCoordinator.swift
//  TodoApp
//
//  Created by Euglen on 18.5.26.
//

import Foundation
import UIKit
import SwiftUI

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    private let todoService: TodoServiceProtocol
    
    init(window: UIWindow){
        self.window = window
        self.navigationController = UINavigationController()
        self.todoService = InMemoryTodoService()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // Request notification permissions
        NotificationService.shared.requestPermission { granted in
            print("Notification permission granted: \(granted)")
        }
        
        // Create and start TodoListCoordinator
        let todoListCoordinator = TodoListCoordinator(
            navigationController: navigationController,
            todoService: todoService
        )
        childCoordinators.append(todoListCoordinator)
        todoListCoordinator.start()
    }

}
