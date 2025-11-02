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

            // Stop/Reset Button
            Button(action: stopTimer) {
                Label("Stop", systemImage: "stop.fill")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .disabled(!timerManager.isRunning)

            // Hidden button for double-clench gesture
            Button(action: startNewPizza) {
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
            startNewPizza()
        }
        .onReceive(NotificationCenter.default.publisher(for: .stopPizzaTimer)) { _ in
            stopTimer()
        }
    }

    private func startNewPizza() {
        HapticManager.shared.playStartHaptic()
        timerManager.resetAndStart()

        // Show visual feedback
        withAnimation(.easeInOut(duration: 0.3)) {
            showStartFlash = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                showStartFlash = false
            }
        }
    }

    private func stopTimer() {
        HapticManager.shared.playStopHaptic()
        timerManager.stop()
    }
}

#Preview {
    ContentView()
}
