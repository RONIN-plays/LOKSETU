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
      backgroundColor: Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text("Government Schemes"),
        backgroundColor: Color(0xFF6A11CB),
        centerTitle: true,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.85, // Compact vertical cards
        ),
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          return _buildRefinedVerticalCard(context, scheme);
        },
      ),
    );
  }

  Widget _buildRefinedVerticalCard(BuildContext context, Map<String, dynamic> scheme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Colored Part
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: scheme['color'],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(scheme['icon'], color: Color(0xFF003366), size: 22),
                  ),
                  SizedBox(height: 10),
                  Text(
                    scheme['title'],
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    scheme['subtitle'],
                    style: TextStyle(fontSize: 10, color: Colors.black54, height: 1.2),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          // Bottom White Part
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Show scheme details
              },
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Explore",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6A11CB), fontSize: 12),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 12, color: Color(0xFF6A11CB)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
