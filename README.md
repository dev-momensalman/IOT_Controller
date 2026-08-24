# 🏎️ RC Drive
### Bluetooth RC Car Controller — Flutter

---

## 🌟 Overview

**RC Drive** is a professional-grade mobile controller for RC cars and embedded systems, built with **Flutter**. It communicates over **Bluetooth Classic** to deliver real-time, low-latency commands to any microcontroller (Arduino, ESP32, STM32, etc.).

The app is engineered around three pillars:
- ⚡ **Ultra-Low Latency** — 80ms throttle engine prevents command flooding
- 🎯 **Precision Control** — D-Pad, Gear Selector, Speed Trim, and Mode Switching
- 🖤 **Premium Dark UI** — Glassmorphism, Roboto Mono, and neon cyan accents

---

## ✨ Features

### 🕹️ Control Interface
- **D-Pad** — Ergonomic directional pad with instant tactile-style visual feedback
- **Speed Trim** — Fine-tune speed with `+` / `−` controls
- **Gear Selector** — 4 switchable power gears for terrain adaptation
- **Cruise Control** — Latch mode for sustained forward movement + emergency stop

### 📡 Connectivity
- **Bluetooth Classic** pairing with HC-05/HC-06 modules
- Auto-reconnect detection and real-time connection status in the header
- Low-latency command throttle (configurable, default 80ms)

### 🖥️ Terminal Screen *(New)*
- Dedicated screen to **send any custom command or raw string** via Bluetooth
- Console-style log with timestamps, TX labels, and color-coded entries
- Auto-scrolling output with full history
- Keyboard-aware layout (no overflow on keyboard dismiss)

### 📋 Smart Header *(Redesigned)*
Two-row layout to eliminate crowding:
- **Row 1:** Connection status dot + device name + mode badge
- **Row 2:** Last sent command history + Terminal button + Instructions button

### 💬 Callout Tooltip *(New)*
An onboarding callout bubble pointing at the Instructions button appears on first launch, guiding users to the help screen. Dismisses only when the user taps **"فهمت"**.

### 📖 Instructions Screen
Step-by-step interactive help screen covering all controls, protocol commands, and connection setup.

---

## 📡 Communication Protocol

ASCII-encoded single-character commands, universally compatible with all microcontrollers:

| Command | Function         | Command   | Function          |
| :------ | :--------------- | :-------- | :---------------- |
| `F`     | Move Forward     | `1`       | Speed Gear 1      |
| `B`     | Move Backward    | `2`       | Speed Gear 2      |
| `L`     | Turn Left        | `3`       | Speed Gear 3      |
| `R`     | Turn Right       | `4`       | Speed Gear 4      |
| `S`     | Full Stop        | `+` / `-` | Fine Speed Tuning |
| `M`     | Manual Mode      | `A`       | Auto-Pilot Mode   |
| *any*   | Custom via Terminal Screen | | |

---

## 🏗️ Project Structure

```text
lib/
├── constants/          # Command definitions and protocol constants
├── providers/          # State management (Provider pattern)
│   └── controller_provider.dart
├── services/
│   └── bluetooth_service.dart   # BT connection, send throttle, last command tracking
├── screens/
│   ├── controller_screen.dart   # Main control interface
│   ├── terminal_screen.dart     # Custom command terminal  ← NEW
│   └── instructions_screen.dart # Help & onboarding screen
├── widgets/
│   ├── connection_header.dart   # Two-row smart header     ← REDESIGNED
│   ├── dpad_widget.dart         # Directional pad
│   ├── gear_selector.dart       # Gear switching widget
│   ├── mode_selector.dart       # Manual / Auto mode toggle
│   └── speed_trim_widget.dart   # Speed fine-tuning widget
└── main.dart
```

---

## 🎨 Design System

| Token             | Value                        |
| :---------------- | :--------------------------- |
| Background        | `#0A0A0A` (near black)       |
| Primary Accent    | `#4FC3F7` (electric cyan)    |
| Surface           | `#141414`                    |
| Typography        | Roboto Mono (Google Fonts)   |
| Icon Style        | Rounded, neon glow           |
| Android Icon      | Adaptive (dark bg + RC car)  |

---

## 🛠️ Tech Stack

| Layer             | Technology                   |
| :---------------- | :--------------------------- |
| Framework         | Flutter SDK (Stable)         |
| State Management  | Provider                     |
| Connectivity      | bluetooth_classic ^0.0.4     |
| Fonts             | google_fonts ^6.x            |
| Icon Generation   | flutter_launcher_icons ^0.14 |

---

## 🚀 Getting Started

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate app icons (already done)
dart run flutter_launcher_icons

# 3. Run in debug mode
flutter run

# 4. Build release APK
flutter build apk
```

### Setup Steps
1. **Pair** your phone with the Bluetooth module (HC-05 / HC-06) via Android settings
2. **Launch** RC Drive and tap **TAP TO CONNECT**
3. **Select** your paired device from the list
4. **Control** your RC car — or use the Terminal to send custom commands

---

## 🐛 Known Fixes (Changelog)

| Issue | Fix |
| :---- | :-- |
| Header overflow on small screens | Two-row layout + `Flexible` + `TextOverflow.ellipsis` |
| Keyboard dismiss causes layout flicker | `SafeArea(bottom: false)` + dynamic `viewInsets` padding |
| `lastSentCommand` not updating in header | Fixed throttle logic — comparison now uses pre-update value |
| Callout tooltip mispositioned | Replaced `Tooltip` with custom `OverlayEntry` callout bubble |

---

## 👨‍💻 Developer
**Momen Salman**

---

*RC Drive — Precision control meets premium design.*

---

© 2026 **Momen Salman** — All Rights Reserved.  
Unauthorized copying, distribution, or modification of this software, in whole or in part, is strictly prohibited without explicit written permission from the author.
