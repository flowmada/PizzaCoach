//
//  HapticManager.swift
//  Pizza Coach Watch Watch App
//
//  Manages haptic feedback for rotation alerts
//

import Foundation
import WatchKit

class HapticManager {
    static let shared = HapticManager()

    private init() {}

    func playRotationHaptic() {
        // Play a notification haptic for pizza rotation alerts
        WKInterfaceDevice.current().play(.notification)
        print("Haptic played: Time to rotate!")
    }

    func playStartHaptic() {
        // Play a subtle haptic when timer starts
        WKInterfaceDevice.current().play(.start)
    }

    func playStopHaptic() {
        // Play a subtle haptic when timer stops
        WKInterfaceDevice.current().play(.stop)
    }
}
