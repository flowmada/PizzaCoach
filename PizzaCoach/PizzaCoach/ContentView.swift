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

    @State private var firstRotationText = ""
    @State private var repeatIntervalText = ""
    @State private var showingSaved = false

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

                Section {
                    Button(action: saveSettings) {
                        HStack {
                            Spacer()
                            Text("Save Settings")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .disabled(firstRotationText.isEmpty || repeatIntervalText.isEmpty)

                    if showingSaved {
                        HStack {
                            Spacer()
                            if connectivityManager.isReachable {
                                Label("Saved & synced to Watch", systemImage: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                    .font(.subheadline)
                            } else {
                                Label("Saved (Watch not connected)", systemImage: "checkmark.circle.fill")
                                    .foregroundStyle(.orange)
                                    .font(.subheadline)
                            }
                            Spacer()
                        }
                    }
                }

                Section {
                    HStack {
                        Text("Watch Status")
                        Spacer()
                        Label(
                            connectivityManager.isReachable ? "Connected" : "Not Connected",
                            systemImage: connectivityManager.isReachable ? "applewatch" : "applewatch.slash"
                        )
                        .foregroundStyle(connectivityManager.isReachable ? .green : .secondary)
                        .font(.subheadline)
                    }
                } footer: {
                    Text("Settings will sync to your Apple Watch when connected.")
                }
            }
            .navigationTitle("Pizza Coach")
            .onAppear {
                // Load current values
                firstRotationText = String(firstRotation)
                repeatIntervalText = String(repeatInterval)
            }
        }
    }

    private func saveSettings() {
        guard let first = Int(firstRotationText),
              let repeatInt = Int(repeatIntervalText),
              first > 0,
              repeatInt > 0 else {
            return
        }

        // Save to UserDefaults
        firstRotation = first
        repeatInterval = repeatInt

        // Send to Watch
        connectivityManager.sendSettings(firstRotation: first, repeatInterval: repeatInt)

        // Show confirmation
        withAnimation {
            showingSaved = true
        }

        // Hide confirmation after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showingSaved = false
            }
        }
    }
}

#Preview {
    ContentView()
}
