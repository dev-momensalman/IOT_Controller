import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/controller_provider.dart';
import '../services/bluetooth_service.dart';
import '../screens/instructions_screen.dart';
import '../screens/terminal_screen.dart';

/// Top status bar: connection dot, device name, current mode badge, last command
class ConnectionHeader extends StatefulWidget {
  final VoidCallback onActionPressed;
  const ConnectionHeader({super.key, required this.onActionPressed});

  @override
  State<ConnectionHeader> createState() => _ConnectionHeaderState();
}

class _ConnectionHeaderState extends State<ConnectionHeader> {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _calloutEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Small delay to ensure the UI is fully rendered and animations settle
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          _showCallout();
        }
      });
    });
  }

  void _showCallout() {
    if (_calloutEntry != null) return; // Already showing

    final renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    _calloutEntry = OverlayEntry(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final buttonCenterDx = position.dx + size.width / 2;
        final distFromRightToCenter = screenWidth - buttonCenterDx;
        const bubbleMarginRight = 16.0;
        final arrowPaddingRight =
            distFromRightToCenter - bubbleMarginRight - 6.0;

        return Positioned(
          right: bubbleMarginRight,
          top: position.dy + size.height + 6,
          child: Material(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Triangle pointing up
                Padding(
                  padding: EdgeInsets.only(right: arrowPaddingRight),
                  child: ClipPath(
                    clipper: _TriangleClipper(),
                    child: Container(
                      width: 12,
                      height: 6,
                      color: const Color(0xFF141414), // Matches card background
                    ),
                  ),
                ),
                // Premium Card Bubble
                Container(
                  width: 240,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF4FC3F7).withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 12,
                        spreadRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Color(0xFF4FC3F7),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "SYSTEM SETUP",
                            style: GoogleFonts.robotoMono(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Wiring diagrams, Bluetooth steps, and receiver Arduino code are available here.",
                        style: GoogleFonts.robotoMono(
                          color: Colors.white70,
                          fontSize: 10,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            backgroundColor: const Color(
                              0xFF4FC3F7,
                            ).withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: BorderSide(
                                color: const Color(0xFF4FC3F7).withOpacity(0.3),
                              ),
                            ),
                          ),
                          onPressed: _dismissCallout,
                          child: Text(
                            "GOT IT / فهمت",
                            style: GoogleFonts.robotoMono(
                              color: const Color(0xFF4FC3F7),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_calloutEntry!);
  }

  void _dismissCallout() {
    if (_calloutEntry != null) {
      _calloutEntry!.remove();
      _calloutEntry = null;
    }
  }

  @override
  void dispose() {
    _dismissCallout();
    super.dispose();
  }

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ══ ROW 1: Connection Info + Mode Badge ══
              Row(
                children: [
                  // BT state dot
                  GestureDetector(
                    onTap: widget.onActionPressed,
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

                  // Connection status text
                  Expanded(
                    child: InkWell(
                      onTap: widget.onActionPressed,
                      borderRadius: BorderRadius.circular(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  bt.isConnected ? "CONNECTED" : "DISCONNECTED",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.robotoMono(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: bt.isConnected
                                        ? const Color(0xFF4FC3F7)
                                        : const Color(0xFF666666),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              if (!bt.isConnected) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.bluetooth_searching_rounded,
                                  size: 12,
                                  color: Color(0xFF4FC3F7),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            bt.isConnected ? bt.deviceName : "TAP TO CONNECT",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.robotoMono(
                              fontSize: 12,
                              color: bt.isConnected
                                  ? Colors.white70
                                  : const Color(0xFF4FC3F7),
                              fontWeight: bt.isConnected
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Mode Badge (top-right) ──
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "MODE",
                        style: GoogleFonts.robotoMono(
                          fontSize: 7,
                          color: const Color(0xFF4FC3F7).withOpacity(0.7),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4FC3F7).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFF4FC3F7).withOpacity(0.35),
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
                ],
              ),

              const SizedBox(height: 8),

              // ══ ROW 2: Last Command + Action Buttons ══
              Row(
                children: [
                  // Last sent command display
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "LAST CMD",
                          style: GoogleFonts.robotoMono(
                            fontSize: 8,
                            color: Colors.white24,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.07),
                            ),
                          ),
                          child: Text(
                            bt.lastSentCommand.isEmpty
                                ? "  —  "
                                : "  ${bt.lastSentCommand}  ",
                            style: GoogleFonts.robotoMono(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Terminal Button ──
                  _HeaderActionButton(
                    icon: Icons.terminal_rounded,
                    label: "TERM",
                    tooltip: "Custom Terminal",
                    onPressed: () {
                      _dismissCallout();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TerminalScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 8),

                  // ── Help/Info Button ──
                  Container(
                    key: _buttonKey,
                    child: _HeaderActionButton(
                      icon: Icons.help_outline_rounded,
                      label: "HELP",
                      tooltip: "Instructions",
                      onPressed: () {
                        _dismissCallout();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InstructionsScreen(),
                          ),
                        );
                      },
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
                ),
              ]
            : null,
      ),
    );
  }
}

/// Compact icon + label action button used in the header's second row.
class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback onPressed;

  const _HeaderActionButton({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF4FC3F7).withOpacity(0.07),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF4FC3F7).withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: const Color(0xFF4FC3F7)),
              const SizedBox(width: 5),
              Text(
                label,
                style: GoogleFonts.robotoMono(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4FC3F7),
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
