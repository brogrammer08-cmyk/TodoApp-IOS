//
//  Coordinator.swift
//  TodoApp
//
//  Created by Euglen on 18.5.26.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }              
    func start()
}
