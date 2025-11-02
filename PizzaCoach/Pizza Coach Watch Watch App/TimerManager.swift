//
//  TimerManager.swift
//  Pizza Coach Watch Watch App
//
//  Manages the stopwatch timer and haptic feedback triggers
//

import Foundation
import Combine

class TimerManager: ObservableObject {
    @Published var isRunning = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var formattedTime = "0:00"

    private var timer: AnyCancellable?
    private var startTime: Date?

    // Settings from iOS app
    @Published var firstRotationSeconds = 30
    @Published var repeatIntervalSeconds = 15

    // Track when haptics should fire
    private var lastHapticTime: TimeInterval = 0
    private var hasTriggeredFirstRotation = false

    var hapticManager: HapticManager?

    init() {
        loadSettings()
    }

    func start() {
        guard !isRunning else { return }

        isRunning = true
        startTime = Date()
        hasTriggeredFirstRotation = false
        lastHapticTime = 0

        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTime()
            }
    }

    func stop() {
        isRunning = false
        timer?.cancel()
        timer = nil
        reset()
    }

    func reset() {
        elapsedTime = 0
        formattedTime = "0:00"
        hasTriggeredFirstRotation = false
        lastHapticTime = 0
    }

    func resetAndStart() {
        stop()
        start()
    }

    private func updateTime() {
        guard let startTime = startTime else { return }

        elapsedTime = Date().timeIntervalSince(startTime)
        formattedTime = formatTime(elapsedTime)

        checkForHapticTrigger()
    }

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func checkForHapticTrigger() {
        let elapsed = Int(elapsedTime)

        // First rotation haptic
        if !hasTriggeredFirstRotation && elapsed >= firstRotationSeconds {
            hapticManager?.playRotationHaptic()
            hasTriggeredFirstRotation = true
            lastHapticTime = elapsedTime
        }
        // Subsequent rotation haptics
        else if hasTriggeredFirstRotation && (elapsedTime - lastHapticTime) >= Double(repeatIntervalSeconds) {
            hapticManager?.playRotationHaptic()
            lastHapticTime = elapsedTime
        }
    }

    func loadSettings() {
        let defaults = UserDefaults.standard
        firstRotationSeconds = defaults.integer(forKey: "firstRotation")
        repeatIntervalSeconds = defaults.integer(forKey: "repeatInterval")

        // Use defaults if not set
        if firstRotationSeconds == 0 {
            firstRotationSeconds = 30
        }
        if repeatIntervalSeconds == 0 {
            repeatIntervalSeconds = 15
        }
    }

    func updateSettings(firstRotation: Int, repeatInterval: Int) {
        firstRotationSeconds = firstRotation
        repeatIntervalSeconds = repeatInterval

        // Save to UserDefaults
        let defaults = UserDefaults.standard
        defaults.set(firstRotation, forKey: "firstRotation")
        defaults.set(repeatInterval, forKey: "repeatInterval")

        print("Timer settings updated: first=\(firstRotation)s, repeat=\(repeatInterval)s")
    }
}
