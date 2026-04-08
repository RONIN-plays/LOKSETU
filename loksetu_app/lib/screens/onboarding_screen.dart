import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingItem> _items = [
    _OnboardingItem(
      icon: Icons.account_balance_outlined,
      title: "Welcome to Lok Setu",
      subtitle: "Your bridge between citizens and government. Empowering communities through transparent governance.",
      gradient: [Color(0xFF001F3F), Color(0xFF003366)],
    ),
    _OnboardingItem(
      icon: Icons.report_problem_outlined,
      title: "Report Civic Issues",
      subtitle: "From broken roads to water supply problems — report any issue in seconds and get it resolved.",
      gradient: [Color(0xFF003366), Color(0xFF00A8E8)],
    ),
    _OnboardingItem(
      icon: Icons.track_changes_outlined,
      title: "Track & Stay Updated",
      subtitle: "Follow every complaint from submission to resolution. Transparency at every step.",
      gradient: [Color(0xFF00A8E8), Color(0xFF003366)],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page View
          PageView.builder(
            controller: _pageController,
            itemCount: _items.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return _buildPage(_items[index]);
            },
          ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(32, 24, 32, 48),
              child: Column(
                children: [
                  // Dot Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_items.length, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Color(0xFF00A8E8)
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 32),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00A8E8),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                      ),
                      onPressed: () {
                        if (_currentPage < _items.length - 1) {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _goToLogin();
                        }
                      },
                      child: Text(
                        _currentPage == _items.length - 1 ? "Get Started" : "Next",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Skip Button
                  if (_currentPage < _items.length - 1)
                    TextButton(
                      onPressed: _goToLogin,
                      child: Text(
                        "Skip",
                        style: TextStyle(color: Colors.white60, fontSize: 14),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardingItem item) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: item.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(32, 60, 32, 220),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Large Icon
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF00A8E8).withOpacity(0.6),
                    width: 2,
                  ),
                ),
                child: Icon(
                  item.icon,
                  size: 70,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 48),

              // Title
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 20),

              // Subtitle
              Text(
                item.subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  _OnboardingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}
