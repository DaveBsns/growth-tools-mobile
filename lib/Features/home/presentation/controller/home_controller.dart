import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/Data/Models/project_model.dart';
import 'package:idealize_new_version/Core/Data/Models/tag_model.dart';
import 'package:idealize_new_version/Features/home/domain/home_repository.dart';
import 'package:idealize_new_version/app_repo.dart';

class HomeController extends GetxController {
  late HomeRepository repo;

  HomeController({
    required this.repo,
  });

  bool loading = false;
  List<Project> searchedProjects = [];
  String selectedFilter = 'all-projects';
  ScrollController scrollController = ScrollController();
  RxBool isSearchFieldEmpty = true.obs;
  TextEditingController searchInputController = TextEditingController();

  int hasNewNotfications = 0;

  int page = 1;
  bool lastPage = false;
  String searchInput = '';
  List<Project> projects = [];
  Set<String> _loadedProjectIds = {};

  Rx<Tag?> filteredByTag = Rx<Tag?>(null);
  Project? filteredByTagProject;

  /// Currently selected recommendation type for "For You" segment
  /// Options: 'basic', 'content-based', 'collaborative', 'hybrid'
  RxString selectedRecommendationType = 'content-based'.obs;

  @override
  void onInit() {
    getUnreadNotificationsCount();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(() {
        _lazyLoad();
      });
    });
    super.onInit();
  }

  Future<void> _fetchAllTheProjects({bool currentPage = false}) async {
    getUnreadNotificationsCount();
    if (loading || lastPage) return;

    loading = true;
    update();

    final result = await repo.fetchAll(
      page: page,
      searchInput: searchInput,
      selectedSegment: selectedFilter,
      filteredByTag:
          selectedFilter == 'all-projects' ? filteredByTag.value : null,
      recommendationType: selectedRecommendationType.value,
    );

    if (page == 1) {
      searchedProjects.clear();
      _loadedProjectIds.clear();
    }

    // For "for-you" segment, use hasMore from backend if available
    if (selectedFilter == 'for-you') {
      final homeRepo = repo as dynamic;
      final hasMore = homeRepo.hasMoreRecommendations ?? true;

      searchedProjects.addAll(result);

      if (!currentPage) {
        if (!hasMore || result.isEmpty) {
          lastPage = true;
        } else {
          _pageIncreament();
        }
      }
    } else {
      // For other segments, use duplicate detection as fallback
      final newProjects = result
          .where((project) => !_loadedProjectIds.contains(project.id))
          .toList();

      // If all results are duplicates, backend is returning same page again
      if (result.isNotEmpty && newProjects.isEmpty) {
        lastPage = true;
        loading = false;
        update();
        return;
      }

      // Track loaded project IDs
      for (var project in newProjects) {
        _loadedProjectIds.add(project.id);
      }

      searchedProjects.addAll(newProjects);

      if (!currentPage) {
        if (newProjects.isNotEmpty) {
          _pageIncreament();
        } else {
          lastPage = true;
        }
      }
    }

    loading = false;
    update();
  }

  void updateFilteredByTag(Tag? tag, Project? project) {
    filteredByTag.value = tag;
    filteredByTagProject = project;
    update();
    refreshContent();
  }

  void toggleLike(Project project) async {
    AppRepo().showLoading();

    if (project.isLiked) {
      await repo.unlike(projectId: project.id);
    } else {
      await repo.like(projectId: project.id, ownerId: project.owner!.id);
    }
    AppRepo().hideLoading();

    await refreshContent(currentPage: true);
  }

  void search() {
    FocusManager.instance.primaryFocus?.unfocus();
    searchInput =
        searchInputController.text; // Capture search input from text field
    _resetPage();
    _fetchAllTheProjects();
  }

  Future<void> refreshContent({bool currentPage = false}) async {
    _resetPage();
    await _fetchAllTheProjects(currentPage: currentPage);
  }

  Future<void> init() async {
    await _fetchAllTheProjects();
  }

  void updateSegmentValue(Set<String> indexes) {
    selectedFilter = indexes.first;
    update();
    refreshContent();
  }

  /// Updates the recommendation type for "For You" segment
  /// and refreshes the content
  void updateRecommendationType(String type) {
    selectedRecommendationType.value = type;
    refreshContent();
  }

  void _resetPage() {
    page = 1;
    lastPage = false;
    _loadedProjectIds.clear(); // Clear loaded IDs when resetting
  }

  void _pageIncreament() => page++;

  void _lazyLoad() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      _fetchAllTheProjects();
    }
  }

  void routeToProject(Project project, {bool scrollToComments = false}) {
    Get.toNamed(
      AppConfig().routes.projectDetails,
      arguments: project.id,
      parameters: {
        'scroll-to-comments': '$scrollToComments',
      },
    );
  }

  Future<void> toggleArchive(bool archive, Project project) async {
    if (!archive && project.archiveId != null) {
      final result = await repo.unarchive(archiveId: project.archiveId!);
      if (result) {
        updateProjectArchiveInList(project, archive: false, archiveId: null);
      }
    } else {
      final archiveId = await repo.archive(
        projectId: project.id,
        projectOwnerId: project.owner!.id,
      );
      if (archiveId != null) {
        updateProjectArchiveInList(project,
            archive: true, archiveId: archiveId);
      }
    }

    await refreshContent(currentPage: true);
  }

  void updateProjectArchiveInList(
    Project project, {
    required bool archive,
    required String? archiveId,
  }) {
    final index =
        searchedProjects.indexWhere((element) => element.id == project.id);
    searchedProjects[index].archiveId = archiveId;
    searchedProjects[index].isArchived = archive;

    update();
  }

  void getUnreadNotificationsCount() async {
    hasNewNotfications = await repo.unreadNotifications();
    update();
  }
}
