# Pizza Coach - MVP Implementation Plan

## Project Overview
**App Name:** Pizza Coach
**Bundle ID:** net.4wolfs.pizzacoach
**Targets:** iOS 17+ and watchOS 10+
**Goal:** Simple pizza oven timer with haptic alerts

## Current Project Structure
```
PizzaCoach/
├── PizzaCoach/                          # iOS App
│   ├── PizzaCoachApp.swift
│   ├── ContentView.swift                # To be replaced with settings UI
│   └── Assets.xcassets/
├── Pizza Coach Watch Watch App/         # watchOS App
│   ├── Pizza_Coach_WatchApp.swift
│   ├── ContentView.swift                # To be replaced with stopwatch UI
│   └── Assets.xcassets/
├── PizzaCoachTests/
├── PizzaCoachUITests/
├── Pizza Coach Watch Watch AppTests/
└── Pizza Coach Watch Watch AppUITests/
```

---

## Implementation Checklist

### ✅ Phase 1: Project Setup
- [ ] Create `.gitignore` for Xcode projects
- [ ] Document initial architecture

### Phase 2: iOS App (Settings)
- [ ] Create `WatchConnectivityManager.swift` - Handle iOS ↔ Watch sync
- [ ] Replace `ContentView.swift` with settings UI:
  - Text field: "First rotation (seconds)" - default 30
  - Text field: "Rotate every (seconds)" - default 15
  - Save button
  - Persist to UserDefaults
  - Send settings to Watch via WatchConnectivity

### Phase 3: watchOS App (Stopwatch Timer)
- [ ] Create `TimerManager.swift` - Core timer logic
  - Count up from 0:00
  - Track elapsed time
  - Calculate haptic trigger times
  - Start/stop/reset operations
- [ ] Create `WatchConnectivityManager.swift` - Receive settings from iOS
- [ ] Create `HapticManager.swift` - Trigger haptics at intervals
- [ ] Replace `ContentView.swift` with stopwatch UI:
  - Display time in MM:SS format
  - Stop button (stops and resets)
  - Visual feedback on start/reset
  - Double-clench gesture support (Series 9+/Ultra 2+)

### Phase 4: Siri Integration
- [ ] Create `AppIntents/StartPizzaIntent.swift` (iOS & Watch)
- [ ] Create `AppIntents/StopPizzaIntent.swift` (iOS & Watch)
- [ ] Configure Siri capabilities

### Phase 5: Testing & Polish
- [ ] Test iOS settings sync to Watch
- [ ] Test Watch stopwatch functionality
- [ ] Test double-clench gesture
- [ ] Test haptic alerts at correct intervals
- [ ] Test Siri commands
- [ ] Verify builds succeed for both targets

### Phase 6: Ship It
- [ ] Commit all changes to git
- [ ] Update README.md with usage instructions
- [ ] Push to GitHub

---

## Technical Architecture

### iOS App
**Purpose:** Configuration interface
**Components:**
- `ContentView`: Settings form
- `WatchConnectivityManager`: Sync to Watch
- UserDefaults for persistence

### watchOS App
**Purpose:** Timer with haptic alerts
**Components:**
- `ContentView`: Stopwatch UI + controls
- `TimerManager`: Timer logic + state
- `HapticManager`: Vibration at intervals
- `WatchConnectivityManager`: Receive settings
- UserDefaults for persistence

### Communication Flow
```
iOS Settings UI
    ↓ (Save)
UserDefaults (iOS)
    ↓ (WatchConnectivity)
UserDefaults (Watch)
    ↓ (Notify)
TimerManager (Watch)
    ↓ (Intervals)
HapticManager (Watch)
```

### Key APIs
- **WatchConnectivity** - Sync settings iOS → Watch
- **Combine Timer** - Stopwatch countdown
- **WKInterfaceDevice** - Haptic feedback
- **handGestureShortcut** - Double-clench gesture (watchOS 10+)
- **App Intents** - Siri commands

---

## MVP Constraints
- No user profiles
- No pizza history
- No custom haptic patterns
- Simple two-number configuration
- Focus on core timer functionality

---

## Future Enhancements (Post-MVP)
- Multiple timer presets
- Pizza type templates (Neapolitan, NY style, etc.)
- History/log of cook times
- Complications for watch face
- Custom haptic patterns
- Temperature tracking integration
