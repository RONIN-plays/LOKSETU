import 'package:flutter/material.dart';

class VillageIssuesScreen extends StatelessWidget {
  const VillageIssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF001F3F),
      appBar: AppBar(
        title: const Text("Village Issues", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF001F3F),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Issues Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
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
                      gradient: LinearGradient(colors: [Color(0xFF00A8E8), Color(0xFF003366)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.report_problem, color: Colors.white, size: 22),
                  ),
                  SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Issues", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF003366))),
                      Text("32 complaints reported", style: TextStyle(fontSize: 13, color: Color(0xFF0288D1))),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            Text("Category Statistics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _issueCard("Water", 14, Icons.water_drop_outlined),
                _issueCard("Road", 9, Icons.add_road),
                _issueCard("Sanitation", 6, Icons.cleaning_services_outlined),
              ],
            ),

            SizedBox(height: 24),

            Text("Recent Complaints", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: [
                  _complaintTile(Icons.water_drop, "Dirty water supply", "Reported yesterday"),
                  SizedBox(height: 10),
                  _complaintTile(Icons.add_road, "Broken road near school", "Reported 2 days ago"),
                  SizedBox(height: 10),
                  _complaintTile(Icons.cleaning_services, "Garbage pile near market", "Reported today"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _issueCard(String title, int count, IconData icon) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFE3F2FD).withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xFF00A8E8), size: 24),
          SizedBox(height: 4),
          Text("$count", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
          SizedBox(height: 2),
          Text(title, style: TextStyle(fontSize: 11, color: Color(0xFF0288D1), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _complaintTile(IconData icon, String title, String subtitle) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFE3F2FD).withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.3), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF00A8E8), Color(0xFF003366)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366), fontSize: 14)),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Color(0xFF0288D1))),
            ],
          ),
        ],
      ),
    );
  }
}
