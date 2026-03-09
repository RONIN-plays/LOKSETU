import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class LanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3E8FF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.language, size: 40, color: Color(0xFF6A11CB)),

              SizedBox(height: 20),

              Text(
                "Select Language",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              Text(
                "আপনার ভাষা নির্বাচন করুন",
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),

              SizedBox(height: 40),

              // English Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6A11CB),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text("English", style: TextStyle(fontSize: 18)),
              ),

              SizedBox(height: 20),

              // Bengali Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2575FC),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text("বাংলা", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}