/// All Bluetooth command strings sent to the RC vehicle.
/// Centralizing here ensures consistency across the entire application.
class BtCommands {
  BtCommands._(); // prevent instantiation

  // ─── Movement ───────────────────────────────────────────────────────────────
  static const String forward = "F";
  static const String backward = "B";
  static const String left = "L";
  static const String right = "R";
  static const String stop = "S";

  // ─── Speed ──────────────────────────────────────────────────────────────────
  static const String speedUp = "+";
  static const String speedDown = "-";

  // ─── Gears ──────────────────────────────────────────────────────────────────
  static const String gear1 = "1";
  static const String gear2 = "2";
  static const String gear3 = "3";
  static const String gear4 = "4";

  // ─── Drive Modes ────────────────────────────────────────────────────────────
  static const String mode1Manual = "M";
  static const String mode2 = "A";
  static const String mode3 = "X";
}
