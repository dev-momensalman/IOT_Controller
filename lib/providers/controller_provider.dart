import 'package:flutter/material.dart';
import '../constants/bt_commands.dart';
import '../services/bluetooth_service.dart';

enum DriveMode { manual, auto, expert }

extension DriveModeExt on DriveMode {
  String get label {
    switch (this) {
      case DriveMode.manual:
        return "MANUAL";
      case DriveMode.auto:
        return "AUTO";
      case DriveMode.expert:
        return "EXPERT";
    }
  }

  String get command {
    switch (this) {
      case DriveMode.manual:
        return BtCommands.mode1Manual;
      case DriveMode.auto:
        return BtCommands.mode2;
      case DriveMode.expert:
        return BtCommands.mode3;
    }
  }

  IconData get icon {
    switch (this) {
      case DriveMode.manual:
        return Icons.sports_esports_rounded;
      case DriveMode.auto:
        return Icons.auto_mode_rounded;
      case DriveMode.expert:
        return Icons.tune_rounded;
    }
  }
}

class ControllerProvider extends ChangeNotifier {
  final BluetoothService btService;

  ControllerProvider({required this.btService});

  DriveMode _mode = DriveMode.manual;
  int _gear = 1;

  DriveMode get mode => _mode;
  int get gear => _gear;

  // ─── Mode Selection ──────────────────────────────────────────────────────────
  void setMode(DriveMode mode) {
    _mode = mode;
    btService.sendCommand(mode.command);
    notifyListeners();
  }

  // ─── Gear Selection ──────────────────────────────────────────────────────────
  void setGear(int g) {
    _gear = g;
    final cmd = [
      BtCommands.gear1,
      BtCommands.gear2,
      BtCommands.gear3,
      BtCommands.gear4
    ][g - 1];
    btService.sendCommand(cmd);
    notifyListeners();
  }

  // ─── Movement / Speed ────────────────────────────────────────────────────────
  void send(String cmd) => btService.sendCommand(cmd, throttle: true);
  void sendImmediate(String cmd) => btService.sendCommand(cmd);
}
