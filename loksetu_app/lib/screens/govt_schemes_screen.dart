import 'package:flutter/material.dart';

class GovtSchemesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> schemes = [
    {
      "title": "PM Kisan Samman",
      "subtitle": "Direct income support of ₹6,000 yearly to farmers.",
      "color": Color(0xFFE3F2FD),
      "icon": Icons.agriculture_outlined,
    },
    {
      "title": "Ayushman Bharat",
      "subtitle": "Health insurance cover of ₹5 lakh per family.",
      "color": Color(0xFFF1F8E9),
      "icon": Icons.health_and_safety_outlined,
    },
    {
      "title": "PM Awas Yojana",
      "subtitle": "Affordable housing for the urban and rural poor.",
      "color": Color(0xFFFFF3E0),
      "icon": Icons.home_work_outlined,
    },
    {
      "title": "Garib Kalyan Anna",
      "subtitle": "Free food grains to ensure food security for all.",
      "color": Color(0xFFF3E5F5),
      "icon": Icons.lunch_dining_outlined,
    },
    {
      "title": "Jal Jeevan Mission",
      "subtitle": "Safe drinking water through tap connections.",
      "color": Color(0xFFE0F7FA),
      "icon": Icons.water_drop_outlined,
    },
    {
      "title": "PM Mudra Yojana",
      "subtitle": "Loans up to ₹10 lakh to small enterprises.",
      "color": Color(0xFFFFFDE7),
      "icon": Icons.account_balance_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF001F3F),
      appBar: AppBar(
        title: Text("Government Schemes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF001F3F),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          return _buildSchemeCard(context, scheme);
        },
      ),
    );
  }

  Widget _buildSchemeCard(BuildContext context, Map<String, dynamic> scheme) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE3F2FD).withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.4), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 12, offset: Offset(0, 5))],
      ),
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: Icon(scheme['icon'], color: Colors.white, size: 22),
            ),
            SizedBox(height: 12),
            Text(
              scheme['title'],
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6),
            Expanded(
              child: Text(
                scheme['subtitle'],
                style: TextStyle(fontSize: 11, color: Color(0xFF0288D1), height: 1.3),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text("Explore", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366), fontSize: 12)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 12, color: Color(0xFF00A8E8)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
