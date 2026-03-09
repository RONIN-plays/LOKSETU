import 'package:flutter/material.dart';
import 'report_issue_screen.dart';
import 'track_complaint_screen.dart';
import 'my_complaint_screen.dart';
import 'village_issues_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    MyComplaintsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FB),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF6A11CB),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: "My Complaints",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              "Hello, User",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search services",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            Text(
              "Quick Services",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.3,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportIssueScreen(),
                        ),
                      );
                    },
                    child: serviceCard(
                      Icons.report,
                      "Report Issue",
                      Colors.blue.shade100,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackComplaintScreen(),
                        ),
                      );
                    },
                    child: serviceCard(
                      Icons.track_changes,
                      "Track Complaint",
                      Colors.yellow.shade100,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VillageIssuesScreen(),
                        ),
                      );
                    },
                    child: serviceCard(
                      Icons.map,
                      "Village Issues",
                      Colors.green.shade100,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Govt Schemes screen
                    },
                    child: serviceCard(
                      Icons.account_balance,
                      "Govt Schemes",
                      Colors.blue.shade100,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Helpline screen
                    },
                    child: serviceCard(
                      Icons.phone,
                      "Helpline",
                      Colors.red.shade100,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to More screen
                    },
                    child: serviceCard(
                      Icons.more_horiz,
                      "More",
                      Colors.grey.shade200,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            Text(
              "Recent Activity",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.assignment, color: Colors.blue),
              title: Text("Reported Road Damage"),
              subtitle: Text("Status: In Progress"),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceCard(IconData icon, String title, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Color(0xFF6A11CB),
      ),
      body: Center(child: Text("Profile Screen - Coming Soon")),
    );
  }
}
//i am nirjhar