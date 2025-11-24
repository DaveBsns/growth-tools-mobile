import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Components/empty_state_guidance_widget.dart';
import 'package:idealize_new_version/Core/Components/go_to_top_widget.dart';
import 'package:idealize_new_version/Core/Components/loading_widget.dart';
import 'package:idealize_new_version/Core/Components/project_cards_widget.dart';
import 'package:idealize_new_version/Core/Constants/colors.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Features/home/presentation/controller/home_controller.dart';
import 'package:idealize_new_version/app_repo.dart';

class HomeMainListWidget extends GetView<HomeController> {
  const HomeMainListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: controller,
      initState: (_) => controller.init(),
      builder: (_) => Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // TODO change style of the card when there is no internet connection
            Expanded(
              child: Stack(
                children: [
                  if (controller.searchedProjects.isEmpty &&
                      !controller.loading)
                    EmptyStateGuidanceWidget(
                      onRefresh: controller.refreshContent,
                      customGuidanceMessage:
                          controller.selectedFilter == 'for-you'
                              ? AppStrings.addInterestsToGetRecommendations.tr
                              : null,
                      emptyStateLabel: AppStrings.emptyList.tr,
                    ),
                  if (controller.searchedProjects.isNotEmpty)
                    RefreshIndicator(
                      color: AppConfig().colors.primaryColor,
                      onRefresh: controller.refreshContent,
                      child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: controller.scrollController,
                          itemCount: controller.searchedProjects.length + 1,
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: AppConfig().dimens.medium),
                          itemBuilder: (context, index) {
                            if (index == controller.searchedProjects.length) {
                              if (controller.searchedProjects.length > 5) {
                                return GoToTopWidget(onTapped: () {
                                  controller.scrollController.animateTo(
                                    0.0,
                                    curve: Curves.easeIn,
                                    duration: const Duration(milliseconds: 300),
                                  );
                                });
                              } else {
                                return const SizedBox.shrink();
                              }
                            } else {
                              final loadingObject = AppRepo()
                                  .updatingProjectsList
                                  .where((element) =>
                                      element ==
                                      controller.searchedProjects[index].id
                                          .toString())
                                  .toList();

                              Widget listItem = ProjectCardHomeWidget(
                                key: Key(
                                    'project_${controller.searchedProjects[index].id}'),
                                project: controller.searchedProjects[index],
                                isLoading: loadingObject.isNotEmpty,
                                onTapOpenProject: () =>
                                    controller.routeToProject(
                                  controller.searchedProjects[index],
                                ),
                                onTapCommentToOpenProject: () {
                                  controller.routeToProject(
                                    controller.searchedProjects[index],
                                    scrollToComments: true,
                                  );
                                },
                                onTapLikeProject: () {
                                  controller.toggleLike(
                                    controller.searchedProjects[index],
                                  );
                                },
                                toggleFavorite: controller.toggleArchive,
                              );

                              return listItem;
                            }
                          }),
                    ),
                  if (controller.loading) const CustomLoadingIndicator(),
                  StreamBuilder(
                    stream: AppRepo().networkConnectivityStream.stream,
                    builder: (context, snapshot) =>
                        !AppRepo().networkConnectivity
                            ? Center(
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors().backGroundColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${AppStrings.connectionProblem.tr} ...',
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
