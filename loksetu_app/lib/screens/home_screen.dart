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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full-width Banner Image (Edge-to-edge)
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Image.asset(
                  'assets/bg.jpg',
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Services",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),

                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.3,
                    children: [
                      _buildServiceItem(
                        context,
                        Icons.report,
                        "Report Issue",
                        Colors.blue.shade100,
                        ReportIssueScreen(),
                      ),
                      _buildServiceItem(
                        context,
                        Icons.track_changes,
                        "Track Complaint",
                        Colors.yellow.shade100,
                        TrackComplaintScreen(),
                      ),
                      _buildServiceItem(
                        context,
                        Icons.map,
                        "Village Issues",
                        Colors.green.shade100,
                        VillageIssuesScreen(),
                      ),
                      _buildServiceItem(
                        context,
                        Icons.account_balance,
                        "Govt Schemes",
                        Colors.blue.shade100,
                        null,
                      ),
                      _buildServiceItem(
                        context,
                        Icons.phone,
                        "Helpline",
                        Colors.red.shade100,
                        null,
                      ),
                      _buildServiceItem(
                        context,
                        Icons.more_horiz,
                        "More",
                        Colors.grey.shade200,
                        null,
                      ),
                    ],
                  ),
                  SizedBox(height: 25),

                  Text(
                    "Recent Activity",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.assignment, color: Colors.blue),
                      ),
                      title: Text("Reported Road Damage"),
                      subtitle: Text("Status: In Progress"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, IconData icon, String title, Color color, Widget? targetScreen) {
    return GestureDetector(
      onTap: () {
        if (targetScreen != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
        }
      },
      child: serviceCard(icon, title, color),
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
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.lightBlue.shade300, width: 1.5),
            ),
            child: Icon(icon, color: Color(0xFF003366), size: 28),
          ),
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