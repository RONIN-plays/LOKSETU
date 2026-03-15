import 'package:flutter/material.dart';
import '../models/complaint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ReportIssueScreen extends StatefulWidget {
  @override
  _ReportIssueScreenState createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String title = '';
  String description = '';
  String location = ''; // New field
  String category = 'Water';
  List<String> categories = [
    'Water',
    'Road',
    'Sanitation',
    'Electricity',
    'Other',
  ];

  Future<void> submitComplaint() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // Check internet connection
    var connectivityResults = await (Connectivity().checkConnectivity());
    bool isOffline = connectivityResults.contains(ConnectivityResult.none);

    if (isOffline) {
      // Offline Flow: Send via SMS
      final Uri smsLaunchUri = Uri(
        scheme: 'sms',
        path: '+918274819946', // Admin Phone Number
        queryParameters: <String, String>{
          'body': 'LokSetu Emergency Report\nCategory: $category\nTitle: $title\nLocation: $location\nDescription: $description'
        },
      );

      if (await canLaunchUrl(smsLaunchUri)) {
        await launchUrl(smsLaunchUri);
        
        // Show offline success popup
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Row(
                children: [
                  Icon(Icons.signal_cellular_connected_no_internet_4_bar, color: Colors.orange, size: 28),
                  SizedBox(width: 10),
                  Text("Offline Mode", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                ],
              ),
              content: Text("No internet connection detected.\n\nYou have been redirected to your SMS app to submit this complaint via your cellular network."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK", style: TextStyle(color: Color(0xFF6A11CB))),
                ),
              ],
            );
          },
        );
        
        _formKey.currentState!.reset();
        setState(() {
          category = 'Water';
        });
      } else {
        // Show offline failure popup
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Row(
                children: [
                  Icon(Icons.error, color: Colors.red, size: 28),
                  SizedBox(width: 10),
                  Text("Error", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
              content: Text("Could not open your SMS app to send the complaint fallback."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK", style: TextStyle(color: Color(0xFF6A11CB))),
                ),
              ],
            );
          },
        );
      }
      return; // Stop execution of online flow
    }

    // Online Flow: Save to Firestore
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String id = 'LS${timestamp.substring(timestamp.length - 4)}';

      Complaint complaint = Complaint(
        id: id,
        title: title,
        description: description,
        category: category,
        timestamp: DateTime.now().toString(),
        submittedBy: FirebaseAuth.instance.currentUser?.email ?? 'Anonymous',
        location: location,
      );

      await FirebaseFirestore.instance.collection('complaints').doc(id).set(complaint.toJson());

      Navigator.pop(context); // Close loading dialog

      // Show success dialog with complaint ID
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 30),
                SizedBox(width: 10),
                Text(
                  "Complaint Submitted",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Text(
                  "Your complaint has been successfully submitted!",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF6A11CB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFF6A11CB), width: 2),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.receipt_long, color: Color(0xFF6A11CB)),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Complaint ID",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            id,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6A11CB),
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "You can track the status using this ID",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6A11CB),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _formKey.currentState!.reset();
                  setState(() {
                    category = 'Water';
                  });
                },
                child: Text(
                  "OK",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting complaint: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit Complaint"),
        backgroundColor: Color(0xFF6A11CB),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Complaint Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter title" : null,
                onSaved: (value) => title = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter description" : null,
                onSaved: (value) => description = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Location",
                  hintText: "e.g. Near Central Park",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter location" : null,
                onSaved: (value) => location = value!,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: category,
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) => setState(() => category = value!),
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A11CB),
                  ),
                  onPressed: submitComplaint,
                  child: Text(
                    "Submit Complaint",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}