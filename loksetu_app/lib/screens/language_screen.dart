import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class LanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF003366), // Royal Blue
              Color(0xFF001F3F), // Navy Blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Branding
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.language, size: 60, color: Colors.white),
                ),
                SizedBox(height: 24),
                Text(
                  "Lok Setu",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(height: 60),
                
                Text(
                  "Select Your Language",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "আপনার ভাষা নির্বাচন করুন",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 48),

                // English Selection Card
                _buildLanguageCard(
                  context: context,
                  title: "English",
                  subtitle: "Standard Version",
                  icon: "A",
                  color: Color(0xFF6A11CB),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),

                SizedBox(height: 24),

                // Bengali Selection Card
                _buildLanguageCard(
                  context: context,
                  title: "বাংলা",
                  subtitle: "Bengali Version",
                  icon: "অ",
                  color: Color(0xFF2575FC),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
                
                Spacer(),
                Text(
                  "Connecting People & Authority",
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92), // Matching login box color
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFF6A11CB).withOpacity(0.3), width: 2.0), // Purple border like login box
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00A8E8), color], // Sky Blue to selection color
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF00A8E8).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Text(
                icon,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xFF001F3F), // Navy Blue for contrast on white
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Color(0xFF0288D1), // Blue subtitle text
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Color(0xFF001F3F).withOpacity(0.5), size: 16),
          ],
        ),
      ),
    );
  }
}
