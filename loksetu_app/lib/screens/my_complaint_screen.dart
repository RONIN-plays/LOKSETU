import 'package:flutter/material.dart';
import '../models/complaint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class MyComplaintsScreen extends StatefulWidget {
  @override
  _MyComplaintsScreenState createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  Future<void> _exportToPDF(Complaint complaint) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Lok Setu - Complaint Receipt', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    border: pw.Border.all(color: PdfColors.grey300),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Complaint ID: ${complaint.id}', style: pw.TextStyle(fontSize: 14)),
                      pw.SizedBox(height: 5),
                      pw.Text('Category: ${complaint.category}', style: pw.TextStyle(fontSize: 14)),
                      pw.SizedBox(height: 5),
                      pw.Text('Status: ${complaint.status.toUpperCase()}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      pw.Text('Date Submitted: ${complaint.timestamp}', style: pw.TextStyle(fontSize: 14)),
                    ]
                  )
                ),
                pw.SizedBox(height: 20),
                pw.Text('Issue Title', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                pw.Text(complaint.title, style: const pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 15),
                pw.Text('Detailed Description', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                pw.SizedBox(height: 8),
                pw.Text(complaint.description, style: const pw.TextStyle(fontSize: 12)),
                pw.SizedBox(height: 40),
                pw.Divider(),
                pw.Text('Generated securely via Lok Setu Citizen Portal', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
              ],
            );
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/${complaint.id}_receipt.pdf");
      await file.writeAsBytes(await pdf.save());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opening PDF sharing options...'), backgroundColor: Colors.green));
      }

      await Share.shareXFiles([XFile(file.path)], text: 'Complaint Receipt for ${complaint.id}');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error generating PDF: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      backgroundColor: Color(0xFF001F3F),
      appBar: AppBar(
        title: Text("My Complaints", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF001F3F),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .where('submittedBy', isEqualTo: userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          List<Complaint> userComplaints = snapshot.data!.docs.map((doc) {
            return Complaint.fromJson(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return _buildComplaintsList(userComplaints);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFE3F2FD).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.description_outlined, size: 60, color: Color(0xFF00A8E8).withOpacity(0.6)),
          ),
          SizedBox(height: 20),
          Text("No Complaints Yet", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 10),
          Text("Your submitted complaints will appear here", style: TextStyle(fontSize: 15, color: Colors.white60)),
          SizedBox(height: 30),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00A8E8),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.add, color: Colors.white),
            label: Text("Report New Issue", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintsList(List<Complaint> complaintsList) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: complaintsList.length,
      itemBuilder: (context, index) {
        final complaint = complaintsList[index];
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

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFFE3F2FD).withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.4), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showComplaintDetails(complaint),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF00A8E8).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(complaint.id, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(statusIcon, size: 13, color: statusColor),
                        SizedBox(width: 4),
                        Text(complaint.status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(complaint.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366)), maxLines: 2, overflow: TextOverflow.ellipsis),
              SizedBox(height: 8),
              Row(children: [
                Icon(Icons.category, size: 14, color: Color(0xFF00A8E8)),
                SizedBox(width: 4),
                Text(complaint.category, style: TextStyle(fontSize: 13, color: Color(0xFF0288D1))),
              ]),
              SizedBox(height: 4),
              Row(children: [
                Icon(Icons.calendar_today, size: 14, color: Color(0xFF00A8E8)),
                SizedBox(width: 4),
                Text(complaint.timestamp, style: TextStyle(fontSize: 13, color: Color(0xFF0288D1))),
              ]),
              SizedBox(height: 10),
              Text(complaint.description, style: TextStyle(fontSize: 13, color: Color(0xFF546E7A)), maxLines: 2, overflow: TextOverflow.ellipsis),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text("Tap for details", style: TextStyle(fontSize: 12, color: Color(0xFF00A8E8), fontWeight: FontWeight.w500)),
                Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF00A8E8)),
              ]),
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
      backgroundColor: Colors.transparent,
      builder: (context) {
        int _rating = 0; // State for bottom sheet
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.75,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Color(0xFF002952), // Elevated Navy Blue for overlap visual separation
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.4), width: 1.5),
                boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 16, offset: Offset(0, -4))],
              ),
              padding: EdgeInsets.all(24),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Header
                    Row(
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
                          child: Icon(Icons.description_outlined, color: Colors.white, size: 28),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(complaint.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
                              SizedBox(height: 4),
                              Text("ID: ${complaint.id}", style: TextStyle(fontSize: 13, color: Color(0xFF00A8E8), fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                            ],
                          ),
                        ),
                        // PDF Export Button
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF003366),
                            shape: BoxShape.circle,
                            border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.5)),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.picture_as_pdf, color: Color(0xFF00A8E8), size: 22),
                            onPressed: () {
                              _exportToPDF(complaint);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Divider(color: Colors.white12),
                    SizedBox(height: 16),

                    // Title & Data
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFF003366), // Solid Navy Blue matching feature cards
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.5), width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.category, size: 16, color: Color(0xFF00A8E8)),
                          SizedBox(width: 8),
                          Text(complaint.category, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                          SizedBox(width: 24),
                          Icon(Icons.calendar_today, size: 16, color: Color(0xFF00A8E8)),
                          SizedBox(width: 8),
                          Text(complaint.timestamp.length > 10 ? complaint.timestamp.substring(0, 10) : complaint.timestamp, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Description Box
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF003366),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.5), width: 1.5),
                      ),
                      child: Text(
                        complaint.description,
                        style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                      ),
                    ),
                    SizedBox(height: 32),

                    // Status Timeline
                    Text("Timeline", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 16),
                    _buildTimeline(complaint.status),

                    SizedBox(height: 32),

                    // Rating (Only if resolved)
                    if (complaint.status.toLowerCase() == 'resolved') ...[
                      Text("Rate Resolution", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 8),
                      Text("How satisfied are you with the solution?", style: TextStyle(color: Colors.white70, fontSize: 13)),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              color: index < _rating ? Colors.amber : Colors.white30,
                              size: 40,
                            ),
                            onPressed: () {
                              setModalState(() {
                                _rating = index + 1;
                              });
                            },
                          );
                        }),
                      ),
                      if (_rating > 0)
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Thanks for your feedback!"), backgroundColor: Colors.green));
                            },
                            child: Text("Submit Rating", style: TextStyle(color: Color(0xFF00A8E8), fontWeight: FontWeight.bold)),
                          ),
                        ),
                      SizedBox(height: 32),
                    ],

                    // Contact Support
                    Text("Need Help?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF003366),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () async {
                              final Uri url = Uri.parse('tel:1800123456');
                              if (await canLaunchUrl(url)) await launchUrl(url);
                            },
                            icon: Icon(Icons.call, size: 18),
                            label: Text("Call Support"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
      },
    );
  }

  Widget _buildTimeline(String currentStatus) {
    int currentStep = 0;
    String status = currentStatus.toLowerCase();
    
    if (status == 'submitted') currentStep = 0;
    if (status == 'in progress') currentStep = 1;
    if (status == 'resolved' || status == 'rejected') currentStep = 2;

    bool isRejected = status == 'rejected';

    return Column(
      children: [
        _buildTimelineStep("Submitted", "Issue reported successfully.", Icons.file_upload, isActive: currentStep >= 0, isLast: false),
        _buildTimelineStep("In Progress", "Authorities are reviewing and working on it.", Icons.build, isActive: currentStep >= 1, isLast: false),
        _buildTimelineStep(
          isRejected ? "Rejected" : "Resolved", 
          isRejected ? "Complaint was rejected. Contact support." : "Issue has been successfully resolved.", 
          isRejected ? Icons.cancel : Icons.check_circle, 
          isActive: currentStep >= 2, 
          isLast: true,
          isError: isRejected,
        ),
      ],
    );
  }

  Widget _buildTimelineStep(String title, String subtitle, IconData icon, {required bool isActive, required bool isLast, bool isError = false}) {
    Color activeColor = isError ? Colors.red : Color(0xFF00A8E8);
    Color inactiveColor = Colors.white24;
    Color color = isActive ? activeColor : inactiveColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isActive ? color.withOpacity(0.2) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isActive ? activeColor : inactiveColor,
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isActive ? Color(0xFF003366) : Color(0xFF003366).withOpacity(0.3), // Solid Navy Blue highlight for active timeline items
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isActive ? Color(0xFF00A8E8).withOpacity(0.5) : Colors.transparent, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.white54, fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.white54, fontSize: 13)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}