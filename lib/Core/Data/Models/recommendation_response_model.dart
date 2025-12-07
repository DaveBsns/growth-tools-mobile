import 'package:idealize_new_version/Core/Data/Models/project_model.dart';

class RecommendationResponse {
  final List<Project> projects;
  final int total;
  final String algorithm;
  final String? emptyStateReason;
  final String? emptyStateMessage;
  final bool hasMore;
  final int? page;
  final int? limit;

  RecommendationResponse({
    required this.projects,
    required this.total,
    required this.algorithm,
    this.emptyStateReason,
    this.emptyStateMessage,
    this.hasMore = false,
    this.page,
    this.limit,
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
      hasMore: json['hasMore'] ?? false,
      page: json['page'] as int?,
      limit: json['limit'] as int?,
    );
  }
}
