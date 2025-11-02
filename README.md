# Pizza Coach

A simple Apple Watch timer app for managing pizza oven rotations with haptic alerts.

## Features

### iOS App
- **Auto-save settings** - Settings save automatically as you type (no Save button!)
- **Smart auto-sync** - Only syncs to Watch when settings actually change
- Set first rotation interval (default: 30 seconds)
- Set repeat rotation interval (default: 15 seconds)
- Error handling with retry if sync fails
- Clean UI - no clutter unless there's a problem

### watchOS App
- Stopwatch timer counting up from 0:00 (MM:SS format)
- Haptic alerts at configured intervals
- **Start/Reset button** - Changes label based on state (green when stopped, orange when running)
- **Stop button** - Always visible, stops and resets to 0:00
- **Double-clench gesture** to start/reset timer (Series 9+/Ultra 2+)
- Visual flash feedback when timer starts/resets
- Timer color changes to green when running

### Siri Integration
- "Start new pizza" - Starts timer (or resets if already running)
- "Stop pizza timer" - Stops and resets the timer

## Requirements

- **iOS:** 17.0+
- **watchOS:** 10.0+
- **Xcode:** 16.4+
- **Apple Watch:** Series 9+ or Ultra 2+ for double-clench gesture support

## Getting Started

### Testing with Simulators

1. Open `PizzaCoach/PizzaCoach.xcodeproj` in Xcode
2. Select the **"Pizza Coach Watch Watch App"** scheme
3. Choose destination: **"iPhone 16 Pro + Watch"** (paired simulator)
4. Run (⌘R) - launches both iPhone and Watch simulators

**Note:** If you don't see paired simulators, create one:
```bash
# From repo root
xcrun simctl create "iPhone 16 Pro + Watch" "iPhone 16 Pro"
xcrun simctl create "Apple Watch Series 10" "Apple Watch Series 10 (46mm)"
xcrun simctl pair <watch-id> <iphone-id>
```

### iOS App Usage
1. Launch the Pizza Coach app on iPhone
2. Enter your preferred timer intervals (settings auto-save as you type!)
3. Settings auto-sync to Watch when connected
4. If sync fails, you'll see "⚠️ Unable to sync to Watch" with a Retry button

### Watch App Usage
1. Launch Pizza Coach on Apple Watch
2. Tap **"Start"** to begin timer (or **double-clench** your fist, or say "Hey Siri, start new pizza")
3. The watch will buzz at your configured intervals
4. Button changes to **"Reset"** (orange) while running - taps reset to 0:00 and keep running
5. Tap **"Stop"** (red) to stop and reset to 0:00

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
- **Smart Sync:** Tracks last synced values to avoid redundant updates
- **Auto-save:** 0.5s debounced saving on text field changes
- **Persistence:** UserDefaults for settings storage (both iOS and Watch)
- **Timer:** Combine framework with 0.1s updates
- **Haptics:** WKInterfaceDevice.current().play() for rotation alerts
- **Gestures:** handGestureShortcut(.primaryAction) for double-clench
- **Voice:** App Intents for Siri integration

## Next Steps

### Immediate Testing
- [ ] Test WatchConnectivity sync between iPhone and Watch simulators
- [ ] Verify auto-save works with 0.5s debounce
- [ ] Test timer accuracy and haptic feedback timing
- [ ] Verify Start/Reset/Stop button behavior
- [ ] Test error state when sync fails

### Future Enhancements
- [ ] **Watch Complications** - Show timer status on watch face
- [ ] **Multiple Presets** - Save favorite timer configurations (Neapolitan, NY style, etc.)
- [ ] **History Log** - Track past pizza cooking sessions
- [ ] **Custom Haptic Patterns** - Different patterns for first rotation vs subsequent
- [ ] **Temperature Integration** - Pair with oven temperature monitoring
- [ ] **Sound Alerts** - Optional audio alerts in addition to haptics
- [ ] **Timer Pause** - Ability to pause/resume instead of just stop
- [ ] **Background Running** - Keep timer running when app is in background
- [ ] **Export Settings** - Share timer presets with other users

### Code Improvements
- [ ] Add unit tests for TimerManager logic
- [ ] Add UI tests for Watch app interactions
- [ ] Improve error handling for WatchConnectivity edge cases
- [ ] Add logging/analytics for debugging sync issues
- [ ] Optimize battery usage during long timer sessions

### Deployment
- [ ] Set up App Store Connect
- [ ] Create app icons and screenshots
- [ ] Write App Store description
- [ ] Submit for TestFlight beta testing
- [ ] Gather user feedback
- [ ] Release v1.0 to App Store

## License

MIT
