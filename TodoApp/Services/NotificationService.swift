//
//  NotificationService.swift
//  TodoApp
//
//  Created by Euglen on 19.5.26.
//

import Foundation
import UserNotifications

class NotificationService {
    
    static let shared = NotificationService()
    
    private init() {}
    
    // Request permission from user
    func requestPermission(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
            completion(granted)
        }
    }
    
    // Schedule a notification for a todo
    func scheduleNotification(for todo: TodoItem) {
        guard let reminderType = todo.reminderType else { return }
        
        // Calculate notification date based on reminder type
        let notificationDate = calculateNotificationDate(from: todo.dueDate, reminderType: reminderType)
        
        // Don't schedule if notification date is in the past
        guard notificationDate > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Todo Reminder"
        content.body = "\(todo.title) is due at \(formattedTime(todo.dueDate))"
        content.sound = .default
        content.userInfo = ["todoId": todo.id.uuidString]
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: calendarComponents(from: notificationDate),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: todo.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(todo.title)")
            }
        }
    }
    
    // Cancel notification for a todo
    func cancelNotification(for todoId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [todoId.uuidString])
        print("Cancelled notification for todo: \(todoId)")
    }
    
    // Update notification (cancel old, schedule new)
    func updateNotification(for todo: TodoItem) {
        cancelNotification(for: todo.id)
        scheduleNotification(for: todo)
    }
    
    // Helper Methods
    
    private func calculateNotificationDate(from dueDate: Date, reminderType: ReminderType) -> Date {
        let calendar = Calendar.current
        
        switch reminderType {
        case .atTime:
            return dueDate
        case .fiveMinutesBefore:
            return calendar.date(byAdding: .minute, value: -5, to: dueDate) ?? dueDate
        case .fifteenMinutesBefore:
            return calendar.date(byAdding: .minute, value: -15, to: dueDate) ?? dueDate
        case .oneHourBefore:
            return calendar.date(byAdding: .hour, value: -1, to: dueDate) ?? dueDate
        case .oneDayBefore:
            return calendar.date(byAdding: .day, value: -1, to: dueDate) ?? dueDate
        }
    }
    
    private func calendarComponents(from date: Date) -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
