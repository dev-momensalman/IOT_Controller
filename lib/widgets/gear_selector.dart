import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/controller_provider.dart';

/// Gear selection row: 1 2 3 4 with active highlight
class GearSelector extends StatelessWidget {
  const GearSelector({super.key});

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
                "GEAR SELECT",
                style: GoogleFonts.robotoMono(
                  fontSize: 10,
                  color: Colors.white30,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Row(
              children: List.generate(4, (i) {
                final gearNum = i + 1;
                final isActive = ctrl.gear == gearNum;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
                    child: _GearButton(
                      gear: gearNum,
                      isActive: isActive,
                      onTap: () => ctrl.setGear(gearNum),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

class _GearButton extends StatefulWidget {
  final int gear;
  final bool isActive;
  final VoidCallback onTap;

  const _GearButton({
    required this.gear,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_GearButton> createState() => _GearButtonState();
}

class _GearButtonState extends State<_GearButton>
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
    _scale = Tween<double>(begin: 1.0, end: 0.90).animate(
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
      onTapDown: (_) => _ac.forward(),
      onTapUp: (_) {
        _ac.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ac.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 48,
          decoration: BoxDecoration(
            color: widget.isActive
                ? Colors.white
                : const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isActive
                  ? Colors.white
                  : Colors.white.withOpacity(0.1),
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              "${widget.gear}",
              style: GoogleFonts.robotoMono(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.isActive
                    ? const Color(0xFF0A0A0A)
                    : Colors.white60,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
