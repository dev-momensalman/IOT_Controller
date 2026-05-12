# 🏎️ Embedded System 2026
### Professional Bluetooth IOT Control Interface

![App Mockup](file:///C:/Users/momen/.gemini/antigravity/brain/0de44d7f-35d6-4e6c-9550-55c0fda9599a/app_ui_mockup_1778616041210.png)

---

## 🌟 Overview
**Embedded System 2026** is an advanced engineering solution designed to control embedded systems and smart robotic vehicles via Bluetooth technology. Developed with **Flutter**, the application focuses on three core pillars: **Ultra-Performance**, **Unmatched Stability**, and a **Premium User Experience (UX)**.

This is not just a controller; it is a high-fidelity engineering interface designed to provide precise, real-time command execution for mechatronic systems.

---

## ✨ Key Features

- **🕹️ Advanced Directional Control:** A large, ergonomically designed D-Pad ensuring instantaneous response and tactile-like visual feedback.
- **🚀 Dynamic Speed Control:** An interactive speed level bar mimicking modern smartphone interfaces with real-time visual progress.
- **⚙️ Smart Transmission System:** 4 switchable gear levels for immediate power adjustment according to terrain and operational needs.
- **🛡️ Cruise Control System:** Integrated latch-mode for continuous forward movement with an intelligent emergency stop system.
- **📡 Low-Latency Protocol:** Highly optimized data transmission engine ensuring minimum latency between the mobile interface and the target hardware.
- **🌓 Dark Premium Design:** A sleek "Glassmorphism" based UI with carefully curated gradients, optimized for OLED displays and visual comfort.

---

## 🎨 Design Philosophy (UI/UX)

The interface is engineered to be both **Functional & Aesthetic**:
- **Color Palette:** Deep Black (`#0A0A0A`) background to minimize distraction, paired with Electric Blue (`#4FC3F7`) for high-contrast interactive elements.
- **Typography:** Utilizing **Roboto Mono** to maintain a precise, technical, and engineering-centric visual identity.
- **Visual Feedback:** Micro-animations and state changes provide immediate confirmation for every command sent.

---

## 🏗️ Technical Architecture

The project adheres to a **Clean & Modular Structure**, ensuring scalability and ease of maintenance:

```text
lib/
├── 📁 constants/   # System constants and Command Protocol definitions
├── 📁 providers/   # State Management and Business Logic (Provider pattern)
├── 📁 services/    # Communication services and Hardware Abstraction (Bluetooth Engine)
├── 📁 screens/     # Main UI layouts and screen definitions
├── 📁 widgets/     # Reusable Custom UI Components
└── 📄 main.dart    # System entry point and global configuration
```

---

## 📡 Communication Protocol

The application acts as a **Master Node**, transmitting ASCII-encoded characters, making it universally compatible with any microcontroller (Arduino, ESP32, STM32, etc.):

| Command | Function | Command | Function |
| :--- | :--- | :--- | :--- |
| `F` | Move Forward | `1` | Speed Gear 1 |
| `B` | Move Backward | `2` | Speed Gear 2 |
| `L` | Turn Left | `3` | Speed Gear 3 |
| `R` | Turn Right | `4` | Speed Gear 4 |
| `S` | Full Stop | `+` / `-` | Fine Speed Tuning |
| `M` | Manual Mode | `A` | Auto-Pilot Mode |

---

## 🛠️ Tech Stack

- **Framework:** Flutter SDK (Stable Channel)
- **State Management:** Provider (Efficient reactive data flow)
- **Connectivity:** Bluetooth Classic API
- **Styling:** Custom Flutter UI with Google Fonts integration

---

## 🚀 Getting Started

1. **Environment:** Install Flutter SDK and your preferred IDE (VS Code / Android Studio).
2. **Dependencies:** Run `flutter pub get` in the project root.
3. **Pairing:** Pair your mobile device with the Bluetooth module (HC-05/HC-06) via system settings.
4. **Execution:** Launch the app, tap **TAP TO CONNECT**, and take command of your hardware.

---

## 👨‍💻 Developer
**Momen salman**

---
*Developed as a benchmark for professional integration between software interfaces and embedded hardware systems.*
