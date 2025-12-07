import 'package:idealize_new_version/Core/Data/Models/project_model.dart';
import 'package:idealize_new_version/Core/Data/Models/recommendation_response_model.dart';
import 'package:idealize_new_version/Core/Data/Models/tag_model.dart';
import 'package:idealize_new_version/Core/Data/Services/archive_service.dart';
import 'package:idealize_new_version/Core/Data/Services/like_service.dart';
import 'package:idealize_new_version/Core/Data/Services/project_service.dart';
import 'package:idealize_new_version/Core/Data/Services/recommendation_service.dart';
import 'package:idealize_new_version/Features/home/domain/home_repository.dart';
import 'package:idealize_new_version/app_repo.dart';

import '../../../../Core/Data/Services/notification_service.dart';

class HomeRepositoryImpl extends HomeRepository {
  final projectService = ProjectService();
  final likeService = LikeService();
  final archiveService = ArchiveService();
  final recommendationService = RecommendationService();

  @override
  Future<String?> archive({
    required String projectId,
    required String projectOwnerId,
  }) async =>
      await archiveService.archiveProject(
        projectId,
        AppRepo().user!.id,
        projectOwnerId,
      );

  @override
  Future<bool> unarchive({required String archiveId}) async =>
      await archiveService.unarchiveProject(archiveId);

  @override
  Future<List<Project>> fetchAll({
    String? searchInput,
    String selectedSegment = 'all-projects',
    int page = 1,
    Tag? filteredByTag,
    String recommendationType = 'basic',
  }) async {
    // Fetch "For You" recommendations using the selected recommendation type
    if (selectedSegment == 'for-you') {
      if (AppRepo().user?.id == null) return [];

      // Fetch recommendations based on selected type
      final RecommendationResponse? response;
      switch (recommendationType) {
        case 'for-you':
          // Content-based filtering
          response = await recommendationService.fetchForYouRecommendations(
            userId: AppRepo().user!.id,
            page: page,
            limit: 10,
          );
          break;
        case 'hybrid':
          // Hybrid: Content-based + Popularity
          response = await recommendationService.fetchHybridRecommendations(
            userId: AppRepo().user!.id,
            page: page,
            limit: 10,
          );
          break;
        case 'basic':
        default:
          // Basic filtering (default)
          response = await recommendationService.fetchBasicRecommendations(
            userId: AppRepo().user!.id,
            page: page,
            limit: 10,
          );
          break;
      }

      // Store pagination info in controller for later use
      _lastRecommendationResponse = response;

      // Filter out user's own projects as a safety measure
      // (backend should already do this, but we add it as a safeguard)
      final recommendedProjects = response?.projects ?? [];
      var filteredProjects = recommendedProjects
          .where((project) => project.owner?.id != AppRepo().user?.id)
          .toList();

      // Apply search filter if provided
      if (searchInput != null && searchInput.isNotEmpty) {
        final searchLower = searchInput.toLowerCase();
        filteredProjects = filteredProjects
            .where((project) =>
                project.title.toLowerCase().contains(searchLower) ||
                project.description.toLowerCase().contains(searchLower))
            .toList();
      }

      return filteredProjects;
    }

    // Otherwise, fetch projects normally
    return await projectService.fetchAllProject(
      search: searchInput,
      page: page,
      sortField: 'creationDate',
      filter: selectedSegment,
      filterByTag: filteredByTag?.id,
      joinedProjects: false,
    );
  }

  /// Store the last recommendation response to check hasMore status
  RecommendationResponse? _lastRecommendationResponse;

  /// Get the hasMore status from the last recommendation response
  bool get hasMoreRecommendations =>
      _lastRecommendationResponse?.hasMore ?? false;

  @override
  Future<int> unreadNotifications() async {
    return await NotificationService().getCountOfUnreadNotifications();
  }

  @override
  Future<bool> like(
      {required String projectId, required String ownerId}) async {
    return await likeService.likeProject(
        projectId, AppRepo().user!.id, ownerId);
  }

  @override
  Future<bool> unlike({required String projectId}) async {
    return await likeService.unlikeProject(projectId);
  }
}
