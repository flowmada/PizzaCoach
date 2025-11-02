# Pizza Coach

A simple Apple Watch timer app for managing pizza oven rotations with haptic alerts.

## Features

### iOS App
- Configure timer settings
- Set first rotation interval (default: 30 seconds)
- Set repeat rotation interval (default: 15 seconds)
- Settings sync automatically to Apple Watch

### watchOS App
- Stopwatch timer counting up from 0:00
- Haptic alerts at configured intervals
- **Double-clench gesture** to start/restart timer (Series 9+/Ultra 2+)
- Stop button to reset timer
- Visual feedback when timer starts
- Siri shortcuts support

### Siri Integration
- "Start new pizza" - Starts the timer
- "Stop pizza timer" - Stops and resets the timer

## Requirements

- **iOS:** 17.0+
- **watchOS:** 10.0+
- **Xcode:** 16.4+
- **Apple Watch:** Series 9+ or Ultra 2+ for double-clench gesture support

## Getting Started

1. Open `PizzaCoach.xcodeproj` in Xcode
2. Select your target device/simulator
3. Build and run the iOS app or Watch app

### iOS App Usage
1. Launch the Pizza Coach app on iPhone
2. Enter your preferred timer intervals
3. Tap "Save Settings" to sync to your Apple Watch

### Watch App Usage
1. Launch Pizza Coach on Apple Watch
2. **Double-clench** your fist to start the timer (or use Siri: "Start new pizza")
3. The watch will buzz at your configured intervals
4. Tap "Stop" to reset the timer

## Project Structure

```
PizzaCoach/
├── PizzaCoach/                    # iOS App
│   ├── ContentView.swift          # Settings UI
│   ├── WatchConnectivityManager.swift
│   └── PizzaCoachApp.swift
├── Pizza Coach Watch Watch App/   # watchOS App
│   ├── ContentView.swift          # Timer UI
│   ├── TimerManager.swift         # Timer logic
│   ├── HapticManager.swift        # Haptic feedback
│   ├── WatchConnectivityManager.swift
│   ├── StartPizzaIntent.swift     # Siri support
│   ├── StopPizzaIntent.swift
│   └── PizzaCoachShortcuts.swift
└── PLAN.md                        # Implementation plan
```

## Technical Details

- **Communication:** WatchConnectivity for iOS ↔ Watch sync
- **Persistence:** UserDefaults for settings storage
- **Timer:** Combine framework
- **Haptics:** WKInterfaceDevice
- **Gestures:** handGestureShortcut for double-clench
- **Voice:** App Intents for Siri integration

## License

MIT
