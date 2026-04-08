import 'package:flutter/material.dart';
import '../models/complaint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackComplaintScreen extends StatefulWidget {
  @override
  _TrackComplaintScreenState createState() => _TrackComplaintScreenState();
}

class _TrackComplaintScreenState extends State<TrackComplaintScreen> {
  TextEditingController complaintIdController = TextEditingController();

  bool showDetails = false;
  bool complaintFound = false;
  dynamic foundComplaint;

  Future<void> _searchComplaint() async {
    String enteredId = complaintIdController.text.trim().toUpperCase();

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('complaints')
          .doc(enteredId)
          .get();

      Navigator.pop(context); // Close loading dialog

      setState(() {
        if (doc.exists) {
          foundComplaint = Complaint.fromJson(doc.data() as Map<String, dynamic>, doc.id);
          complaintFound = true;
        } else {
          complaintFound = false;
        }
        showDetails = true;
      });
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      setState(() {
        complaintFound = false;
        showDetails = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error searching complaint: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF001F3F),
      appBar: AppBar(
        title: Text("Track Complaint", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF001F3F),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Complaint ID Input
            Text(
              "Enter Complaint ID",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),
            TextField(
              controller: complaintIdController,
              style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF8F9FA),
                hintText: "Example: LS1024",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Color(0xFFE0E0E0))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2)),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00A8E8),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  if (complaintIdController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a complaint ID')));
                    return;
                  }
                  _searchComplaint();
                },
                child: Text("Track Complaint", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
              ),
            ),
            SizedBox(height: 25),

            /// Show complaint details or not found message
            if (showDetails) ...[
              if (!complaintFound)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 50),
                      SizedBox(height: 10),
                      Text("Complaint Not Found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                      SizedBox(height: 8),
                      Text("No complaint found with ID: ${complaintIdController.text}", textAlign: TextAlign.center, style: TextStyle(color: Colors.red.shade700)),
                    ],
                  ),
                )
              else ...[
                SizedBox(height: 8),
                Text("Complaint Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Color(0xFFE3F2FD).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.4), width: 1.5),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.receipt_long, color: Color(0xFF00A8E8), size: 28),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Complaint ID", style: TextStyle(fontSize: 12, color: Color(0xFF0288D1))),
                          Text(foundComplaint.id, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003366), letterSpacing: 1)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                _detailLabel("Title"),
                SizedBox(height: 5),
                _detailBox(child: Text(foundComplaint.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF003366)))),
                SizedBox(height: 16),

                /// Category and Status in Row
                Row(
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _detailLabel("Category"),
                        SizedBox(height: 5),
                        _detailBox(child: Text(foundComplaint.category, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF003366)))),
                      ],
                    )),
                    SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _detailLabel("Status"),
                        SizedBox(height: 5),
                        _detailBox(child: Text(foundComplaint.status, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF00A8E8)))),
                      ],
                    )),
                  ],
                ),
                SizedBox(height: 16),
                _detailLabel("Submitted On"),
                SizedBox(height: 5),
                _detailBox(child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Color(0xFF00A8E8), size: 18),
                    SizedBox(width: 8),
                    Expanded(child: Text(foundComplaint.timestamp, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF003366)))),
                  ],
                )),
                SizedBox(height: 16),
                _detailLabel("Description"),
                SizedBox(height: 5),
                _detailBox(child: Text(foundComplaint.description, style: TextStyle(fontSize: 14, color: Color(0xFF003366), height: 1.5))),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFE3F2FD).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.business, color: Color(0xFF00A8E8), size: 22),
                        SizedBox(width: 8),
                        Text("Contact Department", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                      ]),
                      SizedBox(height: 8),
                      Text("Municipal Corporation", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF003366))),
                      SizedBox(height: 4),
                      Text("Contact our department for further assistance", style: TextStyle(fontSize: 12, color: Color(0xFF0288D1))),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, padding: EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              onPressed: () async { final Uri url = Uri.parse('tel:1800123456'); if (await canLaunchUrl(url)) await launchUrl(url); },
                              icon: Icon(Icons.call_rounded, color: Colors.white),
                              label: Text("Call Now", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00A8E8), padding: EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              onPressed: () async { final Uri url = Uri.parse('mailto:support@loksetu.com?subject=Tracking Complaint ${foundComplaint.id}'); if (await canLaunchUrl(url)) await launchUrl(url); },
                              icon: Icon(Icons.email_rounded, color: Colors.white),
                              label: Text("Email", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _detailLabel(String text) {
    return Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70));
  }

  Widget _detailBox({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFE3F2FD).withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.3)),
      ),
      child: child,
    );
  }
}
