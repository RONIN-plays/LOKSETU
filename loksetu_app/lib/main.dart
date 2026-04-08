import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'screens/language_screen.dart';
import 'screens/onboarding_screen.dart';

// Global theme notifier
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Load saved theme preference
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDarkMode') ?? true;
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  runApp(LokSetuApp());
}

class LokSetuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Lok Setu',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Color(0xFFF0F4F8),
            colorScheme: ColorScheme.light(primary: Color(0xFF00A8E8)),
          ),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Color(0xFF001F3F),
            colorScheme: ColorScheme.dark(primary: Color(0xFF00A8E8)),
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.6, curve: Curves.easeIn)),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.7, curve: Curves.elasticOut)),
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.3, 0.8, curve: Curves.easeOutCubic)),
    );

    _controller.forward();

    Timer(Duration(seconds: 3), () async {
      if (mounted) {
        final prefs = await SharedPreferences.getInstance();
        final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => seenOnboarding ? LanguageScreen() : OnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF003366), // Royal Blue
              Color(0xFF001F3F), // Navy Blue
              Color(0xFF000B1A), // Dark Navy
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF2575FC).withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.account_balance,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 40),

              // Animated Title
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        "Lok Setu",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 4.0,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: 60,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Color(0xFF00A8E8), Colors.transparent],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Bridging Citizens & Governance",
                        style: TextStyle(
                          fontSize: 16, 
                          color: Colors.white.withOpacity(0.7),
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lok Setu"),
        backgroundColor: Color(0xFF6A11CB),
      ),
      body: Center(
        child: Text("Welcome to Lok Setu", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}

