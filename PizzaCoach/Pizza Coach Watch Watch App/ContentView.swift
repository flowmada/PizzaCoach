//
//  ContentView.swift
//  Pizza Coach Watch Watch App
//
//  Created by Adam Wolf on 11/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var timerManager = TimerManager()
    @State private var showStartFlash = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Timer Display
            Text(timerManager.formattedTime)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(timerManager.isRunning ? .green : .primary)

            // Status indicator
            if timerManager.isRunning {
                HStack(spacing: 4) {
                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)
                    Text("Running")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            // Button states based on timer running status
            if timerManager.isRunning {
                // Reset button - resets to 0:00 and keeps running
                Button(action: resetTimer) {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)

                // Stop button - stops and resets to 0:00
                Button(action: stopTimer) {
                    Label("Stop", systemImage: "stop.fill")
                        .font(.subheadline)
                }
                .buttonStyle(.bordered)
                .tint(.red)
            } else {
                // Start button - starts the timer
                Button(action: startTimer) {
                    Label("Start", systemImage: "play.fill")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }

            // Hidden button for double-clench gesture
            Button(action: handleDoubleClench) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .hidden()
            .handGestureShortcut(.primaryAction)
        }
        .padding()
        .overlay(
            // Flash overlay for visual feedback when starting
            Group {
                if showStartFlash {
                    Color.green.opacity(0.3)
                        .ignoresSafeArea()
                }
            }
        )
        .onAppear {
            // Wire up dependencies
            timerManager.hapticManager = HapticManager.shared
            WatchConnectivityManager.shared.timerManager = timerManager
        }
        .onReceive(NotificationCenter.default.publisher(for: .startPizzaTimer)) { _ in
            if timerManager.isRunning {
                resetTimer()
            } else {
                startTimer()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .stopPizzaTimer)) { _ in
            stopTimer()
        }
    }

    private func startTimer() {
        HapticManager.shared.playStartHaptic()
        timerManager.start()
        showFlash()
    }

    private func resetTimer() {
        HapticManager.shared.playStartHaptic()
        timerManager.reset()
        showFlash()
    }

    private func stopTimer() {
        HapticManager.shared.playStopHaptic()
        timerManager.stop()
    }

    private func handleDoubleClench() {
        if timerManager.isRunning {
            // Reset to 0:00 and keep running
            resetTimer()
        } else {
            // Start the timer
            startTimer()
        }
    }

    private func showFlash() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showStartFlash = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                showStartFlash = false
            }
        }
    }
}

#Preview {
    ContentView()
}
