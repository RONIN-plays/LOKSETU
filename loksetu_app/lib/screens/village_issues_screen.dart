import 'package:flutter/material.dart';

class VillageIssuesScreen extends StatelessWidget {
  const VillageIssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Village Issues"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Issues Card
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.report_problem, color: Colors.red),
                title: const Text("Total Issues"),
                subtitle: const Text("32 complaints reported"),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Category Statistics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                issueCard("Water", 14, Colors.blue),
                issueCard("Road", 9, Colors.orange),
                issueCard("Sanitation", 6, Colors.green),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Recent Complaints",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.water_drop, color: Colors.blue),
                    title: Text("Dirty water supply"),
                    subtitle: Text("Reported yesterday"),
                  ),

                  ListTile(
                    leading: Icon(Icons.add_road, color: Colors.orange),
                    title: Text("Broken road near school"),
                    subtitle: Text("Reported 2 days ago"),
                  ),

                  ListTile(
                    leading: Icon(Icons.cleaning_services, color: Colors.green),
                    title: Text("Garbage pile near market"),
                    subtitle: Text("Reported today"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget issueCard(String title, int count, Color color) {
    return Card(
      elevation: 3,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "$count",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Text(title),
          ],
        ),
      ),
    );
  }
}
