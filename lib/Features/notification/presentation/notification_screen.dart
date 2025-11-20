import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Components/image_loader_widget.dart';
import 'package:idealize_new_version/Core/Constants/colors.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/Constants/icons.dart';
import 'package:idealize_new_version/Core/Constants/routes.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Core/Utils/enums.dart';
import 'package:idealize_new_version/Core/Utils/extensions.dart';
import 'package:idealize_new_version/gen/assets.gen.dart';

import 'controller/notification_controller.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.notification.tr),
        leading: IconButton(
          onPressed: controller.back,
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  controller.clearNotifications();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppStrings.clearAll.tr,
                        style: TextStyle(
                            color: AppColors().darkRedColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                    Gap(AppConfig().dimens.small),
                    Icon(
                      Iconsax.trash,
                      color: AppColors().darkRedColor,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ],
          ).paddingOnly(right: AppConfig().dimens.large),
          Expanded(
            child: Obx(() {
              if (controller.notifications.isEmpty) {
                return Center(child: Text(AppStrings.emptyNotification.tr));
              } else {
                final unreadList =
                    controller.notifications.where((e) => !e.isRead).toList();
                if (unreadList.isNotEmpty) {
                  controller
                      .readNotifications([...unreadList.map((e) => e.id)]);
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.notifications.length,
                  separatorBuilder: (context, index) =>
                      Gap(AppConfig().dimens.medium),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes().projectDetails,
                          arguments:
                              controller.notifications[index].projectId.id,
                        );
                      },
                      child: Container(
                        clipBehavior: Clip.none,
                        width: MediaQuery.sizeOf(context).width,
                        height: _hasActions(index) ? 140 : 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppConfig().dimens.small),
                          border: Border.all(
                            color: AppConfig().colors.lightGrayColor,
                            width: 0.3,
                          ),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Container(
                                width: 7,
                                decoration: BoxDecoration(
                                  color: _read(index)
                                      ? Colors.transparent
                                      : AppColors().secondaryColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        AppConfig().dimens.small),
                                    bottomLeft: Radius.circular(
                                        AppConfig().dimens.small),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Gap(AppConfig().dimens.medium),
                                        Container(
                                          height: 44,
                                          width: 44,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppConfig()
                                                  .colors
                                                  .lightGrayColor,
                                              width: 1,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: showImageFromNetwork(
                                                _getProfileImage(index) ?? '',
                                                fit: BoxFit.cover,
                                                placeholder: Assets
                                                    .png.placeholderProfile
                                                    .image(),
                                                width: 44,
                                                height: 44,
                                              )),
                                        ),
                                        Gap(AppConfig().dimens.medium),
                                        Flexible(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                _notifTitle(index),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  letterSpacing: -0.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppConfig()
                                                      .colors
                                                      .primaryColor,
                                                ),
                                              ),
                                              Text(
                                                _notifMessage(index),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  letterSpacing: -0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Gap(AppConfig().dimens.medium),
                                        Icon(
                                          controller
                                              .notifications[index].type.toIcon,
                                          size: AppConfig().dimens.medium,
                                          color: AppColors().primaryColor,
                                        ),
                                        Gap(AppConfig().dimens.medium),
                                      ],
                                    ),
                                    if (_hasActions(index))
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: AppConfig().dimens.medium),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                controller.responseToProjectRequest(
                                                    action: RequestResponseType
                                                        .accepted,
                                                    projectId: controller
                                                        .notifications[index]
                                                        .projectId
                                                        .id,
                                                    notificationId: controller
                                                        .notifications[index]
                                                        .id,
                                                    userId: controller
                                                        .notifications[index]
                                                        .receiver,
                                                    requestType: controller
                                                                .notifications[
                                                                    index]
                                                                .type ==
                                                            NotificationType
                                                                .addTeamMember
                                                        ? 'addTeamMember'
                                                        : 'joinTeamMember');
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors().primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      AppStrings.accept.tr,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: AppConfig()
                                                              .dimens
                                                              .mediumSmall,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Gap(AppConfig()
                                                        .dimens
                                                        .small),
                                                    Icon(Iconsax.tick_circle,
                                                        size: AppConfig()
                                                            .dimens
                                                            .mediumSmall,
                                                        color: Colors.white),
                                                  ],
                                                ).paddingSymmetric(
                                                    horizontal: 10,
                                                    vertical: 4),
                                              ).paddingOnly(
                                                  left:
                                                      AppConfig().dimens.large,
                                                  bottom: AppConfig()
                                                      .dimens
                                                      .medium),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                controller.responseToProjectRequest(
                                                    action: RequestResponseType
                                                        .canceled,
                                                    projectId: controller
                                                        .notifications[index]
                                                        .projectId
                                                        .id,
                                                    notificationId: controller
                                                        .notifications[index]
                                                        .id,
                                                    userId: controller
                                                        .notifications[index]
                                                        .receiver,
                                                    requestType: controller
                                                                .notifications[
                                                                    index]
                                                                .type ==
                                                            NotificationType
                                                                .addTeamMember
                                                        ? 'addTeamMember'
                                                        : 'joinTeamMember');
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors().darkRedColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      AppStrings.reject.tr,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: AppConfig()
                                                              .dimens
                                                              .mediumSmall,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Gap(AppConfig()
                                                        .dimens
                                                        .small),
                                                    Icon(Icons.cancel_outlined,
                                                        size: AppConfig()
                                                            .dimens
                                                            .mediumSmall,
                                                        color: Colors.white),
                                                  ],
                                                ).paddingSymmetric(
                                                    horizontal: 10,
                                                    vertical: 4),
                                              ).paddingOnly(
                                                  left: AppConfig()
                                                      .dimens
                                                      .mediumSmall,
                                                  right:
                                                      AppConfig().dimens.medium,
                                                  bottom: AppConfig()
                                                      .dimens
                                                      .medium),
                                            ),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 7),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).paddingAll(AppConfig().dimens.medium);
              }
            }),
          ),
        ],
      ),
    );
  }

  bool _hasActions(index) => (['addTeamMember', 'joinTeamMember']
          .contains(controller.notifications[index].type.value) &&
      !controller.notifications[index].processed);

  bool _read(index) => controller.notifications[index].isRead;

  String _notifMessage(int index) {
    final type = controller.notifications[index].type.value;
    final proccessed = controller.notifications[index].processed;

    final name =
        '${controller.notifications[index].sender.firstname} ${controller.notifications[index].sender.surname}';
    final project = controller.notifications[index].projectId.title;

    final params = {
      'name': '"$name"',
      'project': '"$project"',
    };

    const joinReqCanceledKey = 'join_req_canceled';
    const joinReqAcceptedKey = 'join_req_accepted';
    const joinReqCanceledByYouKey = 'join_req_canceled_by_you';
    const joinReqAcceptedByYouKey = 'join_req_accepted_by_you';
    const join_request = 'join_request';

    switch (type) {
      case 'addTeamMember':
        if (proccessed) {
          if (controller.notifications[index].message == joinReqCanceledKey) {
            return AppStrings.addTeamMemberCanceled.trParams(params);
          }
          if (controller.notifications[index].message == joinReqAcceptedKey) {
            return AppStrings.addTeamMemberAccepted.trParams(params);
          }
          if (controller.notifications[index].message ==
              joinReqCanceledByYouKey) {
            return AppStrings.addTeamMemberCanceledByYou.trParams(params);
          }
          if (controller.notifications[index].message ==
              joinReqAcceptedByYouKey) {
            return AppStrings.addTeamMemberAcceptedByYou.trParams(params);
          }

          return controller.notifications[index].message;
        } else {
          return AppStrings.addTeamMember.trParams(params);
        }

      case 'joinTeamMember':
        if (proccessed) {
          if (controller.notifications[index].message == joinReqCanceledKey) {
            return AppStrings.joinTeamMemberCanceled.trParams(params);
          }
          if (controller.notifications[index].message == joinReqAcceptedKey) {
            return AppStrings.joinTeamMemberAccepted.trParams(params);
          }
          if (controller.notifications[index].message ==
              joinReqCanceledByYouKey) {
            return AppStrings.joinTeamMemberCanceledByYou.trParams(params);
          }
          if (controller.notifications[index].message ==
              joinReqAcceptedByYouKey) {
            return AppStrings.joinTeamMemberAcceptedByYou.trParams(params);
          }

          return controller.notifications[index].message;
        } else {
          return AppStrings.joinTeamMember.trParams(params);
        }

      case 'bookmark':
        return AppStrings.somebodyBookmarkedyou.trParams(params);
      case 'like':
        return AppStrings.somebodyLikedyou.trParams(params);
      case 'comment':
        return AppStrings.somebodyCommentedyou.trParams(params);
      case 'report':
        return AppStrings.somebodyReportedyou.trParams(params);
      default:
        return controller.notifications[index].message;
    }
  }

  String? _getProfileImage(int index) {
    final notif = controller.notifications[index];
    return notif.sender.profilePicture?.id;
  }

  String _notifTitle(int index) {
    final type = controller.notifications[index].type.value;

    switch (type) {
      case 'addTeamMember':
        return AppStrings.notifAddTeamMamber.tr;
      case 'joinTeamMember':
        return AppStrings.notifJoinTeamMember.tr;
      case 'bookmark':
        return AppStrings.notifBookmar.tr;
      case 'like':
        return AppStrings.notifLike.tr;
      case 'comment':
        return AppStrings.notifComment.tr;
      case 'report':
        return AppStrings.notifReport.tr;
      default:
        return type;
    }
  }
}
