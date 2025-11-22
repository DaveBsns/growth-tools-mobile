import 'package:idealize_new_version/Core/Data/Models/project_model.dart';
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
  }) async {
    // Fetch "For You" recommendations using content-based filtering
    if (selectedSegment == 'for-you') {
      if (AppRepo().user?.id == null) return [];

      // Fetch "For You" recommendations using content-based filtering
      final response = await recommendationService.fetchForYouRecommendations(
        userId: AppRepo().user!.id,
        page: page,
        limit: 10,
      );

      // Filter out user's own projects as a safety measure
      // (backend should already do this, but we add it as a safeguard)
      final recommendedProjects = response?.projects ?? [];
      final filteredProjects = recommendedProjects
          .where((project) => project.owner?.id != AppRepo().user?.id)
          .toList();

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
