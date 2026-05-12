import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/controller_provider.dart';
import '../services/bluetooth_service.dart';

/// Top status bar: connection dot, device name, current mode badge, last command
class ConnectionHeader extends StatelessWidget {
  final VoidCallback onActionPressed;
  const ConnectionHeader({super.key, required this.onActionPressed});

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
              // ── BT State dot + action ──
              GestureDetector(
                onTap: onActionPressed,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _StatusDot(connected: bt.isConnected),
                    if (!bt.isConnected)
                      AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF4FC3F7).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: onActionPressed,
                  borderRadius: BorderRadius.circular(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                          if (!bt.isConnected) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.bluetooth_searching_rounded,
                                size: 12, color: Color(0xFF4FC3F7)),
                          ],
                        ],
                      ),
                      Text(
                        bt.isConnected ? bt.deviceName : "TAP TO CONNECT",
                        style: GoogleFonts.robotoMono(
                          fontSize: 12,
                          color: bt.isConnected ? Colors.white70 : const Color(0xFF4FC3F7),
                          fontWeight: bt.isConnected ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Current Mode Badge ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4FC3F7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "MODE",
                      style: GoogleFonts.robotoMono(
                        fontSize: 7,
                        color: const Color(0xFF4FC3F7).withOpacity(0.7),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
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
                      ctrl.mode.label,
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4FC3F7),
                      ),
                    ),
                  ),
                ],
              ),

              // ── Last Command ──
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "LAST",
                    style: GoogleFonts.robotoMono(
                      fontSize: 7,
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
