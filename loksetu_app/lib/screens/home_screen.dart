import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'report_issue_screen.dart';
import 'track_complaint_screen.dart';
import 'my_complaint_screen.dart';
import 'village_issues_screen.dart';
import 'helpline_screen.dart';
import 'govt_schemes_screen.dart';
import 'login_screen.dart';
import 'settings_screen.dart';

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
      backgroundColor: Color(0xFF001F3F),
      drawer: Drawer(
        backgroundColor: Color(0xFF001F3F),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drawer Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00A8E8), Color(0xFF003366)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.account_balance_outlined, color: Colors.white, size: 32),
                    ),
                    SizedBox(height: 12),
                    Text("Lok Setu", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1)),
                    SizedBox(height: 4),
                    Text("Bridge to Governance", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
              SizedBox(height: 8),
              // Menu Items
              _drawerItem(context, Icons.info_outline, "About Us", () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Color(0xFF001F3F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Text("About Lok Setu", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    content: Text(
                      "Lok Setu is a citizen-centric platform that bridges the gap between citizens and government authorities. Report issues, track complaints, and access government schemes — all in one place.",
                      style: TextStyle(color: Colors.white70, height: 1.5),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Close", style: TextStyle(color: Color(0xFF00A8E8))),
                      ),
                    ],
                  ),
                );
              }),
              _drawerItem(context, Icons.phone_outlined, "Contact Us", () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Color(0xFF001F3F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Text("Contact Us", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("📧 support@loksetu.gov.in", style: TextStyle(color: Colors.white70)),
                        SizedBox(height: 8),
                        Text("📞 1800-123-456 (Toll Free)", style: TextStyle(color: Colors.white70)),
                        SizedBox(height: 8),
                        Text("🕐 Mon–Sat, 9 AM – 6 PM", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Close", style: TextStyle(color: Color(0xFF00A8E8))),
                      ),
                    ],
                  ),
                );
              }),
              _drawerItem(context, Icons.settings_outlined, "Settings", () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()));
              }),
              Divider(color: Colors.white12, indent: 16, endIndent: 16),
              _drawerItem(context, Icons.logout, "Logout", () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
              }, color: Colors.redAccent),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text("v1.0.0 • Lok Setu", style: TextStyle(color: Colors.white24, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFF001F3F),
          selectedItemColor: Color(0xFF00A8E8),
          unselectedItemColor: Colors.white54,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.description), label: "My Complaints"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color color = Colors.white}) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 15)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      horizontalTitleGap: 8,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      hoverColor: Colors.white10,
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Water',
    'Road',
    'Sanitation',
    'Electricity',
    'Other',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated Header (Replacing static banner)
            _AnimatedHeader(),

            // Hamburger Menu + Search Bar Row
            Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  // Hamburger Menu Button
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF001F3F),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6, offset: Offset(0, 3)),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => Scaffold.of(context).openDrawer(),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.menu, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Search Bar
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF001F3F),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6, offset: Offset(0, 3)),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: InputDecoration(
                          hintText: 'Search services...',
                          hintStyle: TextStyle(color: Colors.white54, fontSize: 13),
                          prefixIcon: Icon(Icons.search, color: Color(0xFF00A8E8), size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, color: Colors.white54, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Services",
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white, // White for contrast
                      letterSpacing: 0.5,
                    ),
                  ),
                   SizedBox(height: 24),

                  // 2-Column Grid of Service Cards
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      _buildVerticalServiceCard(
                        context,
                        Icons.report_problem_outlined,
                        "Report Issue",
                        "Found a problem? Report it here.",
                        "Quick resolution for issues.",
                        ReportIssueScreen(),
                      ),
                      _buildVerticalServiceCard(
                        context,
                        Icons.track_changes_outlined,
                        "Track Status",
                        "Track your reported issues.",
                        "Stay updated in real-time.",
                        TrackComplaintScreen(),
                      ),
                      _buildVerticalServiceCard(
                        context,
                        Icons.map_outlined,
                        "Village Issues",
                        "Problem in your village?",
                        "Collaborate with your community.",
                        VillageIssuesScreen(),
                      ),
                      _buildVerticalServiceCard(
                        context,
                        Icons.account_balance_outlined,
                        "Govt Schemes",
                        "Check your eligibility.",
                        "Access government benefits.",
                        GovtSchemesScreen(),
                      ),
                      _buildVerticalServiceCard(
                        context,
                        Icons.phone_in_talk_outlined,
                        "Helpline",
                        "Need immediate help?",
                        "Connect with support services.",
                        HelplineScreen(),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32),

                  Text(
                    "Recent Activity",
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white, // White for contrast
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      // Navigate to My Complaints
                    },
                    child: Card(
                      color: Colors.white.withOpacity(0.1), // Translucent for activity card
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFF00A8E8).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.assignment_outlined, color: Color(0xFF00A8E8)),
                        ),
                        title: Text(
                          "Road Repair Status", 
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        subtitle: Text(
                          "Status: In Progress • 2 hrs ago", 
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
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
        margin: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFE3F2FD).withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFF00A8E8).withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon at top
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00A8E8), Color(0xFF003366)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF00A8E8).withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            SizedBox(height: 10),
            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Color(0xFF003366),
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(height: 6),
            // Description
            Text(
              mainSubtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0288D1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedHeader extends StatefulWidget {
  @override
  __AnimatedHeaderState createState() => __AnimatedHeaderState();
}

class __AnimatedHeaderState extends State<_AnimatedHeader> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  // Using a Timer to animate.
  final List<_HeaderItem> _items = [
    _HeaderItem(
      icon: Icons.account_balance_outlined,
      title: "Lok Setu — Bridge to Governance",
      subtitle: "Connecting citizens directly with government officials for faster resolution.",
    ),
    _HeaderItem(
      icon: Icons.how_to_vote_outlined,
      title: "Your Voice. Your Right.",
      subtitle: "Report civic issues and hold authorities accountable — all in one place.",
    ),
    _HeaderItem(
      icon: Icons.handshake_outlined,
      title: "Transparent. Responsive. Empowered.",
      subtitle: "Track every complaint from submission to resolution in real time.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), _autoScroll);
  }

  void _autoScroll() {
    if (!mounted) return;
    setState(() {
      _currentPage = (_currentPage + 1) % _items.length;
    });
    _pageController.animateToPage(
      _currentPage,
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
    Future.delayed(Duration(seconds: 2), _autoScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: Color(0xFF003366),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF00A8E8), width: 2), // Added border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: PageView.builder(
          controller: _pageController,
          itemCount: _items.length,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            return _buildHeaderCard(_items[index]);
          },
        ),
      ),
    );
  }

  Widget _buildHeaderCard(_HeaderItem item) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFB3E5FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon on the LEFT
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00A8E8), Color(0xFF003366)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF00A8E8).withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(item.icon, color: Colors.white, size: 32),
          ),
          SizedBox(width: 16),
          // Title + Subtitle on the RIGHT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF003366),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF0288D1),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderItem {
  final IconData icon;
  final String title;
  final String subtitle;

  _HeaderItem({required this.icon, required this.title, required this.subtitle});
}
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        // Would be uploaded to Firebase Storage here and saved to user profile
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String email = user?.email ?? "citizen@loksetu.gov.in";
    String displayName = email.contains('@') ? email.split('@')[0] : "Citizen";
    String initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : "C";

    return Scaffold(
      backgroundColor: Color(0xFF001F3F),
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
        backgroundColor: Color(0xFF001F3F),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // --- Profile Card ---
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Color(0xFFE3F2FD).withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.4), width: 1.5),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12, offset: Offset(0, 5))],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Color(0xFF003366),
                          backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                          child: _profileImage == null
                              ? Text(initial, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white))
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Color(0xFF00A8E8),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(Icons.camera_alt, size: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF003366)),
                        ),
                        SizedBox(height: 4),
                        Text(email, style: TextStyle(fontSize: 12, color: Color(0xFF546E7A))),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFF003366),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified, size: 14, color: Color(0xFF00A8E8)),
                              SizedBox(width: 4),
                              Text("Verified Citizen", style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        Text("Tap to edit profile", style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- Menu Items ---
            _buildMenuItem(
              icon: Icons.description_outlined,
              title: "My Complaints",
              subtitle: "View all submitted issues",
            ),
            _buildMenuItem(
              icon: Icons.history_outlined,
              title: "Complaint History",
              subtitle: "Past resolved & pending issues",
            ),
            _buildMenuItem(
              icon: Icons.account_balance_outlined,
              title: "Govt Schemes",
              subtitle: "Benefits & welfare programs",
            ),
            _buildMenuItem(
              icon: Icons.phone_in_talk_outlined,
              title: "Helpline Numbers",
              subtitle: "Emergency contacts & support",
            ),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: "About Lok Setu",
              subtitle: "Version, mission & credits",
            ),

            SizedBox(height: 24),

            // --- Logout Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00A8E8),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
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
                label: Text("Logout", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required String subtitle}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xFFE3F2FD).withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.3), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00A8E8), Color(0xFF003366)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF003366), fontSize: 15)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Color(0xFF546E7A))),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF0288D1)),
        onTap: () {},
      ),
    );
  }
}


