import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';

enum BtConnectionState { disconnected, connecting, connected, error }

class BluetoothService extends ChangeNotifier {
  final _plugin = BluetoothClassic();

  BtConnectionState _state = BtConnectionState.disconnected;
  Device? _connectedDevice;
  String _lastSentCommand = "";
  DateTime? _lastSendTime;

  StreamSubscription<int>? _statusSub;

  static const int _throttleMs = 80;

  // ─── Getters ─────────────────────────────────────────────────────────────────
  BtConnectionState get state => _state;
  bool get isConnected => _state == BtConnectionState.connected;
  String get deviceName => _connectedDevice?.name ?? "No Device";
  String get lastSentCommand => _lastSentCommand;

  // ─── Init permissions ────────────────────────────────────────────────────────
  Future<bool> requestPermissions() async {
    return await _plugin.initPermissions();
  }

  // ─── Get paired (bonded) devices ─────────────────────────────────────────────
  Future<List<Device>> getPairedDevices() async {
    try {
      return await _plugin.getPairedDevices();
    } catch (_) {
      return [];
    }
  }

  // ─── Connect ─────────────────────────────────────────────────────────────────
  Future<bool> connectToDevice(Device device) async {
    _state = BtConnectionState.connecting;
    notifyListeners();

    try {
      await _plugin.connect(
        device.address,
        "00001101-0000-1000-8000-00805F9B34FB", // SPP UUID
      );
      _connectedDevice = device;
      _state = BtConnectionState.connected;
      notifyListeners();

      // Listen for disconnection
      _statusSub = _plugin.onDeviceStatusChanged().listen((status) {
        if (status == Device.disconnected) {
          _onDisconnected();
        }
      });

      return true;
    } catch (_) {
      _state = BtConnectionState.error;
      notifyListeners();
      return false;
    }
  }

  // ─── Disconnect ───────────────────────────────────────────────────────────────
  Future<void> disconnect() async {
    await _statusSub?.cancel();
    _statusSub = null;
    try {
      await _plugin.disconnect();
    } catch (_) {}
    _onDisconnected();
  }

  // ─── Send Command ─────────────────────────────────────────────────────────────
  void sendCommand(String cmd, {bool throttle = false}) {
    if (throttle) {
      final now = DateTime.now();
      if (_lastSendTime != null &&
          now.difference(_lastSendTime!).inMilliseconds < _throttleMs &&
          cmd == _lastSentCommand) {
        return;
      }
      _lastSendTime = now;
    }

    // Update last command and notify UI even if disconnected
    // so the user can see what the app is TRYING to send.
    _lastSentCommand = cmd;
    notifyListeners();

    if (!isConnected) return;

    try {
      _plugin.write(cmd);
    } catch (_) {
      _onDisconnected();
    }
  }

  // ─── Private ─────────────────────────────────────────────────────────────────
  void _onDisconnected() {
    _connectedDevice = null;
    _state = BtConnectionState.disconnected;
    notifyListeners();
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    _plugin.disconnect();
    super.dispose();
  }
}
