import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ScreenOffApp());
}

class ScreenOffApp extends StatelessWidget {
  const ScreenOffApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen Off App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
        scaffoldBackgroundColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            elevation: 6,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            shadowColor: Colors.black54,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static const platform = MethodChannel('screen_off_channel');

  late final AnimationController _lockController;
  late final AnimationController _fakeController;
  late final Animation<double> _lockScale;
  late final Animation<double> _fakeScale;

  @override
  void initState() {
    super.initState();
    _lockController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _fakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _lockScale = _lockController;
    _fakeScale = _fakeController;
  }

  @override
  void dispose() {
    _lockController.dispose();
    _fakeController.dispose();
    super.dispose();
  }

  Future<void> _turnScreenOff() async {
    HapticFeedback.lightImpact();
    try {
      await platform.invokeMethod('turnOffScreen');
    } on PlatformException catch (e) {
      debugPrint("Failed to lock screen: ${e.message}");
    }
  }

  Future<void> _simulateScreenOff() async {
    HapticFeedback.lightImpact();
    try {
      await platform.invokeMethod('simulateScreenOff');
    } on PlatformException catch (e) {
      debugPrint("Failed to simulate screen off: ${e.message}");
    }
  }

  Widget _buildButton({
    required AnimationController controller,
    required Animation<double> scale,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ScaleTransition(
      scale: scale,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(60),
          shadowColor: Colors.black45,
          elevation: 6,
        ),
        icon: Icon(icon, size: 28),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          controller.reverse().then((_) {
            controller.forward();
            onPressed();
          });
        },
        onLongPress: () => controller.reverse().then((_) => controller.forward()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Gradient background with a soft overlay for a modern look
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [scheme.primary, scheme.secondary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Foreground content with safe area
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.power_settings_new, size: 80, color: scheme.onPrimary),
                          const SizedBox(height: 20),
                          Text(
                            'Control Your Screen',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: scheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 28),
                          // Buttons with modern elevated style
                          _buildButton(
                            controller: _lockController,
                            scale: _lockScale,
                            icon: Icons.lock_outline,
                            label: 'Lock Device',
                            onPressed: _turnScreenOff,
                            color: scheme.primary,
                          ),
                          const SizedBox(height: 16),
                          _buildButton(
                            controller: _fakeController,
                            scale: _fakeScale,
                            icon: Icons.visibility_off_outlined,
                            label: 'Fake Screen Off',
                            onPressed: _simulateScreenOff,
                            color: scheme.secondary,
                          ),
                          const SizedBox(height: 24),
                          // Descriptive text
                          Text(
                            '• "Lock Device" locks with admin (PIN only).\n'
                            '• "Fake Screen Off" dims screen (tap to wake).',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                  height: 1.5,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}