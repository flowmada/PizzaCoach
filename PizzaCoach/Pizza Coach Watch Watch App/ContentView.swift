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
        VStack(spacing: 16) {
            Spacer()

            // Timer Display
            Text(timerManager.formattedTime)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(timerManager.isRunning ? .green : .primary)

            Spacer()

            // Start/Reset button - starts if stopped, resets if running
            Button(action: startOrResetTimer) {
                Label(timerManager.isRunning ? "Reset" : "Start",
                      systemImage: timerManager.isRunning ? "arrow.counterclockwise" : "play.fill")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
            .tint(timerManager.isRunning ? .orange : .green)

            // Stop button - always visible, stops and resets to 0:00
            Button(action: stopTimer) {
                Label("Stop", systemImage: "stop.fill")
                    .font(.headline)
            }
            .buttonStyle(.bordered)
            .tint(.red)

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
            startOrResetTimer()
        }
        .onReceive(NotificationCenter.default.publisher(for: .stopPizzaTimer)) { _ in
            stopTimer()
        }
    }

    private func startOrResetTimer() {
        HapticManager.shared.playStartHaptic()
        if timerManager.isRunning {
            timerManager.reset()
        } else {
            timerManager.start()
        }
        showFlash()
    }

    private func stopTimer() {
        HapticManager.shared.playStopHaptic()
        timerManager.stop()
    }

    private func handleDoubleClench() {
        startOrResetTimer()
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
