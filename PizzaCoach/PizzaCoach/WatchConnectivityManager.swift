//
//  WatchConnectivityManager.swift
//  PizzaCoach
//
//  Manages communication between iOS app and Watch app
//

import Foundation
import WatchConnectivity

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()

    @Published var isReachable = false

    private override init() {
        super.init()

        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    @discardableResult
    func sendSettings(firstRotation: Int, repeatInterval: Int) -> Bool {
        guard WCSession.default.activationState == .activated else {
            print("WCSession not activated")
            return false
        }

        let settings: [String: Any] = [
            "firstRotation": firstRotation,
            "repeatInterval": repeatInterval
        ]

        // Try to send immediately if Watch is reachable
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(settings, replyHandler: nil) { error in
                print("Error sending message: \(error.localizedDescription)")
                // Fall back to updateApplicationContext if sendMessage fails
                self.updateContext(with: settings)
            }
            return true
        } else {
            // Use application context for background sync
            return updateContext(with: settings)
        }
    }

    @discardableResult
    private func updateContext(with settings: [String: Any]) -> Bool {
        do {
            try WCSession.default.updateApplicationContext(settings)
            print("Settings sent to Watch via context")
            return true
        } catch {
            print("Error updating application context: \(error.localizedDescription)")
            return false
        }
    }
}

// MARK: - WCSessionDelegate
extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }

        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession became inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession deactivated")
        // Reactivate the session for switching to new watch
        WCSession.default.activate()
    }
    #endif

    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }
        print("Watch reachability changed: \(session.isReachable)")
    }
}
