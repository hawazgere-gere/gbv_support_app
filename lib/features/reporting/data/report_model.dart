/* 
 * Top Comment: Enhanced Report Model supporting multi-modal evidence 
 * (images + location) and structured JSON serialization for ETL pipelines.
 */
class ReportModel {
  final String id;
  final String type; // e.g., Physical, Verbal, Economic
  final String details;
  final String? imagePath; // Local path to compressed evidence
  final String? location; // GPS coordinates
  final DateTime dateTime;
  final bool isDraft; // Useful for "Quick Save" features

  ReportModel({
    required this.id,
    required this.type,
    required this.details,
    this.imagePath,
    this.location,
    required this.dateTime,
    this.isDraft = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'details': details,
        'imagePath': imagePath,
        'location': location,
        'dateTime': dateTime.toIso8601String(),
        'isDraft': isDraft ? 1 : 0, // Store as Int for SQLite compatibility
      };

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        id: json['id'],
        type: json['type'],
        details: json['details'],
        imagePath: json['imagePath'],
        location: json['location'],
        dateTime: DateTime.parse(json['dateTime']),
        isDraft: json['isDraft'] == 1,
      );
}
