# RC Controller

RC Controller is a Flutter Bluetooth control interface for embedded systems and robotic vehicles. It sends simple command characters over Bluetooth Classic, making it suitable for Arduino, ESP32, STM32, HC-05/HC-06 modules, and similar hardware setups.

## Overview

The app is designed for practical embedded-system control: connect to a Bluetooth module, send movement commands, adjust speed, switch gear levels, and use cruise-style continuous movement. The interface uses a dark technical style with clear controls and immediate visual feedback.

## Features

- Bluetooth Classic connection flow
- Directional vehicle controls: forward, backward, left, right, and stop
- Four gear/speed levels
- Fine speed adjustment commands
- Manual and auto-pilot mode commands
- Cruise control style continuous forward movement
- Emergency stop behavior
- Provider-based state management
- Modular Flutter structure with constants, providers, services, screens, and widgets
- Dark UI with Google Fonts styling

## Tech Stack

- Flutter
- Dart
- Provider
- Bluetooth Classic
- Google Fonts
- Material UI

## Project Structure

```text
lib/
├── main.dart                  # App startup and global setup
├── constants/                 # Command values and shared constants
├── providers/                 # State management and control logic
├── services/                  # Bluetooth communication layer
├── screens/                   # Main app screens
└── widgets/                   # Reusable UI controls
```

## Command Protocol

The app sends ASCII command characters to the connected microcontroller.

| Command | Meaning |
| --- | --- |
| `F` | Move forward |
| `B` | Move backward |
| `L` | Turn left |
| `R` | Turn right |
| `S` | Stop |
| `1` | Gear 1 |
| `2` | Gear 2 |
| `3` | Gear 3 |
| `4` | Gear 4 |
| `+` | Increase speed |
| `-` | Decrease speed |
| `M` | Manual mode |
| `A` | Auto-pilot mode |

## Getting Started

### Requirements

- Flutter SDK 3.9.2 or newer
- Android device with Bluetooth support
- Bluetooth module paired with the phone, such as HC-05 or HC-06
- Microcontroller firmware that listens for the command characters above

### Run Locally

```bash
git clone https://github.com/dev-momensalman/IOT_Controller.git
cd IOT_Controller
flutter pub get
flutter run
```

## Hardware Review Notes

- Pair the Bluetooth module from Android system settings before testing the app.
- Confirm that the microcontroller baud rate matches the Bluetooth module configuration.
- The project is easiest to review by checking the command constants, Bluetooth service, and main control screen.
- The command protocol is intentionally simple so the app can work with many embedded platforms.

## Future Improvements

- Add automatic device discovery and reconnect handling
- Add connection status logs for debugging hardware issues
- Add configurable command mapping
- Add safety timeout if the connection drops while moving
- Add tests for state changes and command dispatching
