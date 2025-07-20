import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 6,
            shadowColor: Colors.black45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
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
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    super.dispose();
  }

  Future<void> _turnScreenOff() async {
    try {
      await platform.invokeMethod('turnOffScreen');
    } on PlatformException catch (e) {
      debugPrint("Failed to lock screen: ${e.message}");
    }
  }

  Future<void> _simulateScreenOff() async {
    try {
      await platform.invokeMethod('simulateScreenOff');
    } on PlatformException catch (e) {
      debugPrint("Failed to simulate screen off: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Screen Off'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.black54],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black54, Colors.grey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.power_settings_new,
                      size: 80,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Control Your Screen',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ScaleTransition(
                      scale: _buttonScaleAnimation,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _buttonAnimationController.forward().then((_) {
                            _buttonAnimationController.reverse();
                            _turnScreenOff();
                          });
                        },
                        icon: const Icon(Icons.lock_outline, size: 24),
                        label: const Text('Lock Device'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ScaleTransition(
                      scale: _buttonScaleAnimation,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _buttonAnimationController.forward().then((_) {
                            _buttonAnimationController.reverse();
                            _simulateScreenOff();
                          });
                        },
                        icon: const Icon(Icons.visibility_off_outlined, size: 24),
                        label: const Text('Fake Screen Off'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '• "Lock Device" locks with admin (PIN only).\n'
                      '• "Fake Screen Off" dims screen (tap to wake).',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[900],
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
    );
  }
}