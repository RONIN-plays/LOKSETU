class Complaint {
  final String id;
  final String title;
  final String description;
  final String category;
  final String timestamp;
  String status;
  final String? submittedBy;

  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.timestamp,
    this.status = 'Submitted',
    this.submittedBy,
  });

  factory Complaint.fromJson(Map<String, dynamic> json, String docId) {
    return Complaint(
      id: docId,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      timestamp: json['timestamp'] ?? '',
      status: json['status'] ?? 'Submitted',
      submittedBy: json['submittedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'timestamp': timestamp,
      'status': status,
      'submittedBy': submittedBy,
    };
  }
}