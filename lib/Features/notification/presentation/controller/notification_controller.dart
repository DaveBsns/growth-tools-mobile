import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Data/Models/notification_model.dart';
import 'package:idealize_new_version/Core/Data/Services/join_project.dart';
import 'package:idealize_new_version/Core/Utils/enums.dart';
import 'package:idealize_new_version/Features/home/presentation/controller/home_controller.dart';
import 'package:idealize_new_version/app_repo.dart';

import '../../domain/notification_repo.dart';

class NotificationController extends GetxController {
  late NotificationRepository repo;

  final joinProjectService = JoinProjectService();
  var notifications = <Notification>[].obs;

  NotificationController({
    required this.repo,
  });

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  Future<void> fetchNotifications() async {
    List<Notification> fetchedNotifications = await repo.fetchAll();
    notifications.clear();
    notifications.value = fetchedNotifications;
  }

  void back() {
    Get.back();
  }

  void clearNotifications() async {
    AppRepo().showLoading();
    final result = await repo.clear();
    if (result) {
      await fetchNotifications();
      notifications.refresh();
    }
    AppRepo().hideLoading();
  }

  void readNotifications(List<String> notificationsId) async {
    final result = await repo.read(notificationsId);
    if (result) {
      fetchNotifications();
      Get.find<HomeController>().getUnreadNotificationsCount();
    }
  }

  Future<void> responseToProjectRequest({
    required projectId,
    required notificationId,
    required RequestResponseType action,
    required String userId,
    required String requestType,
  }) async {
    await joinProjectService.responseToProjectRequest(
        projectId, notificationId, userId, action, requestType);

    // AppRepo().showSnackbar(
    //     label: "Response sent", text: "Response sent successfully");

    AppRepo().showLoading();
    await fetchNotifications();
    AppRepo().hideLoading();
  }
}
