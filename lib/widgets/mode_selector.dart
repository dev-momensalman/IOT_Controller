import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/controller_provider.dart';

/// Drive mode selector: MANUAL (M) / AUTO (A) / EXPERT (X)
class ModeSelector extends StatelessWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ControllerProvider>(
      builder: (context, ctrl, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 6),
              child: Text(
                "DRIVE MODE",
                style: GoogleFonts.robotoMono(
                  fontSize: 10,
                  color: Colors.white30,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _ModeButton(
                    mode: DriveMode.manual,
                    isActive: ctrl.mode == DriveMode.manual,
                    onTap: () => ctrl.setMode(DriveMode.manual),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ModeButton(
                    mode: DriveMode.auto,
                    isActive: ctrl.mode == DriveMode.auto,
                    onTap: () => ctrl.setMode(DriveMode.auto),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ModeButton(
                    mode: DriveMode.expert,
                    isActive: ctrl.mode == DriveMode.expert,
                    onTap: () => ctrl.setMode(DriveMode.expert),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ModeButton extends StatefulWidget {
  final DriveMode mode;
  final bool isActive;
  final VoidCallback onTap;

  const _ModeButton({
    required this.mode,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_ModeButton> createState() => _ModeButtonState();
}

class _ModeButtonState extends State<_ModeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
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
    final accent = const Color(0xFF4FC3F7);

    return GestureDetector(
      onTapDown: (_) => _ac.forward(),
      onTapUp: (_) {
        _ac.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ac.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 56,
          decoration: BoxDecoration(
            color: widget.isActive
                ? accent.withOpacity(0.18)
                : const Color(0xFF141414),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isActive ? accent : Colors.white.withOpacity(0.1),
              width: widget.isActive ? 1.5 : 1,
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: accent.withOpacity(0.25),
                      blurRadius: 14,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.mode.icon,
                color: widget.isActive ? accent : Colors.white38,
                size: 18,
              ),
              const SizedBox(height: 3),
              Text(
                widget.mode.label,
                style: GoogleFonts.robotoMono(
                  fontSize: 10,
                  fontWeight: widget.isActive
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: widget.isActive ? accent : Colors.white38,
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
