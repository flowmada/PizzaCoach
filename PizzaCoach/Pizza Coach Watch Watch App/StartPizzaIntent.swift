//
//  StartPizzaIntent.swift
//  Pizza Coach Watch Watch App
//
//  App Intent for "Start new pizza" Siri command
//

import AppIntents
import Foundation

struct StartPizzaIntent: AppIntent {
    static var title: LocalizedStringResource = "Start New Pizza"
    static var description = IntentDescription("Starts the pizza timer on your Apple Watch")

    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        // Post notification to start timer
        NotificationCenter.default.post(name: .startPizzaTimer, object: nil)

        return .result(dialog: "Pizza timer started! Time to cook!")
    }
}

// Notification name
extension Notification.Name {
    static let startPizzaTimer = Notification.Name("startPizzaTimer")
}
