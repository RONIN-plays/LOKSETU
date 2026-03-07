import 'package:flutter/material.dart';
import '../models/complaint.dart';
import '../data/complaint_data.dart';
import 'dart:math';

class ReportIssueScreen extends StatefulWidget {
  @override
  _ReportIssueScreenState createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {

  String category = "Water";
  TextEditingController descriptionController = TextEditingController();

  List<String> categories = [
    "Water",
    "Road",
    "Sanitation",
    "Electricity",
    "Health"
  ];

  String generateComplaintID() {
    Random random = Random();
    return "LS-${random.nextInt(99999)}";
  }

  void submitComplaint() {

    String id = generateComplaintID();

    Complaint newComplaint = Complaint(
      id: id,
      category: category,
      description: descriptionController.text,
      status: "Submitted",
    );

    complaints.add(newComplaint);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Complaint Submitted: $id"))
    );

    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Report Issue"),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),

        child: Column(

          children: [

            DropdownButtonFormField(
              value: category,
              items: categories.map((item) {

                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );

              }).toList(),

              onChanged: (value) {
                setState(() {
                  category = value.toString();
                });
              },

              decoration: InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Describe the issue",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: submitComplaint,
              child: Text("Submit Complaint"),
            )

          ],
        ),
      ),
    );
  }
}