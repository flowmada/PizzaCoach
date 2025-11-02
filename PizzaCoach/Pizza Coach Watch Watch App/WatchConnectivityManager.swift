//
//  WatchConnectivityManager.swift
//  Pizza Coach Watch Watch App
//
//  Manages receiving settings from the iOS app
//

import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()

    var timerManager: TimerManager?

    private override init() {
        super.init()

        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    private func handleSettings(_ settings: [String: Any]) {
        guard let firstRotation = settings["firstRotation"] as? Int,
              let repeatInterval = settings["repeatInterval"] as? Int else {
            print("Invalid settings received")
            return
        }

        print("Received settings from iPhone: first=\(firstRotation)s, repeat=\(repeatInterval)s")

        // Update timer manager
        DispatchQueue.main.async {
            self.timerManager?.updateSettings(firstRotation: firstRotation, repeatInterval: repeatInterval)
        }
    }
}

// MARK: - WCSessionDelegate
extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated on Watch with state: \(activationState.rawValue)")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("Received message from iPhone")
        handleSettings(message)
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        print("Received application context from iPhone")
        handleSettings(applicationContext)
    }
}
