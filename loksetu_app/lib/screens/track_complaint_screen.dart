import 'package:flutter/material.dart';
import '../data/complaint_data.dart';
import '../models/complaint.dart';

class TrackComplaintScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Complaints'),
        backgroundColor: Color(0xFF6A11CB),
      ),
      body: complaints.isEmpty
          ? Center(
              child: Text(
                'No complaints submitted yet.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                Complaint complaint = complaints[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('ID: ${complaint.id}'),
                    subtitle: Text(
                      'Category: ${complaint.category}\nDescription: ${complaint.description}\nStatus: ${complaint.status}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}