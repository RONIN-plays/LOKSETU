import 'package:flutter/material.dart';
import '../models/complaint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  String _selectedStatusFilter = 'All';
  String _selectedCategoryFilter = 'All';

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _statusFilters = [
    'All',
    'Submitted',
    'In Progress',
    'Resolved',
    'Rejected'
  ];

  final List<String> _categoryFilters = [
    'All',
    'Water',
    'Road',
    'Sanitation',
    'Electricity',
    'Other'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('complaints').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text("Error: ${snapshot.error}")));
        }

        List<Complaint> allComplaints = snapshot.data!.docs.map((doc) {
          return Complaint.fromJson(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        // Filter complaints based on selections and search query
        List<Complaint> filteredComplaints = allComplaints.where((c) {
          bool matchesStatus = _selectedStatusFilter == 'All' || c.status == _selectedStatusFilter;
          bool matchesCategory = _selectedCategoryFilter == 'All' || c.category == _selectedCategoryFilter;
          bool matchesSearch = _searchQuery.isEmpty || c.id.toLowerCase().contains(_searchQuery.toLowerCase());
          return matchesStatus && matchesCategory && matchesSearch;
        }).toList();

        int total = allComplaints.length;
        int pending = allComplaints.where((c) => c.status == 'Submitted').length;
        int resolved = allComplaints.where((c) => c.status == 'Resolved').length;
        
        // Calculate most frequent category
        Map<String, int> categoryCount = {};
        for (var complaint in allComplaints) {
          categoryCount[complaint.category] = (categoryCount[complaint.category] ?? 0) + 1;
        }
        String? mostFrequentCategory;
        int maxCount = 0;
        categoryCount.forEach((category, count) {
          if (count > maxCount) {
            maxCount = count;
            mostFrequentCategory = category;
          }
        });

        return Scaffold(
          backgroundColor: Color(0xFF001F3F), // Navy Blue Background
          appBar: AppBar(
            title: Text("Admin Dashboard", style: TextStyle(color: Color(0xFF001F3F), fontWeight: FontWeight.bold, letterSpacing: 1)),
            backgroundColor: Colors.white.withOpacity(0.92), // Matching login box color
            centerTitle: true,
            elevation: 4,
            iconTheme: IconThemeData(color: Color(0xFF001F3F)),
            actions: [
              IconButton(
                icon: Icon(Icons.logout, color: Color(0xFF001F3F)),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16), // Padding since banner is removed

                // Stats Card
                Container(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
                  decoration: BoxDecoration(
                    color: Color(0xFF001F3F),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem("Total", total.toString(), Icons.analytics_outlined, Color(0xFF00A8E8)),
                      _buildStatItem("Pending", pending.toString(), Icons.pending_actions_outlined, Colors.orangeAccent),
                      _buildStatItem("Resolved", resolved.toString(), Icons.check_circle_outline, Colors.greenAccent),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search by Complaint ID",
                        hintStyle: TextStyle(color: Colors.white54),
                        prefixIcon: Icon(Icons.search, color: Color(0xFF00A8E8)),
                        suffixIcon: _searchQuery.isNotEmpty 
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.white54),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            ) 
                          : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ),

                // Most Frequent Category Card
                if (mostFrequentCategory != null && _searchQuery.isEmpty)
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFE3F2FD).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.4), width: 1.5),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 4))
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF00A8E8), Color(0xFF003366)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.trending_up, color: Colors.white, size: 28),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Frequent Issue Category",
                                style: TextStyle(fontSize: 12, color: Color(0xFF546E7A), fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                mostFrequentCategory!,
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF003366)),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "$maxCount complaints found",
                                style: TextStyle(fontSize: 12, color: Color(0xFF0288D1), fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Filters
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Filter by Status", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 13)),
                      SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _statusFilters.map((status) => Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(status, style: TextStyle(color: Color(0xFF001F3F), fontWeight: FontWeight.bold)),
                              selected: _selectedStatusFilter == status,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedStatusFilter = status;
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: Color(0xFF00A8E8),
                              checkmarkColor: Color(0xFF001F3F),
                            ),
                          )).toList(),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text("Filter by Category", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 13)),
                      SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _categoryFilters.map((category) => Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category, style: TextStyle(color: Color(0xFF001F3F), fontWeight: FontWeight.bold)),
                              selected: _selectedCategoryFilter == category,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedCategoryFilter = category;
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: Color(0xFF00A8E8),
                              checkmarkColor: Color(0xFF001F3F),
                            ),
                          )).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                filteredComplaints.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox, size: 60, color: Colors.white24),
                              SizedBox(height: 16),
                              Text("No complaints found", style: TextStyle(fontSize: 18, color: Colors.white54)),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredComplaints.length,
                        itemBuilder: (context, index) {
                          return _buildAdminComplaintCard(filteredComplaints[index]);
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String title, String count, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
            border: Border.all(color: color.withOpacity(0.5), width: 1.5),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        SizedBox(height: 10),
        Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
        Text(title, style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5)),
      ],
    );
  }

  Widget _buildAdminComplaintCard(Complaint complaint) {
    Color statusColor;
    switch (complaint.status.toLowerCase()) {
      case 'submitted': statusColor = Color(0xFF00A8E8); break;
      case 'in progress': statusColor = Colors.orange; break;
      case 'resolved': statusColor = Colors.green; break;
      case 'rejected': statusColor = Colors.red; break;
      default: statusColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFFE3F2FD).withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.3), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showAdminComplaintDetails(complaint),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(complaint.id, style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF003366), fontSize: 13, letterSpacing: 0.5)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Text(complaint.status.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: statusColor, letterSpacing: 0.5)),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(complaint.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF003366)), maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.category_outlined, size: 14, color: Color(0xFF546E7A)),
                  SizedBox(width: 4),
                  Text("${complaint.category}", style: TextStyle(fontSize: 12, color: Color(0xFF546E7A), fontWeight: FontWeight.w600)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text("•", style: TextStyle(color: Color(0xFFB0BEC5))),
                  ),
                  Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF546E7A)),
                  SizedBox(width: 4),
                  Text("${complaint.timestamp.length > 10 ? complaint.timestamp.substring(0, 10) : complaint.timestamp}", style: TextStyle(fontSize: 12, color: Color(0xFF546E7A), fontWeight: FontWeight.w600)),
                ],
              ),
              SizedBox(height: 8),
              if (complaint.submittedBy != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Color(0xFF003366).withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_outline, size: 14, color: Color(0xFF0288D1)),
                      SizedBox(width: 4),
                      Text("By: ${complaint.submittedBy}", style: TextStyle(fontSize: 11, color: Color(0xFF0288D1), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 14, color: Color(0xFFF44336)),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      complaint.location,
                      style: TextStyle(fontSize: 12, color: Color(0xFF546E7A), fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFFB0BEC5)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAdminComplaintDetails(Complaint complaint) {
    String currentStatus = complaint.status;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                  return Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  padding: EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(color: Color(0xFFB0BEC5), borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        SizedBox(height: 24),
                        Text("Update Issue Status", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF003366))),
                        Divider(height: 40, thickness: 1.5, color: Color(0xFF00A8E8).withOpacity(0.2)),
                        
                        Text("COMPLAINT ID: ${complaint.id}", style: TextStyle(color: Color(0xFF546E7A), fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1)),
                        SizedBox(height: 12),
                        Text(complaint.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.1))),
                          child: Text(complaint.description, style: TextStyle(fontSize: 14, color: Color(0xFF37474F), height: 1.5)),
                        ),
                        SizedBox(height: 24),
                        
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 18, color: Color(0xFFF44336)),
                            SizedBox(width: 8),
                            Expanded(child: Text(complaint.location, style: TextStyle(fontSize: 14, color: Color(0xFF546E7A), fontWeight: FontWeight.w600))),
                          ],
                        ),
                        SizedBox(height: 24),
                        
                        if (complaint.submittedBy != null) ...[
                          Text("Reporter:", style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF003366), fontSize: 13)),
                          SizedBox(height: 8),
                          Text(complaint.submittedBy!, style: TextStyle(color: Color(0xFF0288D1), fontWeight: FontWeight.bold)),
                          SizedBox(height: 24),
                        ],
                        
                        Text("Set New Status:", style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF003366), fontSize: 13)),
                        SizedBox(height: 12),
                        
                        DropdownButtonFormField<String>(
                          value: currentStatus,
                          dropdownColor: Colors.white,
                          style: TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.w700),
                          items: ['Submitted', 'In Progress', 'Resolved', 'Rejected']
                              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                currentStatus = val;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF00A8E8).withOpacity(0.3))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF00A8E8), width: 1.5)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                        
                        SizedBox(height: 32),
                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF00A8E8),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 4,
                            ),
                            onPressed: () async {
                              // Update Firestore
                              try {
                                await FirebaseFirestore.instance
                                    .collection('complaints')
                                    .doc(complaint.id)
                                    .update({'status': currentStatus});
                                    
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Status updated to $currentStatus'), 
                                    backgroundColor: Color(0xFF003366),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error updating status: $e'), backgroundColor: Colors.red),
                                );
                              }
                            },
                            child: Text("SAVE STATUS", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1)),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            );
          }
        );
      }
    );
  }
}