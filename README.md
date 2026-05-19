# TodoApp - iOS MVVM-C To-Do Application

## Overview

A production-style iOS To-Do application built with Swift, demonstrating the MVVM-C (Model-View-ViewModel-Coordinator) architecture pattern. The app allows users to create, edit, delete, and manage tasks with reminders and local notifications.

## Features

### Core Features
- ✅ Create, read, update, and delete todos
- ✅ Mark todos as complete/incomplete
- ✅ Set due dates with validation (cannot be in past)
- ✅ Add optional descriptions
- ✅ Local notifications with 5 reminder options (at time, 5min, 15min, 1 hour, 1 day before)
- ✅ Sort todos by 5 criteria (due date ascending/descending, recently created, completed first, pending first)
- ✅ Empty state with friendly message
- ✅ Pull to refresh
- ✅ Swipe to delete
- ✅ Persistent storage with UserDefaults

### Technical Highlights
- ✅ MVVM-C architecture with clear separation of concerns
- ✅ Hybrid UI: SwiftUI (List, Details, Edit) + UIKit (Add Todo form)
- ✅ Coordinator pattern for navigation
- ✅ Dependency injection via coordinators
- ✅ UserNotifications framework for reminders
- ✅ UserDefaults persistence with Codable
- ✅ NotificationCenter for cross-coordinator communication
## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.5+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/TodoApp.git

2.Open TodoApp.xcodeproj in Xcode

3.Build and run (⌘R)

