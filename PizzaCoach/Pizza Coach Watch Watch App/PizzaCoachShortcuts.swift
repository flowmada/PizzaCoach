//
//  PizzaCoachShortcuts.swift
//  Pizza Coach Watch Watch App
//
//  Defines available App Shortcuts for Siri
//

import AppIntents

struct PizzaCoachShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartPizzaIntent(),
            phrases: [
                "Start new pizza in \(.applicationName)",
                "Start pizza timer in \(.applicationName)",
                "Begin pizza in \(.applicationName)"
            ],
            shortTitle: "Start Pizza",
            systemImageName: "timer"
        )

        AppShortcut(
            intent: StopPizzaIntent(),
            phrases: [
                "Stop pizza timer in \(.applicationName)",
                "Stop pizza in \(.applicationName)",
                "End pizza timer in \(.applicationName)"
            ],
            shortTitle: "Stop Pizza",
            systemImageName: "stop.fill"
        )
    }
}
