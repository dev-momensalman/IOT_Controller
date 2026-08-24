import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/bluetooth_service.dart';

enum _LogType { sent, system, error }

class _TerminalLogEntry {
  final DateTime timestamp;
  final String message;
  final _LogType type;

  _TerminalLogEntry({
    required this.timestamp,
    required this.message,
    required this.type,
  });
}

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final List<_TerminalLogEntry> _logs = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Add initialization log
    _logs.add(_TerminalLogEntry(
      timestamp: DateTime.now(),
      message: "Terminal initialized. Ready for custom commands...",
      type: _LogType.system,
    ));
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendCommand() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    final bt = Provider.of<BluetoothService>(context, listen: false);

    setState(() {
      _logs.add(_TerminalLogEntry(
        timestamp: DateTime.now(),
        message: text,
        type: _LogType.sent,
      ));
    });

    // Send via Bluetooth
    bt.sendCommand(text);

    // Show warning if disconnected
    if (!bt.isConnected) {
      setState(() {
        _logs.add(_TerminalLogEntry(
          timestamp: DateTime.now(),
          message: "Warning: Bluetooth disconnected. Command ignored by hardware.",
          type: _LogType.error,
        ));
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
              const SizedBox(width: 12),
              Text(
                "Bluetooth disconnected!",
                style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF141414),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.orangeAccent.withOpacity(0.3)),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    _inputController.clear();
    _focusNode.requestFocus();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
      _logs.add(_TerminalLogEntry(
        timestamp: DateTime.now(),
        message: "Console history cleared.",
        type: _LogType.system,
      ));
    });
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  }

  Color _getLogColor(_LogType type) {
    switch (type) {
      case _LogType.sent:
        return const Color(0xFF4FC3F7);
      case _LogType.system:
        return Colors.white38;
      case _LogType.error:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bt = Provider.of<BluetoothService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "CUSTOM TERMINAL",
          style: GoogleFonts.robotoMono(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4FC3F7),
            letterSpacing: 2.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white70, size: 22),
            onPressed: _clearLogs,
            tooltip: "Clear Console",
          ),
        ],
        shape: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Bluetooth Connection Status Bar ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white.withOpacity(0.02),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bt.isConnected ? const Color(0xFF4FC3F7) : Colors.white24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    bt.isConnected ? "CONNECTED TO: ${bt.deviceName}" : "STATUS: DISCONNECTED",
                    style: GoogleFonts.robotoMono(
                      color: bt.isConnected ? Colors.white70 : Colors.white38,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // ── Terminal Console Logs ──
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    final log = _logs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: SelectableText.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "[${_formatTime(log.timestamp)}] ",
                              style: GoogleFonts.robotoMono(color: Colors.white30, fontSize: 11),
                            ),
                            if (log.type == _LogType.sent) ...[
                              TextSpan(
                                text: "TX -> ",
                                style: GoogleFonts.robotoMono(
                                  color: const Color(0xFF4FC3F7).withOpacity(0.7),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                            if (log.type == _LogType.error) ...[
                              TextSpan(
                                text: "ERR -> ",
                                style: GoogleFonts.robotoMono(
                                  color: Colors.redAccent.withOpacity(0.7),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                            TextSpan(
                              text: log.message,
                              style: GoogleFonts.robotoMono(
                                color: _getLogColor(log.type),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ── Command Input Panel ──
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                8,
                16,
                MediaQuery.of(context).padding.bottom + 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      focusNode: _focusNode,
                      style: GoogleFonts.robotoMono(color: Colors.white, fontSize: 13),
                      cursorColor: const Color(0xFF4FC3F7),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendCommand(),
                      decoration: InputDecoration(
                        hintText: "Enter custom command or string...",
                        hintStyle: GoogleFonts.robotoMono(color: Colors.white24, fontSize: 11),
                        fillColor: const Color(0xFF0A0A0A),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: const Color(0xFF4FC3F7).withOpacity(0.4), width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF4FC3F7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF4FC3F7).withOpacity(0.3)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Color(0xFF4FC3F7), size: 20),
                      onPressed: _sendCommand,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
