import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelplineScreen extends StatelessWidget {
  final List<Map<String, String>> helplines = [
    {"name": "General Emergency", "number": "112", "icon": "sos"},
    {"name": "Police", "number": "100", "icon": "local_police"},
    {"name": "Fire Brigade", "number": "101", "icon": "fire_truck"},
    {"name": "Ambulance", "number": "102", "icon": "medical_services"},
    {"name": "Women Helpline", "number": "1091", "icon": "woman"},
    {"name": "Child Helpline", "number": "1098", "icon": "child_care"},
    {"name": "Disaster Management", "number": "108", "icon": "warning"},
  ];

  Future<void> _makeCall(String number) async {
    final Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'sos': return Icons.sos;
      case 'local_police': return Icons.local_police;
      case 'fire_truck': return Icons.fire_truck;
      case 'medical_services': return Icons.medical_services;
      case 'woman': return Icons.woman;
      case 'child_care': return Icons.child_care;
      case 'warning': return Icons.warning;
      default: return Icons.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF001F3F),
      appBar: AppBar(
        title: Text("Emergency Helplines", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF001F3F),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: helplines.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = helplines[index];
          return GestureDetector(
            onTap: () => _makeCall(item['number']!),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Color(0xFFE3F2FD).withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.4), width: 1.5),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00A8E8), Color(0xFF003366)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_getIcon(item['icon']!), color: Colors.white, size: 22),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF003366))),
                        SizedBox(height: 2),
                        Text(item['number']!, style: TextStyle(fontSize: 13, color: Color(0xFF0288D1), fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF00A8E8).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.4)),
                    ),
                    child: Icon(Icons.call, color: Color(0xFF00A8E8), size: 20),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
