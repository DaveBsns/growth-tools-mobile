import 'package:get/get.dart';
import 'package:idealize_new_version/Features/Base/base_viewmodel.dart';
import 'package:idealize_new_version/Features/create_new_project/data/repo/create_new_project_repo_impl.dart';
import 'package:idealize_new_version/Features/create_new_project/presentation/controller/create_new_project_controller.dart';
import 'package:idealize_new_version/Features/edit_profile/data/repo/edit_profile_repo_impl.dart';

import 'package:idealize_new_version/Features/profile/data/repo/profile_repo_impl.dart';
import 'package:idealize_new_version/Features/notification/data/repo/notification_repo_impl.dart';
import 'package:idealize_new_version/Features/notification/presentation/controller/notification_controller.dart';
import 'package:idealize_new_version/Features/home/data/repository/home_repository_impl.dart';
import 'package:idealize_new_version/Features/home/presentation/controller/home_controller.dart';
import 'package:idealize_new_version/Features/app_setting/data/repo/app_setting_repo_impl.dart';
import 'package:idealize_new_version/Features/app_setting/presentation/controller/app_setting_controller.dart';
import 'package:idealize_new_version/Features/archived_projcts/data/repo/archived_projcts_repo_impl.dart';
import 'package:idealize_new_version/Features/archived_projcts/presentation/controller/archived_projcts_controller.dart';

import '../../profile/presentation/controller/profile_controller.dart';

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BaseViewModel>(() => BaseViewModel());
    Get.lazyPut<HomeController>(
      () => HomeController(
        repo: HomeRepositoryImpl(),
      ),
    );

    Get.lazyPut<CreateNewProjectController>(() =>
        CreateNewProjectController(repo: CreateNewProjectRepositoryImpl()));

    Get.lazyPut<NotificationController>(
        () => NotificationController(repo: NotificationRepositoryImpl()));

    Get.lazyPut<ArchivedProjctsController>(
      () => ArchivedProjctsController(
        repo: ArchivedProjctsRepositoryImpl(),
        homeRepo: HomeRepositoryImpl(),
      ),
    );

    Get.lazyPut<AppSettingController>(
        () => AppSettingController(repo: AppSettingRepositoryImpl()));

    Get.lazyPut<ProfileController>(() => ProfileController(
          repo: ProfileRepositoryImpl(),
          editRepo: EditProfileRepositoryImpl(),
        ));
  }
}
