import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/bt_commands.dart';
import '../providers/controller_provider.dart';

/// Directional control pad: Forward, Backward, Left, Right, Stop (center)
class DpadWidget extends StatelessWidget {
  const DpadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ControllerProvider>(
      builder: (context, ctrl, _) {
        return SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Forward
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: _DpadButton(
                    icon: Icons.keyboard_arrow_up_rounded,
                    label: "F",
                    onTap: () => ctrl.send(BtCommands.forward),
                    onRelease: () => ctrl.send(BtCommands.stop),
                  ),
                ),
              ),
              // Backward
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: _DpadButton(
                    icon: Icons.keyboard_arrow_down_rounded,
                    label: "B",
                    onTap: () => ctrl.send(BtCommands.backward),
                    onRelease: () => ctrl.send(BtCommands.stop),
                  ),
                ),
              ),
              // Left
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _DpadButton(
                    icon: Icons.keyboard_arrow_left_rounded,
                    label: "L",
                    onTap: () => ctrl.send(BtCommands.left),
                    onRelease: () => ctrl.send(BtCommands.stop),
                  ),
                ),
              ),
              // Right
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _DpadButton(
                    icon: Icons.keyboard_arrow_right_rounded,
                    label: "R",
                    onTap: () => ctrl.send(BtCommands.right),
                    onRelease: () => ctrl.send(BtCommands.stop),
                  ),
                ),
              ),
              // Auto-Forward / Stop (center)
              _StopButton(
                isActive: ctrl.isAutoForward,
                onTap: () => ctrl.toggleAutoForward(),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── D-Pad Directional Button ──────────────────────────────────────────────────
class _DpadButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final VoidCallback onRelease;

  const _DpadButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.onRelease,
  });

  @override
  State<_DpadButton> createState() => _DpadButtonState();
}

class _DpadButtonState extends State<_DpadButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _ac;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _ac, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  void _onDown() {
    setState(() => _pressed = true);
    _ac.forward();
    widget.onTap();
  }

  void _onUp() {
    setState(() => _pressed = false);
    _ac.reverse();
    widget.onRelease();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _onDown(),
      onTapUp: (_) => _onUp(),
      onTapCancel: _onUp,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          width: 86,
          height: 86,
          decoration: BoxDecoration(
            color: _pressed
                ? const Color(0xFF4FC3F7).withOpacity(0.25)
                : const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _pressed
                  ? const Color(0xFF4FC3F7)
                  : Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: _pressed
                ? [
                    BoxShadow(
                      color: const Color(0xFF4FC3F7).withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ]
                : null,
          ),
          child: Icon(
            widget.icon,
            color: _pressed ? const Color(0xFF4FC3F7) : Colors.white70,
            size: 44,
          ),
        ),
      ),
    );
  }
}

// ─── Stop Button (Center) ──────────────────────────────────────────────────────
class _StopButton extends StatefulWidget {
  final bool isActive;
  final VoidCallback onTap;
  const _StopButton({required this.isActive, required this.onTap});

  @override
  State<_StopButton> createState() => _StopButtonState();
}

class _StopButtonState extends State<_StopButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _ac;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _ac, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        _ac.forward();
        widget.onTap();
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        _ac.reverse();
      },
      onTapCancel: () {
        setState(() => _pressed = false);
        _ac.reverse();
      },
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            color: _pressed
                ? const Color(0xFFEF4444)
                : const Color(0xFFEF4444).withOpacity(0.85),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEF4444)
                    .withOpacity(_pressed ? 0.7 : 0.35),
                blurRadius: _pressed ? 18 : 10,
                spreadRadius: _pressed ? 3 : 1,
              ),
            ],
          ),
          child: Icon(
            widget.isActive ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: Colors.white,
            size: 38,
          ),
        ),
      ),
    );
  }
}

// ignore: unused_element
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.robotoMono(
        fontSize: 10,
        color: Colors.white38,
        letterSpacing: 1,
      ),
    );
  }
}
