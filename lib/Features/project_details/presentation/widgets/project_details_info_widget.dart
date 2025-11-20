import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Components/buttons_widget.dart';
import 'package:idealize_new_version/Core/Components/textfields_widget.dart';
import 'package:idealize_new_version/Core/Components/users_like_bottomsheet_widget.dart';
import 'package:idealize_new_version/Core/Constants/colors.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/Constants/icons.dart';
import 'package:idealize_new_version/Core/Constants/routes.dart';
import 'package:idealize_new_version/Core/Data/Models/project_comment_model.dart';
import 'package:idealize_new_version/Core/Data/Models/project_model.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/app_repo.dart';

class ProjectDetailsInfoWidget extends StatelessWidget {
  final int likes;
  final int comments;
  final String ownerName;
  final String ownerId;
  final Project project;
  final List<ProjectLikes> projectLikes;
  final List<ProjectUser> members;
  final VoidCallback? onTappedLike;
  final bool isLiked;
  final bool isReported;
  final VoidCallback? onTappedComment;
  final VoidCallback? onTapJoinProject;
  final Function(String) onReportProjectTapped;
  final String? joinedStatus;
  final TextEditingController reportController = TextEditingController();

  ProjectDetailsInfoWidget({
    super.key,
    this.likes = 0,
    this.comments = 0,
    required this.ownerName,
    required this.project,
    required this.ownerId,
    this.projectLikes = const [],
    this.members = const [],
    this.onTappedLike,
    this.isLiked = false,
    this.onTappedComment,
    this.onTapJoinProject,
    this.joinedStatus,
    required this.onReportProjectTapped,
    this.isReported = false,
  });

  void _showReportDialog(BuildContext context) {
    if (isReported) {
      AppRepo().showSnackbar(
          label: AppStrings.alreadyReported.tr,
          text: AppStrings.alreadyReportedCaption.tr);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppStrings.report.tr),
          content: Text(AppStrings.reportReason.tr),
          actions: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("${AppStrings.reason.tr}:",
                    style: TextStyle(
                      color: AppConfig().colors.txtColor,
                      fontWeight: FontWeight.w700,
                    )),
                Gap(AppConfig().dimens.small),
                CustomMultiLineTextField(
                  labelText: AppStrings.enterYourReason.tr,
                  controller: reportController,
                  maxCharcters: 300,
                  maxLines: 7,
                ),
              ],
            ),
            // Gap(AppConfig().dimens.medium),
            CustomIconButton(
                    title: AppStrings.report.tr,
                    onTap: () {
                      onReportProjectTapped(reportController.text);
                    },
                    txtColor: AppConfig().colors.primaryColor)
                .paddingOnly(top: 20),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Gap(AppConfig().dimens.medium),
          Row(
            children: [
              Text(
                AppStrings.owner.tr,
                style: TextStyle(
                  color: AppColors().txtColor,
                  fontWeight: FontWeight.w700,
                ),
              ).paddingOnly(
                  left: AppConfig().dimens.medium,
                  right: AppConfig().dimens.small),
              Wrap(
                direction: Axis.horizontal,
                spacing: 8.0,
                runSpacing: 0.0,
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes().userSuggestionProfile,
                        arguments: ownerId,
                      );
                    },
                    child: Chip(
                        side: BorderSide(color: AppConfig().colors.lightBlue),
                        label: Text(
                          ownerName,
                          style: TextStyle(
                            color: AppConfig().colors.lightBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.transparent),
                  )
                ],
              )
            ],
          ),
          Gap(AppConfig().dimens.small),
          Wrap(
            direction: Axis.horizontal,
            spacing: 8.0,
            runSpacing: 0.0,
            children: [
              Text(
                AppStrings.members.tr,
                style: TextStyle(
                  color: AppColors().txtColor,
                  fontWeight: FontWeight.w700,
                ),
              ).paddingOnly(top: 13),
              ...members.map(
                (member) => InkWell(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes().userSuggestionProfile,
                      arguments: member.id,
                    );
                  },
                  child: Chip(
                    side: BorderSide(color: AppConfig().colors.lightBlue),
                    label: Text(
                      member.displayName,
                      style: TextStyle(
                        color: AppConfig().colors.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              if (members.isEmpty)
                Chip(
                  side: BorderSide(color: AppConfig().colors.lightBlue),
                  label: Text(
                    AppStrings.noContributors.tr,
                    style: TextStyle(
                      color: AppConfig().colors.lightBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              if (AppRepo().user!.id != ownerId &&
                  !members.any((element) => element.id == AppRepo().user!.id))
                _joinSection()
            ],
          ).paddingOnly(
            left: AppConfig().dimens.medium,
            right: AppConfig().dimens.medium,
          ),
          Gap(AppConfig().dimens.small),
          Row(
            children: [
              Gap(AppConfig().dimens.medium),
              Text(
                likes.toString(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors().txtColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Gap(AppConfig().dimens.extraSmall),
              InkWell(
                onTap: () => showModalBottomSheet(
                  backgroundColor: Colors.white,
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return UserslikeBottomSheet(
                      likes: projectLikes,
                    );
                  },
                ),
                child: Text(
                  AppStrings.likes.tr,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors().txtColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Gap(AppConfig().dimens.medium),
              Text(
                comments.toString(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors().txtColor,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
              Gap(AppConfig().dimens.extraSmall),
              Flexible(
                child: Text(
                  AppStrings.comments.tr,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors().txtColor,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
              ),
            ],
          ),
          Gap(AppConfig().dimens.medium),
          const Divider(height: 0),
          Row(
            children: [
              Gap(AppConfig().dimens.extraLarge),
              InkWell(
                onTap: () {
                  onTappedLike?.call();
                },
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Iconsax.like_15 : Iconsax.like_1,
                      size: 20,
                      color: AppConfig().colors.txtColor,
                    ),
                    Gap(AppConfig().dimens.small),
                    Text(
                      AppStrings.like.tr,
                      style: TextStyle(
                        color: AppConfig().colors.txtColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onTappedComment,
                child: Row(
                  children: [
                    Icon(
                      Iconsax.messages_3,
                      size: 20,
                      color: AppConfig().colors.txtColor,
                    ),
                    Gap(AppConfig().dimens.small),
                    Text(
                      AppStrings.comment.tr,
                      style: TextStyle(
                        color: AppConfig().colors.txtColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  _showReportDialog(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Iconsax.warning_2,
                      size: 20,
                      color: AppConfig().colors.redColor,
                    ),
                    Gap(AppConfig().dimens.small),
                    Text(
                      AppStrings.report.tr,
                      style: TextStyle(
                        color: AppConfig().colors.redColor,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(AppConfig().dimens.extraLarge),
            ],
          ).paddingAll(AppConfig().dimens.medium),
        ],
      ),
    );
  }

  Widget _joinSection() {
    Widget joinBtn = GestureDetector(
      onTap: onTapJoinProject,
      child: Chip(
        side: BorderSide.none,
        label: Text(
          AppStrings.joinProject.tr,
          style: TextStyle(
            color: AppConfig().colors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 12.5,
          ),
        ),
        avatar: Icon(
          Icons.add,
          color: AppConfig().colors.primaryColor,
        ),
        backgroundColor: AppConfig().colors.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );

    if (joinedStatus == 'pending') {
      return Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color.fromARGB(255, 201, 152, 3),
            width: 0.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Text(
          AppStrings.joinProjectPending.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 201, 152, 3),
            fontSize: 12.5,
          ),
        ),
      );
    } else if (joinedStatus == 'accepted') {
      return Container(
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color.fromARGB(255, 7, 130, 11),
            width: 0.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Text(
          AppStrings.joinProjectAccepted.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 7, 130, 11),
            fontSize: 12.5,
          ),
        ),
      );
    } else if (joinedStatus == 'cancelled') {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: const Color.fromARGB(255, 201, 3, 3),
                width: 0.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Text(
              AppStrings.joinProjectCancelled.tr,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 174, 5, 5),
                fontSize: 12.5,
              ),
            ),
          ),
          Gap(AppConfig().dimens.small),
          joinBtn,
        ],
      );
    }

    return joinBtn;
  }
}
