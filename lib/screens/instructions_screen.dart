import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/bt_commands.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  static const String arduinoCode = r'''/*
  Embedded System 2026 — RC Controller Receiver Code
  Hardware: Arduino Uno/Nano, HC-05 Bluetooth Module, L298N Motor Driver
  
  Connections:
  - HC-05 Bluetooth Module:
    TX -> Arduino RX (Pin 2 via SoftwareSerial)
    RX -> Arduino TX (Pin 3 via SoftwareSerial)
  - L298N Motor Driver:
    ENA (PWM) -> Pin 5  (Left Motors Speed)
    IN1       -> Pin 7  (Left Motors Forward)
    IN2       -> Pin 8  (Left Motors Backward)
    IN3       -> Pin 9  (Right Motors Forward)
    IN4       -> Pin 10 (Right Motors Backward)
    ENB (PWM) -> Pin 6  (Right Motors Speed)
*/

#include <SoftwareSerial.h>

// Bluetooth Module Pins (Rx, Tx)
SoftwareSerial btSerial(2, 3); 

// Motor A (Left side) Pins
const int pinENA = 5;
const int pinIN1 = 7;
const int pinIN2 = 8;

// Motor B (Right side) Pins
const int pinENB = 6;
const int pinIN3 = 9;
const int pinIN4 = 10;

// Speed Control Variables
int currentSpeed = 150;  // Initial speed (0-255)
const int speedStep = 15; // Speed tuning step (+ / -)
const int minSpeed = 50;  // Minimum functional speed
const int maxSpeed = 255; // Maximum speed

void setup() {
  Serial.begin(9600);
  btSerial.begin(9600);

  // Configure Motor Control Pins
  pinMode(pinENA, OUTPUT);
  pinMode(pinENB, OUTPUT);
  pinMode(pinIN1, OUTPUT);
  pinMode(pinIN2, OUTPUT);
  pinMode(pinIN3, OUTPUT);
  pinMode(pinIN4, OUTPUT);

  // Start with motors stopped
  stopCar();
}

void loop() {
  if (btSerial.available() > 0) {
    char cmd = btSerial.read();
    handleCommand(cmd);
  }
}

void handleCommand(char cmd) {
  switch (cmd) {
    case 'F': moveForward(); break;
    case 'B': moveBackward(); break;
    case 'L': turnLeft(); break;
    case 'R': turnRight(); break;
    case 'S': stopCar(); break;
    case '1': currentSpeed = 70; updateSpeed(); break;
    case '2': currentSpeed = 130; updateSpeed(); break;
    case '3': currentSpeed = 190; updateSpeed(); break;
    case '4': currentSpeed = 255; updateSpeed(); break;
    case '+': currentSpeed = constrain(currentSpeed + speedStep, minSpeed, maxSpeed); updateSpeed(); break;
    case '-': currentSpeed = constrain(currentSpeed - speedStep, minSpeed, maxSpeed); updateSpeed(); break;
    case 'M': Serial.println("Mode: MANUAL"); break;
    case 'A': Serial.println("Mode: AUTO-PILOT"); break;
    default: break;
  }
}

void updateSpeed() {
  analogWrite(pinENA, currentSpeed);
  analogWrite(pinENB, currentSpeed);
}

void moveForward() {
  updateSpeed();
  digitalWrite(pinIN1, HIGH);
  digitalWrite(pinIN2, LOW);
  digitalWrite(pinIN3, HIGH);
  digitalWrite(pinIN4, LOW);
}

void moveBackward() {
  updateSpeed();
  digitalWrite(pinIN1, LOW);
  digitalWrite(pinIN2, HIGH);
  digitalWrite(pinIN3, LOW);
  digitalWrite(pinIN4, HIGH);
}

void turnLeft() {
  updateSpeed();
  digitalWrite(pinIN1, LOW);
  digitalWrite(pinIN2, HIGH);
  digitalWrite(pinIN3, HIGH);
  digitalWrite(pinIN4, LOW);
}

void turnRight() {
  updateSpeed();
  digitalWrite(pinIN1, HIGH);
  digitalWrite(pinIN2, LOW);
  digitalWrite(pinIN3, LOW);
  digitalWrite(pinIN4, HIGH);
}

void stopCar() {
  digitalWrite(pinIN1, LOW);
  digitalWrite(pinIN2, LOW);
  digitalWrite(pinIN3, LOW);
  digitalWrite(pinIN4, LOW);
}''';

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(const ClipboardData(text: arduinoCode)).then((_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF4FC3F7),
              ),
              const SizedBox(width: 12),
              Text(
                "Arduino code copied to clipboard!",
                style: GoogleFonts.robotoMono(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF141414),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: const Color(0xFF4FC3F7).withOpacity(0.2)),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white70,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "INSTRUCTIONS & PROTOCOL",
          style: GoogleFonts.robotoMono(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4FC3F7),
            letterSpacing: 2.0,
          ),
        ),
        shape: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Setup Guides Section ──
              _buildSectionHeader("1. HARDWARE & BLUETOOTH SETUP"),
              const SizedBox(height: 12),
              const _SetupGuideCard(),
              const SizedBox(height: 28),

              // ── Command Protocol Section ──
              _buildSectionHeader("2. DATA TRANSMISSION PROTOCOL"),
              const SizedBox(height: 12),
              const _ProtocolTable(),
              const SizedBox(height: 28),

              // ── Arduino Source Code Section ──
              _buildSectionHeader("3. RECEIVER ARDUINO SKETCH"),
              const SizedBox(height: 12),
              _ArduinoCodeBlock(onCopyPressed: () => _copyToClipboard(context)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.robotoMono(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white54,
        letterSpacing: 1.5,
      ),
    );
  }
}

// ─── Setup Guide Card ────────────────────────────────────────────────────────
class _SetupGuideCard extends StatelessWidget {
  const _SetupGuideCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            Icons.bluetooth_rounded,
            "Bluetooth Pairing (HC-05)",
          ),
          const SizedBox(height: 8),
          _buildStepBody(
            "1. Open your phone's system Bluetooth settings.\n"
            "2. Search for the module (usually named 'HC-05' or 'HC-06').\n"
            "3. Pair using the PIN '1234' or '0000'.\n"
            "4. Return to this app, tap 'TAP TO CONNECT' at the top bar, and select the device.",
          ),
          const SizedBox(height: 20),
          _buildStepHeader(
            Icons.settings_input_component_rounded,
            "L298N & HC-05 Wiring Matrix",
          ),
          const SizedBox(height: 8),
          _buildStepBody(
            "• HC-05 TX  ->  Arduino RX (Digital Pin 2)\n"
            "• HC-05 RX  ->  Arduino TX (Digital Pin 3)\n"
            "• L298N ENA (PWM) ->  Pin 5 (Left Speed)\n"
            "• L298N ENB (PWM) ->  Pin 6 (Right Speed)\n"
            "• L298N IN1, IN2   ->  Pins 7, 8 (Left Direction)\n"
            "• L298N IN3, IN4   ->  Pins 9, 10 (Right Direction)\n"
            "• Ensure Arduino GND connects to L298N GND and power source ground.",
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4FC3F7), size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.robotoMono(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepBody(String body) {
    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: Text(
        body,
        style: GoogleFonts.robotoMono(
          color: Colors.white60,
          fontSize: 11,
          height: 1.6,
        ),
      ),
    );
  }
}

// ─── Protocol Table / List ───────────────────────────────────────────────────
class _ProtocolTable extends StatelessWidget {
  const _ProtocolTable();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> protocolItems = [
      {"cmd": BtCommands.forward, "action": "Move Forward"},
      {"cmd": BtCommands.backward, "action": "Move Backward"},
      {"cmd": BtCommands.left, "action": "Turn Left"},
      {"cmd": BtCommands.right, "action": "Turn Right"},
      {"cmd": BtCommands.stop, "action": "Full Stop"},
      {"cmd": BtCommands.gear1, "action": "Low Speed (Gear 1)"},
      {"cmd": BtCommands.gear2, "action": "Medium-Low Speed (Gear 2)"},
      {"cmd": BtCommands.gear3, "action": "Medium-High Speed (Gear 3)"},
      {"cmd": BtCommands.gear4, "action": "Maximum Speed (Gear 4)"},
      {"cmd": BtCommands.speedUp, "action": "Tune Speed Up (+15 PWM)"},
      {"cmd": BtCommands.speedDown, "action": "Tune Speed Down (-15 PWM)"},
      {"cmd": BtCommands.mode1Manual, "action": "Switch to Manual Control"},
      {"cmd": BtCommands.mode2, "action": "Switch to Auto-Pilot Mode"},
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Header Row
            Container(
              color: Colors.white.withOpacity(0.03),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "CHAR",
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFF4FC3F7),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      "MAPPED ACTION",
                      style: GoogleFonts.robotoMono(
                        color: const Color(0xFF4FC3F7),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Data Rows
            ...List.generate(protocolItems.length, (index) {
              final item = protocolItems[index];
              final isLast = index == protocolItems.length - 1;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.03),
                          ),
                        ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4FC3F7).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(0xFF4FC3F7).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            "'${item["cmd"]}'",
                            style: GoogleFonts.robotoMono(
                              color: const Color(0xFF4FC3F7),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        item["action"]!,
                        style: GoogleFonts.robotoMono(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─── Arduino Code Block Widget ──────────────────────────────────────────────
class _ArduinoCodeBlock extends StatelessWidget {
  final VoidCallback onCopyPressed;
  const _ArduinoCodeBlock({required this.onCopyPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Code block top toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.04)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.amberAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          "receiver_sketch.ino",
                          style: GoogleFonts.robotoMono(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: onCopyPressed,
                  icon: const Icon(
                    Icons.copy_rounded,
                    size: 14,
                    color: Color(0xFF4FC3F7),
                  ),
                  label: Text(
                    "COPY CODE",
                    style: GoogleFonts.robotoMono(
                      color: const Color(0xFF4FC3F7),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    backgroundColor: const Color(0xFF4FC3F7).withOpacity(0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                        color: const Color(0xFF4FC3F7).withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Scrollable code content
          Container(
            height: 360,
            padding: const EdgeInsets.all(16),
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SelectionArea(
                    child: Text(
                      InstructionsScreen.arduinoCode,
                      style: GoogleFonts.robotoMono(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
