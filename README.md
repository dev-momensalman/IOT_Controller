<div align="center">

# 🏎️ IOT Controller — RC Drive

### Professional Bluetooth Control Interface for Embedded Systems

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-SDK_^3.9-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?style=flat-square&logo=android&logoColor=white)](https://developer.android.com)
[![License](https://img.shields.io/badge/License-Private-red?style=flat-square)](/)
[![Version](https://img.shields.io/badge/Version-1.0.0-blueviolet?style=flat-square)](/)

</div>

---

## 🌟 Overview

**IOT Controller** is an advanced Flutter application engineered to control embedded systems and smart robotic vehicles via **Bluetooth Classic**. Built with a focus on three core pillars:

| Pillar | Description |
|---|---|
| ⚡ **Ultra-Performance** | Highly optimized, low-latency command transmission |
| 🛡️ **Unmatched Stability** | Robust Bluetooth connection management with graceful error handling |
| 🎨 **Premium UX** | Glassmorphism dark UI engineered for OLED displays |

> This is not just a controller — it is a high-fidelity engineering interface for precise, real-time command execution on mechatronic systems.

---

## ✨ Features

- **🕹️ Advanced D-Pad** — Ergonomically designed with instantaneous response and tactile visual feedback
- **🚀 Dynamic Speed Control** — Interactive speed trim bar with real-time visual progress
- **⚙️ 4-Speed Gear System** — Switchable gear levels for immediate power adjustment per terrain
- **🛡️ Cruise Control** — Integrated latch-mode for continuous forward movement with smart emergency stop
- **📡 Auto-Pilot Mode** — Switch to autonomous vehicle control mode with a single tap
- **🔵 Smart Device Picker** — Scans and lists all paired Bluetooth devices for quick connection
- **🌓 Dark Premium UI** — Glassmorphism design with curated gradients, optimized for visual comfort

---

## 🎨 Design System

| Element | Value |
|---|---|
| **Background** | Deep Black `#0A0A0A` |
| **Accent / Interactive** | Electric Blue `#4FC3F7` |
| **Surface Cards** | `#141414` |
| **Typography** | Roboto Mono (Google Fonts) |
| **Visual Feedback** | Micro-animations & animated opacity state changes |

---

## 🏗️ Architecture

The project follows a **Clean & Modular** structure using the **Provider** pattern for state management:

```text
lib/
├── 📁 constants/        # Command protocol definitions & app constants
├── 📁 providers/        # State management & business logic (ControllerProvider)
├── 📁 services/         # Bluetooth service & hardware abstraction layer
├── 📁 screens/
│   ├── controller_screen.dart   # Main control interface
│   └── instructions_screen.dart # Onboarding & usage guide
├── 📁 widgets/
│   ├── connection_header.dart   # BT status bar & connect/disconnect action
│   ├── dpad_widget.dart         # Directional pad control
│   ├── speed_trim_widget.dart   # Fine speed adjustment bar
│   ├── gear_selector.dart       # Gear level switcher (1–4)
│   └── mode_selector.dart       # Manual / Auto-Pilot mode toggle
└── 📄 main.dart                 # App entry point & global provider setup
```

---

## 📡 Communication Protocol

The app acts as a **Master Node**, transmitting **ASCII-encoded single characters** — compatible with any microcontroller (Arduino, ESP32, STM32, Raspberry Pi, etc.):

| Command | Function | Command | Function |
|:---:|:---|:---:|:---|
| `F` | Move Forward | `1` | Speed Gear 1 (Slow) |
| `B` | Move Backward | `2` | Speed Gear 2 |
| `L` | Turn Left | `3` | Speed Gear 3 |
| `R` | Turn Right | `4` | Speed Gear 4 (Fast) |
| `S` | Full Stop | `+` | Fine Speed Up |
| `M` | Manual Mode | `-` | Fine Speed Down |
| `A` | Auto-Pilot Mode | | |

> **Hardware Compatibility:** HC-05 / HC-06 Bluetooth modules, or any BT Classic serial module.

---

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter SDK** `^3.x` | Cross-platform UI framework |
| **Dart** `^3.9.2` | Primary programming language |
| **Provider** `^6.1.2` | Reactive state management |
| **bluetooth_classic** `^0.0.4` | Bluetooth Classic communication |
| **google_fonts** `^6.2.1` | Roboto Mono typography |
| **flutter_launcher_icons** `^0.14.3` | Custom app icon generation |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed ([Install Guide](https://docs.flutter.dev/get-started/install))
- An Android device (API 21+) with Bluetooth support
- A Bluetooth module (HC-05 / HC-06) connected to your microcontroller

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/dev-momensalman/IOT_Controller.git
cd IOT_Controller

# 2. Install dependencies
flutter pub get

# 3. Generate launcher icons
dart run flutter_launcher_icons

# 4. Run on connected device
flutter run
```

### Pairing Your Device

1. Power on your Bluetooth module (HC-05/HC-06)
2. Go to **Android System Settings → Bluetooth** and pair the module
3. Open the app → tap **TAP TO CONNECT**
4. Select your device from the list and take command 🎮

---

## 📱 Permissions Required

The app requires the following Android permissions:

- `BLUETOOTH` — Core Bluetooth functionality
- `BLUETOOTH_ADMIN` — Device scanning and pairing
- `BLUETOOTH_CONNECT` — Connecting to paired devices (Android 12+)
- `BLUETOOTH_SCAN` — Scanning for nearby devices (Android 12+)

---

## 👨‍💻 Developer

<div align="center">

**Momen Salman**

*Developed as a benchmark for professional integration between Flutter mobile interfaces and embedded hardware systems.*

</div>

---

<div align="center">

*© 2026 — Embedded Systems Engineering Project*

</div>
