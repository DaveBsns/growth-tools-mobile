import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Constants/colors.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/Data/Models/custom_x_file_model.dart';
import 'package:idealize_new_version/Core/Data/Models/project_comment_model.dart';
import 'package:idealize_new_version/Core/Data/Models/project_model.dart';
// import 'package:idealize_new_version/Core/Data/Services/archive_service.dart';
// import 'package:idealize_new_version/Core/Data/Services/comment_service.dart';
// import 'package:idealize_new_version/Core/Data/Services/join_project.dart';
// import 'package:idealize_new_version/Core/Data/Services/like_service.dart';
// import 'package:idealize_new_version/Core/Data/Services/project_service.dart';
// import 'package:idealize_new_version/Core/Data/Services/report_service.dart';
import 'package:idealize_new_version/Features/home/presentation/controller/home_controller.dart';
import 'package:idealize_new_version/app_repo.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/project_details_repo.dart';
import 'dart:async';
import 'package:idealize_new_version/Core/I18n/messages.dart';

class ProjectDetailsController extends GetxController {
  late ProjectDetailsRepository repo;
  late String projectId;
  late bool scrolableToComments;

  Project? project;

  final homeViewModel = Get.find<HomeController>();
  final commentCtrl = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final GlobalKey commentsKey = GlobalKey();

  final TextEditingController joinReqMsgController = TextEditingController();

  final RxBool isLiked = false.obs;
  final RxBool isArchived = false.obs;
  final RxBool isCommentEmpty = true.obs;

  RxInt tabIndex = 0.obs;
  Rx<String?> archiveId = Rx(null);
  RxInt isLikedValue = 0.obs;
  RxString replyCommentId = ''.obs;
  RxList<ProjectComment> comments = RxList([]);
  List<ProjectLikes> likes = [];
  bool isLoadingLikes = false;

  int currentCommentsPage = 1;
  RxString joinedStatus = RxString('');
  FocusNode myFocusNode = FocusNode();

  ProjectDetailsController({
    required this.repo,
  });

  @override
  void onInit() {
    super.onInit();
    projectId = Get.arguments;
    scrolableToComments = Get.parameters['scroll-to-comments'] == 'true';
    // getProject();
  }

  Future<Project> getProjectAfterInit() async {
    final result = await repo.projectDetails(projectId);
    project = result;

    joinedStatus.value = project!.joinedStatus ?? '';
    isLiked.value = project!.isLiked;
    isArchived.value = project!.isArchived ?? false;
    archiveId.value = project!.archiveId;

    refresh();
    update();

    return result;
  }

  Future<Project> getProject() async {
    final result = await repo.projectDetails(projectId);
    project = result;

    await initComments();
    await initLikes();
    joinedStatus.value = project!.joinedStatus ?? '';
    isLiked.value = project!.isLiked;
    isArchived.value = project!.isArchived ?? false;
    archiveId.value = project!.archiveId;
    commentCtrl.addListener(() {
      isCommentEmpty.value = commentCtrl.text.trim().isEmpty;

      // Show warning when user reaches 300 characters
      if (commentCtrl.text.length == 300) {
        AppRepo().showSnackbar(
          label: AppStrings.warning.tr,
          text: AppStrings.commentTooLong.tr,
        );
      }
    });

    if (scrolableToComments) {
      scrollToComments();
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refresh();
      update();
    });

    return result;
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  Future<void> toggleLike(String userId) async {
    if (isLiked.value) {
      await repo.unlike(project!.id);
      isLikedValue.value -= 1;
      homeViewModel.refreshContent();
    } else {
      await repo.like(project!.id, project!.owner!.id, userId);
      isLikedValue.value += 1;
      homeViewModel.refreshContent();
    }

    isLiked.toggle();
  }

  Future<void> comment() async {
    final trimmedComment = commentCtrl.text.trim();

    // Validate minimum length (2 characters)
    if (trimmedComment.length < 2) {
      AppRepo().showSnackbar(
        label: AppStrings.warning.tr,
        text: AppStrings.commentTooShort.tr,
      );
      return;
    }

    // Validate maximum length (300 characters)
    if (trimmedComment.length > 300) {
      AppRepo().showSnackbar(
        label: AppStrings.warning.tr,
        text: AppStrings.commentTooLong.tr,
      );
      return;
    }

    if (trimmedComment.isNotEmpty) {
      final status = await repo.leaveComment(
        project!.id,
        AppRepo().user!.id,
        content: trimmedComment,
        parentCommentId:
            replyCommentId.value.isNotEmpty ? replyCommentId.value : null,
        projectOwnerId: project!.owner!.id,
      );

      if (status) {
        initComments();
        removeReply();
        commentCtrl.clear();

        Get.find<HomeController>().refreshContent(currentPage: true);
      }
    }
  }

  Future<void> initComments() async {
    final commentsFromServer = await repo.comments(project!.id);
    comments.clear();
    comments.addAll(commentsFromServer);
  }

  Future<void> initLikes() async {
    if (isLoadingLikes) {
      return;
    }

    isLoadingLikes = true;
    likes.clear();
    likes.addAll(await repo.likes(project!.id));

    refresh();
    update();

    isLoadingLikes = false;
  }

  // TODO asign it to UI widget
  void loadMoreComment() async {
    final commentsFromServer =
        await repo.comments(project!.id, page: currentCommentsPage + 1);
    if (commentsFromServer.isNotEmpty) {
      currentCommentsPage++;
      comments.clear();
      comments.addAll(commentsFromServer);
    }
  }

  void reply(String replyId) {
    replyCommentId.value = replyId;
    FocusScope.of(Get.context!).requestFocus(myFocusNode);
    scrollToComments();
  }

  void reportComment(
    String commentId, {
    required String reportedUser,
    required String comment,
    required String reason,
  }) async {
    AppRepo().showLoading();
    await repo.report(
      projectId,
      reportedUser,
      type: 'comment',
      content: 'On comment ($commentId): $comment,\n\nReason: $reason',
    );
    AppRepo().hideLoading();
    Get.back();
    AppRepo().showSnackbar(
      label: AppStrings.reportedSuccessTitle.tr,
      text: AppStrings.reportedSuccessDesc.tr,
    );
  }

  void removeComment(String commentId) async {
    AppRepo().showCustomAlertDialog(
      title: AppStrings.deleteCommentTitle.tr,
      content: AppStrings.deleteCommentContent.tr,
      buttonText: AppStrings.delete.tr,
      outlinedButtonText: AppStrings.cancel.tr,
      buttonColor: AppConfig().colors.secondaryColor,
      outlinedButtonColor: Colors.transparent,
      outlinedButtonBorderColor: AppConfig().colors.darkGrayColor,
      outlinedButtonTextStyle: TextStyle(
        color: AppConfig().colors.darkGrayColor,
      ),
      buttonTextStyle: const TextStyle(color: Colors.white),
      onPressed: () async {
        Get.back();
        AppRepo().showLoading();
        await repo.deleteComment(commentId);
        initComments();
        AppRepo().hideLoading();
        Get.find<HomeController>().refreshContent(currentPage: true);
      },
      outlinedButtonOnPressed: () => Get.back(),
    );
  }

  String getNameBasedOnReplyId(String replyId) {
    for (var comment in comments) {
      if (comment.id == replyId) {
        return comment.user.firstname;
      }

      for (var reply in comment.replies.$2) {
        if (reply.id == replyId) {
          return reply.user.firstname;
        }
      }
    }

    return 'Unknown';
  }

  String getCommentBasedOnReplyId(String replyId) {
    for (var comment in comments) {
      if (comment.id == replyId) {
        return comment.content;
      }

      for (var reply in comment.replies.$2) {
        if (reply.id == replyId) {
          return reply.content;
        }
      }
    }

    return '...';
  }

  void scrollToComments() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  void removeReply() {
    replyCommentId.value = '';
  }

  // Future<void> downloadProjectFile(CustomXFile file) async {
  //   AppRepo().showLoading();

  //   String url = '${AppConfig().baseFileUrl}/uploads/${file.name}';

  //   String filename = file.name;

  //   try {
  //     // Get the document directory for iOS and Android
  //     Directory docDir = await getApplicationDocumentsDirectory();

  //     // Create a new directory in the application documents directory
  //     Directory dir = Directory('${docDir.path}/Media/');

  //     // Create the directory if it doesn't exist
  //     if (!await dir.exists()) {
  //       await dir.create(recursive: true);
  //     }

  //     // Download the file

  //     var response = await http.get(Uri.parse(url));

  //     // Write the response body to a file
  //     var file = File('${dir.path}/$filename');
  //     await file.writeAsBytes(
  //       response.bodyBytes,
  //     );
  //   } catch (e) {
  //     AppRepo().hideLoading();

  //     AppRepo().showSnackbar(
  //       label: AppStrings.error.tr,
  //       text: AppStrings.downloadError.tr,
  //       backgroundColor: AppColors().primaryColor,
  //       position: SnackPosition.BOTTOM,
  //     );
  //   } finally {
  //     AppRepo().hideLoading();

  //     AppRepo().showSnackbar(
  //       label: AppStrings.downloadComplete.tr,
  //       text: AppStrings.mediaStoredPlace.tr,
  //       backgroundColor: AppColors().primaryColor,
  //       position: SnackPosition.BOTTOM,
  //       duration: const Duration(seconds: 5),
  //     );
  //   }
  // }

  Future<void> downloadProjectFile(CustomXFile file) async {
    AppRepo().showLoading();

    String url =
        '${AppConfig().baseFileUrl}/uploads/resource/${file.uploadedId}';
    String filename = file.name;

    try {
      Directory? dir = Platform.isAndroid
          ? Directory('/storage/emulated/0/Download')
          : await getApplicationDocumentsDirectory();

      // if (dir == null) throw Exception(AppStrings.storageAccessFailed.tr);

      final downloadDir = Directory(
          '${dir.path}/materials/${project?.title.replaceAll(' ', '_')}');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      String filePath = '${downloadDir.path}/$filename';

      await Dio().download(url, filePath);
      AppRepo().hideLoading();

      final openResult = await OpenFilex.open(filePath);
      if (openResult.type != ResultType.done) {
        AppRepo().showSnackbar(
          label: AppStrings.error.tr,
          text: AppStrings.couldNotOpenDownloadedFile.tr,
        );
      }
    } catch (e) {
      AppRepo().showSnackbar(
        label: AppStrings.downloadFailed.tr,
        text: '${AppStrings.error.tr}: ${e.toString()}',
      );
    } finally {
      AppRepo().hideLoading();
    }
  }

  Future<void> toggleArchive(String projectId, String projectOwnerId) async {
    if (!isArchived.value) {
      final result =
          await repo.archive(projectId, AppRepo().user!.id, projectOwnerId);
      if (result != null) {
        archiveId.value = result;
        isArchived.value = true;
        homeViewModel.updateProjectArchiveInList(project!,
            archive: true, archiveId: result);
      }
    } else {
      if (archiveId.value == null || archiveId.value!.isEmpty) {
        return;
      }

      final result = await repo.unarchive(archiveId.value!);
      if (result) {
        archiveId.value = null;
        isArchived.value = false;
        homeViewModel.updateProjectArchiveInList(project!,
            archive: false, archiveId: null);
      }
    }
  }

  Future<void> joinProject() async {
    if (project!.owner != null) {
      AppRepo().showLoading();
      final joinReqMessage = joinReqMsgController.text;
      final result = await repo.join(
        project!.id,
        project!.owner!.id,
        message: joinReqMessage,
      );
      AppRepo().hideLoading();
      Get.back(closeOverlays: true);
      if (result != null) {
        await getProjectAfterInit();
        AppRepo().showSnackbar(
          label: AppStrings.requestSent.tr,
          text: AppStrings.requestSent.tr,
          backgroundColor: AppColors().primaryColor,
          position: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
        );
      }
    } else {
      AppRepo().showSnackbar(
        label: AppStrings.error.tr,
        text: AppStrings.ownerNotAvailable.tr,
        backgroundColor: AppColors().primaryColor,
        position: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    }
  }

  void reportProject(String content) async {
    if (content.isEmpty) {
      return AppRepo().showSnackbar(label: "label", text: "text");
    }
    AppRepo().showLoading();

    final response = await repo.report(
      projectId,
      project!.owner!.id,
      type: 'project',
      content: content,
    );
    AppRepo().hideLoading();
    Get.back();
    if (response != null) {
      await getProjectAfterInit();
      AppRepo().showSnackbar(
        label: 'Success',
        text: AppStrings.projectReported.tr,
      );
    }
  }
}
