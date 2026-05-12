import 'package:flutter/material.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/controller_provider.dart';
import '../services/bluetooth_service.dart';
import '../widgets/connection_header.dart';
import '../widgets/dpad_widget.dart';
import '../widgets/speed_trim_widget.dart';
import '../widgets/gear_selector.dart';
import '../widgets/mode_selector.dart';

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({super.key});

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  bool _loading = false;

  // ─── BT device picker sheet ──────────────────────────────────────────────────
  Future<void> _showDevicePicker() async {
    final bt = context.read<BluetoothService>();

    setState(() => _loading = true);

    // Request permissions first
    await bt.requestPermissions();

    List<Device> devices = await bt.getPairedDevices();

    setState(() => _loading = false);

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sheet handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "PAIRED DEVICES",
              style: GoogleFonts.robotoMono(
                fontSize: 11,
                color: Colors.white38,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            if (devices.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    "No paired Bluetooth devices found.\nPair your device in system Bluetooth settings first.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoMono(
                      color: Colors.white38,
                      fontSize: 12,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ...devices.map(
              (d) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4FC3F7).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.bluetooth_rounded,
                    color: Color(0xFF4FC3F7),
                    size: 20,
                  ),
                ),
                title: Text(
                  d.name ?? d.address,
                  style: GoogleFonts.robotoMono(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  d.address,
                  style: GoogleFonts.robotoMono(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await bt.connectToDevice(d);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ControllerProvider>(
      builder: (context, ctrl, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0A),
          body: SafeArea(
            child: Column(
              children: [
                // ── TOP: BT status header ──
                const ConnectionHeader(),

                // ── Main flexible content ──
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      children: [
                        const Spacer(),

                        // ── CENTER: D-Pad ──
                        Center(
                          child: AnimatedOpacity(
                            opacity:
                                ctrl.mode == DriveMode.manual ? 1.0 : 0.35,
                            duration: const Duration(milliseconds: 300),
                            child: const DpadWidget(),
                          ),
                        ),

                        const Spacer(flex: 2),

                        // ── Speed Trim ──
                        AnimatedOpacity(
                          opacity:
                              ctrl.mode == DriveMode.manual ? 1.0 : 0.35,
                          duration: const Duration(milliseconds: 300),
                          child: const SpeedTrimWidget(),
                        ),

                        const SizedBox(height: 20),

                        // ── Gear Select ──
                        AnimatedOpacity(
                          opacity:
                              ctrl.mode == DriveMode.manual ? 1.0 : 0.35,
                          duration: const Duration(milliseconds: 300),
                          child: const GearSelector(),
                        ),

                        const SizedBox(height: 20),

                        // ── Mode Select ──
                        const ModeSelector(),

                        // ── Auto/Expert info card ──
                        if (ctrl.mode != DriveMode.manual) ...[
                          const SizedBox(height: 20),
                          _ModeInfoCard(mode: ctrl.mode),
                        ],
                        
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── FAB: Connect / Disconnect ──
          floatingActionButton: Consumer<BluetoothService>(
            builder: (_, bt, __) => FloatingActionButton.extended(
              onPressed: bt.isConnected
                  ? () async => await bt.disconnect()
                  : _showDevicePicker,
              backgroundColor: bt.isConnected
                  ? const Color(0xFF1E1E1E)
                  : const Color(0xFF4FC3F7),
              foregroundColor: bt.isConnected
                  ? const Color(0xFF4FC3F7)
                  : const Color(0xFF0A0A0A),
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(bt.isConnected
                      ? Icons.bluetooth_connected_rounded
                      : Icons.bluetooth_searching_rounded),
              label: Text(
                bt.isConnected ? "DISCONNECT" : "CONNECT",
                style: GoogleFonts.robotoMono(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Mode info card (Auto / Expert) ─────────────────────────────────────────
class _ModeInfoCard extends StatelessWidget {
  final DriveMode mode;
  const _ModeInfoCard({required this.mode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        children: [
          Icon(mode.icon, color: const Color(0xFF4FC3F7), size: 36),
          const SizedBox(height: 10),
          Text(
            "${mode.label} MODE ACTIVE",
            style: GoogleFonts.robotoMono(
              color: const Color(0xFF4FC3F7),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            mode == DriveMode.auto
                ? "Vehicle is in autonomous control.\nManual inputs are disabled."
                : "Expert mode enabled.\nAdvanced algorithms active.",
            textAlign: TextAlign.center,
            style: GoogleFonts.robotoMono(
              color: Colors.white38,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
