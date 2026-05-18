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
        
        print("AppCoordinator started - TodoListCoordinator coming next")
    }
}
