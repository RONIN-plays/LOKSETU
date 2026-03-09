import 'package:flutter/material.dart';
import '../data/complaint_data.dart';

class MyComplaintsScreen extends StatefulWidget {
  @override
  _MyComplaintsScreenState createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Complaints"),
        backgroundColor: Color(0xFF6A11CB),
      ),
      body: complaints.isEmpty ? _buildEmptyState() : _buildComplaintsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 80, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            "No Complaints Yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Your submitted complaints will appear here",
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6A11CB),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.add),
            label: Text("Report New Issue"),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        final complaint = complaints[index];
        return _buildComplaintCard(complaint);
      },
    );
  }

  Widget _buildComplaintCard(dynamic complaint) {
    Color statusColor;
    IconData statusIcon;

    switch (complaint.status.toLowerCase()) {
      case 'submitted':
        statusColor = Colors.blue;
        statusIcon = Icons.schedule;
        break;
      case 'in progress':
        statusColor = Colors.orange;
        statusIcon = Icons.work;
        break;
      case 'resolved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showComplaintDetails(complaint);
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Complaint ID and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF6A11CB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      complaint.id,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A11CB),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        SizedBox(width: 4),
                        Text(
                          complaint.status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Title
              Text(
                complaint.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),

              // Category
              Row(
                children: [
                  Icon(Icons.category, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    complaint.category,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Date
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    complaint.timestamp,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Description preview
              Text(
                complaint.description,
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 12),

              // Tap to view details
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Tap for details",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6A11CB),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Color(0xFF6A11CB),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComplaintDetails(dynamic complaint) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF6A11CB).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.description,
                            color: Color(0xFF6A11CB),
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Complaint Details",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                complaint.id,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Status
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.orange[700]),
                          SizedBox(width: 10),
                          Text(
                            "Status: ${complaint.status}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Title
                    Text(
                      "Title",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      complaint.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Category
                    Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      complaint.category,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Submitted Date
                    Text(
                      "Submitted On",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      complaint.timestamp,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Description
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(
                        complaint.description,
                        style: TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Contact Department
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.business,
                                color: Colors.blue[700],
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Contact Department",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Municipal Corporation",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  onPressed: () {},
                                  icon: Icon(Icons.call_rounded),
                                  label: Text("Call"),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  onPressed: () {},
                                  icon: Icon(Icons.email_rounded),
                                  label: Text("Email"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}