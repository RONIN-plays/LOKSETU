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
    } else {
      throw 'Could not launch $url';
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
      backgroundColor: Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text("Emergency Helplines"),
        backgroundColor: Color(0xFF6A11CB),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: helplines.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = helplines[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFF6A11CB).withOpacity(0.1),
                child: Icon(_getIcon(item['icon']!), color: Color(0xFF6A11CB)),
              ),
              title: Text(
                item['name']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item['number']!),
              trailing: IconButton(
                icon: Icon(Icons.call, color: Colors.green),
                onPressed: () => _makeCall(item['number']!),
              ),
              onTap: () => _makeCall(item['number']!),
            ),
          );
        },
      ),
    );
  }
}
