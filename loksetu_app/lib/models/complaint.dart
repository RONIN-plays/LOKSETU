class Complaint {
  final String id;
  final String title;
  final String description;
  final String category;
  final String timestamp;
  String status;

  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.timestamp,
    this.status = 'Submitted',
  });
}