import 'package:idealize_new_version/Core/Data/Models/project_model.dart';
import 'package:idealize_new_version/Core/Data/Models/tag_model.dart';

abstract class HomeRepository {
  Future<List<Project>> fetchAll({
    String? searchInput,
    String selectedSegment = 'all-projects',
    int page = 1,
    Tag? filteredByTag,
    String recommendationType = 'basic',
  });
  Future<String?> archive({
    required String projectId,
    required String projectOwnerId,
  });
  Future<bool> unarchive({required String archiveId});
  Future<int> unreadNotifications();
  Future<bool> like({required String projectId, required String ownerId});
  Future<bool> unlike({required String projectId});
}
