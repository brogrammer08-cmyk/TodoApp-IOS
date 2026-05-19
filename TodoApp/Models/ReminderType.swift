//
//  ReminderType.swift
//  TodoApp
//
//  Created by Euglen on 16.5.26.
//

import Foundation

enum ReminderType: CaseIterable, Codable {
    case atTime
    case fiveMinutesBefore
    case fifteenMinutesBefore
    case oneHourBefore
    case oneDayBefore
    
    var displayName: String {
        switch self {
        case .atTime:
            return "At due date"
        case .fiveMinutesBefore:
            return "5 minutes before"
        case .fifteenMinutesBefore:
            return "15 minutes before"
        case .oneHourBefore:
            return "1 hour before"
        case .oneDayBefore:
            return "1 day before"
        }
    }
}
