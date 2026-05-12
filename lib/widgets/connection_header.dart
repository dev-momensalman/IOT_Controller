import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/controller_provider.dart';
import '../services/bluetooth_service.dart';

/// Top status bar: connection dot, device name, current mode badge, last command
class ConnectionHeader extends StatelessWidget {
  const ConnectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<BluetoothService, ControllerProvider>(
      builder: (context, bt, ctrl, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
            ),
          ),
          child: Row(
            children: [
              // ── BT State dot + device name ──
              _StatusDot(connected: bt.isConnected),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bt.isConnected ? "CONNECTED" : "DISCONNECTED",
                      style: GoogleFonts.robotoMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: bt.isConnected
                            ? const Color(0xFF4FC3F7)
                            : const Color(0xFF666666),
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      bt.deviceName,
                      style: GoogleFonts.robotoMono(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Current Mode Badge ──
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4FC3F7).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFF4FC3F7).withOpacity(0.4),
                  ),
                ),
                child: Text(
                  "CURRENT MODE",
                  style: GoogleFonts.robotoMono(
                    fontSize: 8,
                    color: const Color(0xFF4FC3F7),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4FC3F7).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF4FC3F7)),
                ),
                child: Text(
                  ctrl.mode.label,
                  style: GoogleFonts.robotoMono(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4FC3F7),
                    letterSpacing: 1,
                  ),
                ),
              ),

              // ── Last Command ──
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "LAST CMD",
                    style: GoogleFonts.robotoMono(
                      fontSize: 8,
                      color: Colors.white30,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    bt.lastSentCommand.isEmpty ? "—" : bt.lastSentCommand,
                    style: GoogleFonts.robotoMono(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusDot extends StatelessWidget {
  final bool connected;
  const _StatusDot({required this.connected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: connected ? const Color(0xFF4FC3F7) : const Color(0xFF444444),
        boxShadow: connected
            ? [
                BoxShadow(
                  color: const Color(0xFF4FC3F7).withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
    );
  }
}
