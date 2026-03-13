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
          backgroundColor: Color(0xFFF5F7FB),
          appBar: AppBar(
            title: Text("Admin Dashboard"),
            backgroundColor: Color(0xFF6A11CB),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
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
          body: Column(
            children: [
              // Stats Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF6A11CB),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem("Total", total.toString(), Icons.analytics),
                    _buildStatItem("Pending", pending.toString(), Icons.pending_actions),
                    _buildStatItem("Resolved", resolved.toString(), Icons.check_circle_outline),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: Offset(0, 2))
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search by Complaint ID",
                      prefixIcon: Icon(Icons.search, color: Color(0xFF6A11CB)),
                      suffixIcon: _searchQuery.isNotEmpty 
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          ) 
                        : null,
                      filled: true,
                      fillColor: Colors.transparent, // Color is now handled by Container
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),

              // Most Frequent Category Card
              if (mostFrequentCategory != null && _searchQuery.isEmpty)
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200, width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: Offset(0, 2))
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.trending_up, color: Colors.blue, size: 28),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Most Frequent Issue Category",
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 4),
                            Text(
                              mostFrequentCategory!,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6A11CB)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "$maxCount complaints",
                              style: TextStyle(fontSize: 12, color: Colors.blue[600]),
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
                    Text("Filter by Status", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                    SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _statusFilters.map((status) => Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(status),
                            selected: _selectedStatusFilter == status,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedStatusFilter = status;
                              });
                            },
                            selectedColor: Color(0xFF6A11CB).withOpacity(0.2),
                            checkmarkColor: Color(0xFF6A11CB),
                          ),
                        )).toList(),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text("Filter by Category", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                    SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categoryFilters.map((category) => Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: _selectedCategoryFilter == category,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedCategoryFilter = category;
                              });
                            },
                            selectedColor: Colors.blue.withOpacity(0.2),
                            checkmarkColor: Colors.blue,
                          ),
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: filteredComplaints.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox, size: 60, color: Colors.grey[400]),
                            SizedBox(height: 16),
                            Text("No complaints found", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: filteredComplaints.length,
                        itemBuilder: (context, index) {
                          return _buildAdminComplaintCard(filteredComplaints[index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String title, String count, IconData icon) {
    return Column(
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
        SizedBox(height: 8),
        Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(title, style: TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildAdminComplaintCard(Complaint complaint) {
    Color statusColor;
    switch (complaint.status.toLowerCase()) {
      case 'submitted': statusColor = Colors.blue; break;
      case 'in progress': statusColor = Colors.orange; break;
      case 'resolved': statusColor = Colors.green; break;
      case 'rejected': statusColor = Colors.red; break;
      default: statusColor = Colors.grey;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showAdminComplaintDetails(complaint),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(complaint.id, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6A11CB))),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(complaint.status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(complaint.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: 4),
              Text("Category: ${complaint.category} • ${complaint.timestamp.length > 10 ? complaint.timestamp.substring(0, 10) : complaint.timestamp}", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              if (complaint.submittedBy != null) ...[
                SizedBox(height: 4),
                Text("By: ${complaint.submittedBy}", style: TextStyle(fontSize: 12, color: Colors.blue[700], fontStyle: FontStyle.italic)),
              ]
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
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Update Issue Status", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Divider(height: 30),
                        
                        Text("Complaint ID: ${complaint.id}", style: TextStyle(color: Colors.grey[600])),
                        SizedBox(height: 10),
                        Text(complaint.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text(complaint.description, style: TextStyle(fontSize: 14)),
                        SizedBox(height: 20),
                        
                        if (complaint.submittedBy != null) ...[
                          Text("Reporter Details:", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(complaint.submittedBy!),
                          SizedBox(height: 20),
                        ],
                        
                        Text("Current Status:", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        
                        DropdownButtonFormField<String>(
                          value: currentStatus,
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
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                        
                        SizedBox(height: 30),
                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6A11CB),
                              padding: EdgeInsets.symmetric(vertical: 14),
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
                                  SnackBar(content: Text('Status updated to $currentStatus'), backgroundColor: Colors.green),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error updating status: $e'), backgroundColor: Colors.red),
                                );
                              }
                            },
                            child: Text("Save Changes", style: TextStyle(fontSize: 16, color: Colors.white)),
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