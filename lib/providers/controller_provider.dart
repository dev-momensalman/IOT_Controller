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
  int _speedTrim = 5;
  bool _isAutoForward = false;

  DriveMode get mode => _mode;
  int get gear => _gear;
  int get speedTrim => _speedTrim;
  bool get isAutoForward => _isAutoForward;

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
  void toggleAutoForward() {
    _isAutoForward = !_isAutoForward;
    if (_isAutoForward) {
      btService.sendCommand(BtCommands.forward);
    } else {
      btService.sendCommand(BtCommands.stop);
    }
    notifyListeners();
  }

  void send(String cmd) {
    // If we are in auto-forward and user presses another movement key, 
    // we should probably stop auto-forward to prevent conflicts.
    if (_isAutoForward && cmd != BtCommands.forward && cmd != BtCommands.stop) {
      _isAutoForward = false;
      notifyListeners();
    }
    
    if (cmd == BtCommands.speedUp && _speedTrim < 10) {
      _speedTrim++;
      notifyListeners();
    } else if (cmd == BtCommands.speedDown && _speedTrim > 0) {
      _speedTrim--;
      notifyListeners();
    }
    btService.sendCommand(cmd, throttle: true);
  }

  void sendImmediate(String cmd) {
    if (_isAutoForward && cmd == BtCommands.stop) {
      _isAutoForward = false;
      notifyListeners();
    }
    btService.sendCommand(cmd);
  }
}
