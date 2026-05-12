import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'services/bluetooth_service.dart';
import 'providers/controller_provider.dart';
import 'screens/controller_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock to portrait orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Full immersive dark system chrome
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0A0A0A),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const RcControllerApp());
}

class RcControllerApp extends StatelessWidget {
  const RcControllerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final btService = BluetoothService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BluetoothService>.value(value: btService),
        ChangeNotifierProvider<ControllerProvider>(
          create: (_) => ControllerProvider(btService: btService),
        ),
      ],
      child: MaterialApp(
        title: 'Embedded System 2026',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF4FC3F7),
            surface: Color(0xFF141414),
          ),
          textTheme: GoogleFonts.robotoMonoTextTheme(
            ThemeData.dark().textTheme,
          ),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        home: const ControllerScreen(),
      ),
    );
  }
}
