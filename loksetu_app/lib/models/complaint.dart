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
}