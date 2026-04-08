import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart'; // To access themeNotifier

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF001F3F) : Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: isDarkMode ? Color(0xFF001F3F) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFFE3F2FD).withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Color(0xFF00A8E8)),
                    SizedBox(width: 16),
                    Text(
                      "Dark Mode",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87),
                    ),
                  ],
                ),
                Switch(
                  value: isDarkMode,
                  activeColor: Color(0xFF00A8E8),
                  onChanged: (val) async {
                    themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isDarkMode', val);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
