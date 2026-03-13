import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'report_issue_screen.dart';
import 'track_complaint_screen.dart';
import 'my_complaint_screen.dart';
import 'village_issues_screen.dart';
import 'helpline_screen.dart';
import 'govt_schemes_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
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
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF6A11CB),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
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
            // Full-width Banner Image
            Container(
              width: double.infinity,
              height: 200,
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
                  bottomLeft: Radius.circular(75),
                  bottomRight: Radius.circular(75),
                ),
                child: Image.asset(
                  'assets/bg.jpg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Services",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
                  ),
                  SizedBox(height: 35),

                  // Vertical Service Cards (Matching the user's image style)
                  _buildVerticalServiceCard(
                    context,
                    Icons.report_problem_outlined,
                    "Report Issue",
                    "Found a problem? Report it here.",
                    "Quick resolution for your community issues.",
                    ReportIssueScreen(),
                  ),
                  _buildVerticalServiceCard(
                    context,
                    Icons.track_changes_outlined,
                    "Track Status",
                    "Track your reported issues.",
                    "Stay updated on the progress in real-time.",
                    TrackComplaintScreen(),
                  ),

                  _buildVerticalServiceCard(
                    context,
                    Icons.map_outlined,
                    "Village Issues",
                    "Found a problem in your village?",
                    "Collaborate with your community to fix it.",
                    VillageIssuesScreen(),
                  ),
                  _buildVerticalServiceCard(
                    context,
                    Icons.account_balance_outlined,
                    "Govt Schemes",
                    "Check your eligibility for schemes.",
                    "Access government benefits and welfare.",
                    GovtSchemesScreen(),
                  ),
                  _buildVerticalServiceCard(
                    context,
                    Icons.phone_in_talk_outlined,
                    "Helpline",
                    "Need immediate assistance?",
                    "Connect with emergency and support services.",
                    HelplineScreen(),
                  ),
                  
                  SizedBox(height: 30),

                  Text(
                    "Recent Activity",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      // Navigate to My Complaints
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFF6A11CB).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.assignment_outlined, color: Color(0xFF6A11CB)),
                        ),
                        title: Text("Road Repair Status", style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Status: In Progress • 2 hrs ago"),
                        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                      ),
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

  Widget _buildVerticalServiceCard(
    BuildContext context,
    IconData icon,
    String title,
    String mainSubtitle,
    String secondarySubtitle,
    Widget? targetScreen,
  ) {
    return GestureDetector(
      onTap: () {
        if (targetScreen != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Gradient Border
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF001F3F), Color(0xFF00A8E8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue.shade100, width: 2),
                    ),
                    child: Icon(icon, color: Color(0xFF003366), size: 28),
                  ),
                  SizedBox(width: 16),
                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          mainSubtitle,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          secondarySubtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
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


}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Color(0xFF6A11CB),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Color(0xFF6A11CB),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    user?.email ?? "User Email",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Citizen Account",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileItem(Icons.person_outline, "Account Details"),
                  _buildProfileItem(Icons.history, "Complaint History"),
                  _buildProfileItem(Icons.settings_outlined, "Settings"),
                  _buildProfileItem(Icons.help_outline, "Help & Support"),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                          (route) => false,
                        );
                      },
                      icon: Icon(Icons.logout, color: Colors.white),
                      label: Text("Logout", style: TextStyle(color: Colors.white, fontSize: 16)),
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

  Widget _buildProfileItem(IconData icon, String title) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF6A11CB)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () {},
      ),
    );
  }
}
//i am nirjhar