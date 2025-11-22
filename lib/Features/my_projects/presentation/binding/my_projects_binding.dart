import 'package:get/get.dart';
import 'package:idealize_new_version/Features/home/data/repository/home_repository_impl.dart';

import '../../data/repo/my_projects_repo_impl.dart';
import '../controller/my_projects_controller.dart';

class MyProjectsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyProjectsController>(
      () => MyProjectsController(
        repo: MyProjectsRepositoryImpl(),
        homeRepo: HomeRepositoryImpl(),
      ),
    );
  }
}

