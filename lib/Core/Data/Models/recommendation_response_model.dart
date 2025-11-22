import 'package:idealize_new_version/Core/Data/Models/project_model.dart';

class RecommendationResponse {
  final List<Project> projects;
  final int total;
  final String algorithm;
  final String? emptyStateReason;
  final String? emptyStateMessage;

  RecommendationResponse({
    required this.projects,
    required this.total,
    required this.algorithm,
    this.emptyStateReason,
    this.emptyStateMessage,
  });

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationResponse(
      projects: (json['projects'] != null && json['projects'] is List)
          ? (json['projects'] as List)
              .map((projectJson) => Project.fromJson(projectJson))
              .toList()
          : [],
      total: json['total'] ?? 0,
      algorithm: json['algorithm'] ?? 'content-based',
      emptyStateReason: json['emptyStateReason'] as String?,
      emptyStateMessage: json['emptyStateMessage'] as String?,
    );
  }
}
