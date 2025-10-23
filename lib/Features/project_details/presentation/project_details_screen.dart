import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Components/buttons_widget.dart';
import 'package:idealize_new_version/Core/Components/image_loader_widget.dart';
import 'package:idealize_new_version/Core/Components/loading_widget.dart';
import 'package:idealize_new_version/Core/Components/tabbar_widget.dart';
import 'package:idealize_new_version/Core/Components/textfields_widget.dart';
import 'package:idealize_new_version/Core/Constants/colors.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/Constants/icons.dart';
import 'package:idealize_new_version/Core/Data/Models/custom_x_file_model.dart';
import 'package:idealize_new_version/Core/Data/Models/project_model.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Core/Utils/extensions.dart';
import 'package:idealize_new_version/Core/Utils/file_utils.dart';
import 'package:idealize_new_version/Features/project_details/presentation/widgets/comment_container_widget.dart';
import 'package:idealize_new_version/Features/project_details/presentation/widgets/project_details_info_widget.dart';
import 'package:idealize_new_version/Features/project_details/presentation/widgets/project_material_widget.dart';
import 'package:idealize_new_version/Features/project_details/presentation/widgets/tags_container_widget.dart';

import 'package:idealize_new_version/app_repo.dart';
import 'package:idealize_new_version/gen/assets.gen.dart';

import 'controller/project_details_controller.dart';

class ProjectDetailsScreen extends GetView<ProjectDetailsController> {
  const ProjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors().backGroundColor,
      appBar: AppBar(
        title: Text(AppStrings.projectDetails.tr),
        actions: [
          Obx(() => IconButton(
                iconSize: 28,
                padding: const EdgeInsets.only(right: 10),
                icon: Icon(
                  controller.isArchived.value
                      ? Icons.bookmark
                      : Icons.bookmark_add_outlined,
                  color: AppColors().purpleColor,
                ),
                onPressed: () async {
                  await controller.toggleArchive(
                    (controller.project?.id ?? ''),
                    (controller.project?.owner?.id ?? ''),
                  );
                },
              ))
        ],
      ),
      body: FutureBuilder<Project>(
        future: controller.getProject(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomLoadingIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: controller.scrollController,
              child: Column(
                children: [
                  if (controller.project?.thumbnail?.id != null)
                    showImageFromNetwork(
                      controller.project?.thumbnail?.id ?? '',
                      height: Get.height * 0.18,
                      placeholder: ColoredBox(
                        color: AppColors().secondaryColor,
                        child: SizedBox(
                            width: double.infinity,
                            height: Get.height * 0.18,
                            child: Image.asset(
                              Assets.png.logoWhite.path,
                            )),
                      ),
                    ),
                  if (controller.project?.thumbnail?.id == null)
                    ColoredBox(
                      color: AppColors().secondaryColor,
                      child: SizedBox(
                          width: double.infinity,
                          height: Get.height * 0.18,
                          child: Image.asset(
                            Assets.png.logoWhite.path,
                          )),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.fromBorderSide(BorderSide(
                        color: AppColors().lightGrayColor,
                        width: 0.1,
                      )),
                    ),
                    width: double.infinity,
                    child: Text(
                      (controller.project?.title ?? '').toString(),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColors().txtColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ).paddingAll(AppConfig().dimens.medium),
                  ),
                  Obx(
                    () => CustomTabBar(
                      selectedIndex: controller.tabIndex.value,
                      onTabSelected: (index) =>
                          controller.changeTabIndex(index),
                      tabs: [
                        AppStrings.aboutProject.tr,
                        AppStrings.projectMaterials.tr,
                      ],
                    ),
                  ),
                  Obx(
                    () => IndexedStack(
                      index: controller.tabIndex.value,
                      children: [
                        Column(
                          children: [
                            Obx(
                              () => ProjectDetailsInfoWidget(
                                project: controller.project!,
                                projectLikes: controller.likes,
                                onReportProjectTapped: (reason) {
                                  controller.reportProject(reason);
                                },
                                joinedStatus: controller.joinedStatus.value,
                                onTappedComment: controller.scrollToComments,
                                ownerName:
                                    '${controller.project?.owner?.firstname ?? ''} ${controller.project?.owner?.surname ?? ''}'
                                            .trim()
                                            .isNotEmpty
                                        ? '${controller.project?.owner?.firstname ?? ''} ${controller.project?.owner?.surname ?? ''}'
                                            .trim()
                                        : 'N/A',
                                ownerId: controller.project?.owner?.id ?? '',
                                comments: controller.comments.length,
                                likes: ((controller.project?.likes ?? 0) +
                                    controller.isLikedValue.value),
                                isLiked: controller.isLiked.value,
                                members: controller.project?.projectUsers ?? [],
                                onTappedLike: () {
                                  controller.toggleLike(
                                      AppRepo().user!.id.toString());
                                },
                                onTapJoinProject: ['pending', 'accepted']
                                        .contains(controller.joinedStatus)
                                    ? null
                                    : () => _showJoinRequestDialog(context),
                                isReported:
                                    controller.project?.isReported ?? false,
                              ),
                            ),
                            Gap(AppConfig().dimens.medium),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.fromBorderSide(BorderSide(
                                  color: AppColors().lightGrayColor,
                                  width: 0.1,
                                )),
                              ),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.desciption.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: AppColors().txtColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Gap(AppConfig().dimens.medium),
                                  Text(
                                    (controller.project?.description ?? '')
                                        .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: AppColors().txtColor,
                                        ),
                                  ),
                                ],
                              ).paddingAll(AppConfig().dimens.medium),
                            ),
                            Gap(AppConfig().dimens.medium),
                            TagsContainerWidget(
                              tags: controller.project?.tags ?? [],
                              project: controller.project,
                            ),
                            Gap(AppConfig().dimens.medium),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.fromBorderSide(BorderSide(
                                    color: AppColors().lightGrayColor,
                                    width: 0.1,
                                  )),
                                ),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppStrings.comments.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: AppColors().txtColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ).paddingOnly(
                                        left: AppConfig().dimens.medium,
                                        right: AppConfig().dimens.medium,
                                        top: AppConfig().dimens.medium),
                                    Gap(AppConfig().dimens.small),
                                    controller.comments.isEmpty
                                        ? Center(
                                            child: Padding(
                                            padding: EdgeInsets.only(
                                              left: AppConfig().dimens.large,
                                              right: AppConfig().dimens.large,
                                              top: AppConfig().dimens.small,
                                              bottom: AppConfig().dimens.large,
                                            ),
                                            child: Text(
                                                textAlign: TextAlign.center,
                                                AppStrings.noComments.tr,
                                                style: TextStyle(
                                                  color: AppColors().txtColor,
                                                )),
                                          ))
                                        : Column(
                                            children: controller
                                                .comments.reversed
                                                .map(
                                                  (e) => CommentContainerWidget(
                                                    projectOwner: controller
                                                            .project
                                                            ?.owner
                                                            ?.id ??
                                                        '',
                                                    comment: e,
                                                    isReply: false,
                                                    onTappedReply: (id) =>
                                                        controller.reply(id),
                                                    onTappedRemove: (id) =>
                                                        controller
                                                            .removeComment(id),
                                                    onTappedReport: (
                                                      commentId,
                                                      comment,
                                                      reportedUser,
                                                      reason,
                                                    ) =>
                                                        controller
                                                            .reportComment(
                                                      commentId,
                                                      reportedUser:
                                                          reportedUser,
                                                      comment: comment,
                                                      reason: reason,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                  ],
                                )),
                            if (controller.replyCommentId.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 10,
                                  left: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: RichText(
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              height: 1.37,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: AppStrings.replyTo.tr,
                                              ),
                                              TextSpan(
                                                text:
                                                    " ${controller.getNameBasedOnReplyId(controller.replyCommentId.value)}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "\n${controller.getCommentBasedOnReplyId(controller.replyCommentId.value).pickFirstTenWords()}",
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Color.fromARGB(
                                                    255,
                                                    49,
                                                    49,
                                                    49,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: controller.removeReply,
                                        icon: const Icon(Icons.close)),
                                  ],
                                ),
                              ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: 50,
                              ),
                              child: TextField(
                                focusNode: controller.myFocusNode,
                                controller: controller.commentCtrl,
                                maxLength: 300,
                                minLines: 1,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                      color: AppColors().lightGrayColor,
                                      width: 0.1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                      color: AppColors().primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  hintText: AppStrings.writeAComment.tr,
                                  contentPadding: EdgeInsets.only(
                                    left: AppConfig().dimens.medium,
                                    right: AppConfig().dimens.medium,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      size: 20,
                                      Iconsax.send1,
                                      color: controller.isCommentEmpty.value
                                          ? Colors.grey
                                          : AppColors().secondaryColor,
                                    ),
                                    onPressed: controller.isCommentEmpty.value
                                        ? null
                                        : () => controller.comment(),
                                  ),
                                ),
                              ),
                            ).paddingOnly(
                              left: AppConfig().dimens.medium,
                              right: AppConfig().dimens.medium,
                              bottom: AppConfig().dimens.large,
                              top: AppConfig().dimens.medium,
                            ),
                          ],
                        ),
                        ProjectMaterialWidget(
                          documentFiles: documentFiles,
                          mediaFiles: mediaFiles,
                          downloadFile: controller.downloadProjectFile,
                          projectLinks: controller.project?.links,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  void _showJoinRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppStrings.jrdTitle.tr),
          content: Text(AppStrings.jrdContent.tr),
          actions: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("${AppStrings.message.tr}:",
                    style: TextStyle(
                      color: AppConfig().colors.txtColor,
                      fontWeight: FontWeight.w700,
                    )),
                Gap(AppConfig().dimens.small),
                CustomMultiLineTextField(
                  labelText: AppStrings.jrdContentHint.tr,
                  controller: controller.joinReqMsgController,
                  maxCharcters: 300,
                  maxLines: 7,
                ),
              ],
            ),
            // Gap(AppConfig().dimens.medium),
            CustomIconButton(
                    title: AppStrings.submit.tr,
                    onTap: () {
                      controller.joinProject();
                    },
                    txtColor: AppConfig().colors.primaryColor)
                .paddingOnly(top: 20),
          ],
        );
      },
    );
  }

  List<CustomXFile> get documentFiles =>
      controller.project?.attachments
          .where((attachment) => !FileUtils.isMediaFile(attachment.mimeType))
          .map(
            (e) => CustomXFile(
              name: e.filename,
              path: e.path,
              mediaType: e.mimeType.toMediaType(),
              uploadedId: e.id,
            ),
          )
          .toList() ??
      [];

  List<CustomXFile> get mediaFiles =>
      controller.project?.attachments
          .where((attachment) => FileUtils.isMediaFile(attachment.mimeType))
          .map(
            (e) => CustomXFile(
              name: e.filename,
              path: e.path,
              mediaType: e.mimeType.toMediaType(),
              uploadedId: e.id,
            ),
          )
          .toList() ??
      [];
}
