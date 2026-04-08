import 'package:flutter/material.dart';
import '../models/complaint.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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

  // Features state
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  
  late stt.SpeechToText _speech;
  bool _isListening = false;
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {},
        onError: (val) {},
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _descController.text = val.recognizedWords;
              description = val.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

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
      String photoUrl = ''; // Placeholder till actual Firebase Storage is connected
      if (_imageFile != null) {
        // Will be uploaded to Firebase Storage when configured
        photoUrl = _imageFile!.path;
      }

      Complaint complaint = Complaint(
        id: id,
        title: title,
        description: _descController.text.isNotEmpty ? _descController.text : description,
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
                    _imageFile = null;
                    _descController.clear();
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
      backgroundColor: Color(0xFF001F3F),
      appBar: AppBar(
        title: Text("Submit Complaint", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF001F3F),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFE3F2FD).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.4), width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 12, offset: Offset(0, 5))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Report an Issue", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF003366))),
                    SizedBox(height: 4),
                    Text("Fill the form below to submit your complaint", style: TextStyle(fontSize: 13, color: Color(0xFF0288D1))),
                    SizedBox(height: 20),
                    _navyInputField(label: "Complaint Title", onSaved: (v) => title = v!, validator: (v) => v!.isEmpty ? "Enter title" : null),
                    SizedBox(height: 14),
                    
                    // Voice Input aware Description
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _navyInputField(
                            label: "Description", 
                            maxLines: 3, 
                            controller: _descController,
                            onSaved: (v) => description = v ?? '', 
                            validator: (v) => v == null || v.isEmpty ? "Enter description" : null
                          ),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: _listen,
                          child: Container(
                            margin: EdgeInsets.only(top: 4),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _isListening ? Colors.red : Color(0xFF003366),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.white, size: 24),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14),
                    _navyInputField(label: "Location", prefixIcon: Icons.location_on, onSaved: (v) => location = v!, validator: (v) => v!.isEmpty ? "Enter location" : null),
                    SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: category,
                      dropdownColor: Colors.white,
                      style: TextStyle(color: Color(0xFF003366), fontWeight: FontWeight.w600),
                      items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (value) => setState(() => category = value!),
                      decoration: InputDecoration(
                        labelText: "Category",
                        labelStyle: TextStyle(color: Color(0xFF666666)),
                        filled: true,
                        fillColor: Color(0xFFF8F9FA),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Color(0xFFE0E0E0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Color(0xFFE0E0E0))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2)),
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // Photo Upload
                    Text("Evidence (Optional)", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Color(0xFF00A8E8).withOpacity(0.5), width: 1, style: BorderStyle.solid),
                        ),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: Image.file(_imageFile!, fit: BoxFit.cover, width: double.infinity),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt_outlined, color: Color(0xFF00A8E8), size: 36),
                                  SizedBox(height: 8),
                                  Text("Tap to upload photo", style: TextStyle(color: Color(0xFF0288D1), fontWeight: FontWeight.w600)),
                                ],
                              ),
                      ),
                    ),
                    if (_imageFile != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => setState(() => _imageFile = null),
                          icon: Icon(Icons.delete_outline, size: 16, color: Colors.red),
                          label: Text("Remove", style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF00A8E8),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: submitComplaint,
                        child: Text("Submit Complaint", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _navyInputDecoration({required String label, IconData? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF666666)),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Color(0xFF00A8E8)) : null,
      filled: true,
      fillColor: Color(0xFFF8F9FA),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Color(0xFFE0E0E0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Color(0xFFE0E0E0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Color(0xFF00A8E8), width: 2)),
    );
  }

  Widget _navyInputField({required String label, IconData? prefixIcon, int maxLines = 1, FormFieldSetter<String>? onSaved, FormFieldValidator<String>? validator, TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.w600),
      decoration: _navyInputDecoration(label: label, prefixIcon: prefixIcon),
      validator: validator,
      onSaved: onSaved,
    );
  }
}