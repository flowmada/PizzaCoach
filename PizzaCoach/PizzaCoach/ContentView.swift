//
//  ContentView.swift
//  PizzaCoach
//
//  Created by Adam Wolf on 11/1/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("firstRotation") private var firstRotation = 30
    @AppStorage("repeatInterval") private var repeatInterval = 15

    // Track what was last successfully synced to Watch
    @AppStorage("syncedFirstRotation") private var syncedFirstRotation: Int?
    @AppStorage("syncedRepeatInterval") private var syncedRepeatInterval: Int?

    @State private var firstRotationText = ""
    @State private var repeatIntervalText = ""
    @State private var syncError = false
    @State private var saveTask: Task<Void, Never>?

    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared

    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("First rotation")
                        Spacer()
                        TextField("Seconds", text: $firstRotationText)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }

                    HStack {
                        Text("Rotate every")
                        Spacer()
                        TextField("Seconds", text: $repeatIntervalText)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                } header: {
                    Text("Timer Settings")
                } footer: {
                    Text("Set how long to wait for the first rotation, then how often to rotate after that.")
                }

                // Only show error section if sync failed
                if syncError && connectivityManager.isReachable {
                    Section {
                        HStack {
                            Spacer()
                            Label("Unable to sync to Watch", systemImage: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                                .font(.subheadline)
                            Spacer()
                        }

                        Button(action: retrySync) {
                            HStack {
                                Spacer()
                                Text("Retry Sync")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Pizza Coach")
            .onAppear {
                // Load current values
                firstRotationText = String(firstRotation)
                repeatIntervalText = String(repeatInterval)
            }
            .onChange(of: firstRotationText) { _ in
                autoSaveSettings()
            }
            .onChange(of: repeatIntervalText) { _ in
                autoSaveSettings()
            }
            .onChange(of: connectivityManager.isReachable) { isReachable in
                if isReachable {
                    // Watch just connected, sync if needed
                    syncIfNeeded()
                } else {
                    // Watch disconnected, hide error
                    syncError = false
                }
            }
        }
    }

    private func autoSaveSettings() {
        // Cancel previous save task
        saveTask?.cancel()

        // Debounce: save 0.5 seconds after user stops typing
        saveTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

            guard !Task.isCancelled else { return }

            await MainActor.run {
                saveAndSyncSettings()
            }
        }
    }

    private func saveAndSyncSettings() {
        guard let first = Int(firstRotationText),
              let repeatInt = Int(repeatIntervalText),
              first > 0,
              repeatInt > 0 else {
            return
        }

        // Save to UserDefaults
        firstRotation = first
        repeatInterval = repeatInt

        // Sync to Watch if needed
        syncIfNeeded()
    }

    private func syncIfNeeded() {
        // Only sync if settings have changed from last successful sync
        let needsSync = syncedFirstRotation != firstRotation ||
                        syncedRepeatInterval != repeatInterval

        guard needsSync && connectivityManager.isReachable else {
            return
        }

        // Send to Watch
        let success = connectivityManager.sendSettings(
            firstRotation: firstRotation,
            repeatInterval: repeatInterval
        )

        if success {
            // Mark as synced
            syncedFirstRotation = firstRotation
            syncedRepeatInterval = repeatInterval
            syncError = false
        } else {
            // Show error
            syncError = true
        }
    }

    private func retrySync() {
        syncIfNeeded()
    }
}

#Preview {
    ContentView()
}
