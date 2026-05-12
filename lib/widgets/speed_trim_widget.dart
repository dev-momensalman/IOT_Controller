import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/bt_commands.dart';
import '../providers/controller_provider.dart';

/// Speed trim row: [ − ] ── SPEED TRIM ── [ + ]
class SpeedTrimWidget extends StatelessWidget {
  const SpeedTrimWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<ControllerProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        children: [
          _SpeedBtn(
            icon: Icons.remove_rounded,
            onTap: () => ctrl.send(BtCommands.speedDown),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SPEED TRIM",
                  style: GoogleFonts.robotoMono(
                    fontSize: 10,
                    color: Colors.white30,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.38),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Expanded(flex: 5, child: const SizedBox()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _SpeedBtn(
            icon: Icons.add_rounded,
            onTap: () => ctrl.send(BtCommands.speedUp),
          ),
        ],
      ),
    );
  }
}

class _SpeedBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SpeedBtn({required this.icon, required this.onTap});

  @override
  State<_SpeedBtn> createState() => _SpeedBtnState();
}

class _SpeedBtnState extends State<_SpeedBtn>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _ac;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
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
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _pressed
                ? const Color(0xFF4FC3F7).withOpacity(0.2)
                : const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _pressed
                  ? const Color(0xFF4FC3F7)
                  : Colors.white.withOpacity(0.12),
            ),
          ),
          child: Icon(
            widget.icon,
            color: _pressed ? const Color(0xFF4FC3F7) : Colors.white70,
            size: 22,
          ),
        ),
      ),
    );
  }
}




