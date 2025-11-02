//
//  StopPizzaIntent.swift
//  Pizza Coach Watch Watch App
//
//  App Intent for "Stop pizza timer" Siri command
//

import AppIntents
import Foundation

struct StopPizzaIntent: AppIntent {
    static var title: LocalizedStringResource = "Stop Pizza Timer"
    static var description = IntentDescription("Stops and resets the pizza timer")

    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        // Post notification to stop timer
        NotificationCenter.default.post(name: .stopPizzaTimer, object: nil)

        return .result(dialog: "Pizza timer stopped")
    }
}

// Notification name
extension Notification.Name {
    static let stopPizzaTimer = Notification.Name("stopPizzaTimer")
}
