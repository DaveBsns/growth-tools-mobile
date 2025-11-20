import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Components/buttons_widget.dart';
import 'package:idealize_new_version/Core/Components/image_loader_widget.dart';
import 'package:idealize_new_version/Core/Constants/colors.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/Constants/global_keys.dart';
import 'package:idealize_new_version/Core/Constants/icons.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Core/Utils/enums.dart';
import 'package:idealize_new_version/Core/Utils/extensions.dart';
import 'package:idealize_new_version/Features/profile/presentation/controller/profile_controller.dart';
import 'package:idealize_new_version/Features/tag_selector/presentation/tag_selector_screen.dart';
import 'package:idealize_new_version/app_repo.dart';
import 'package:idealize_new_version/gen/assets.gen.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: MediaQuery.of(context).orientation == Orientation.portrait
          ? Colors.white
          : AppConfig().colors.backGroundColor,
      child: SafeArea(
        child: Scaffold(
          key: GlobalKeys.profile,
          backgroundColor: AppConfig().colors.backGroundColor,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: AppConfig().colors.lightGrayColor,
                        width: 0.3,
                      ),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: AppConfig().dimens.medium.allPadding,
                        child: GetBuilder<ProfileController>(
                          init: controller,
                          builder: (_) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Gap(AppConfig().dimens.small),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(170),
                                child: showImageFromNetwork(
                                  AppRepo().user?.profilePicture?.id ?? '',
                                  width: 170,
                                  height: 170,
                                  placeholder: Container(
                                    height: 170,
                                    width: 170,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppConfig().colors.primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    child:
                                        Assets.png.placeholderProfile.image(),
                                  ),
                                ),
                              ),
                              Gap(AppConfig().dimens.medium),
                              Text(
                                AppRepo().user != null
                                    ? "${AppRepo().user!.firstname} ${AppRepo().user!.surname}"
                                    : "User not logged in",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppConfig().colors.primaryColor,
                                ),
                              ),
                              Gap(AppConfig().dimens.extraSmall),
                              Text(
                                AppRepo().user != null
                                    ? AppRepo().user!.email ??
                                        "No email available"
                                    : "No email available",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppConfig().colors.primaryColor,
                                ),
                              ),
                              Gap(AppConfig().dimens.extraSmall),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    size: 16,
                                    color: AppConfig().colors.darkGrayColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Institution: ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppConfig().colors.darkGrayColor,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      AppRepo().user?.institutionName ??
                                          'Not specified',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: AppRepo()
                                                    .user
                                                    ?.institutionName !=
                                                null
                                            ? AppConfig().colors.darkGrayColor
                                            : AppConfig().colors.lightGrayColor,
                                        fontStyle:
                                            AppRepo().user?.institutionName !=
                                                    null
                                                ? FontStyle.normal
                                                : FontStyle.italic,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(AppConfig().dimens.extraSmall),
                              // TODO is SH: Display user aboutYou/bio if available
                              if (AppRepo().user?.overview != null &&
                                  AppRepo().user!.overview!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppStrings.aboutYou.tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppConfig().colors.primaryColor,
                                      ),
                                    ),
                                    Gap(AppConfig().dimens.extraSmall),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Text(
                                        AppRepo().user!.overview!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              AppConfig().colors.darkGrayColor,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              Gap(AppConfig().dimens.extraSmall),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: () =>
                              Get.toNamed(AppConfig().routes.editProfile),
                          icon: Icon(
                            Iconsax.edit,
                            color: AppConfig().colors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(AppConfig().dimens.large),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomIconButton(
                        height: 45,
                        title: AppStrings.myProjects.tr,
                        onTap: () => Get.toNamed(AppConfig().routes.myProjects),
                        color: AppConfig().colors.secondaryColor,
                        txtColor: AppConfig().colors.primaryColor,
                      ),
                    ),
                    Gap(AppConfig().dimens.medium),
                    Expanded(
                      child: ColoredBox(
                        color: Colors.white,
                        child: CustomOutlineIconButton(
                          color: Colors.white,
                          title: AppStrings.favorites.tr,
                          height: 45,
                          onTap: () =>
                              Get.toNamed(AppConfig().routes.archivedProject),
                        ),
                      ),
                    ),
                  ],
                ).paddingSymmetric(
                  horizontal: AppConfig().dimens.medium,
                ),
                Gap(AppConfig().dimens.large),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppConfig().dimens.medium),
                  child: Obx(
                    () => Container(
                      clipBehavior: Clip.none,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppConfig().dimens.small),
                        border: Border.all(
                          color: AppConfig().colors.lightGrayColor,
                          width: 0.3,
                        ),
                      ),
                      child: Padding(
                        padding: AppConfig().dimens.medium.allPadding,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.interests.tr,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.to(
                                      () => TagSelectorScreen(
                                        title: AppStrings.interests.tr,
                                        initialChipData: AppRepo()
                                            .tags
                                            .where(
                                              (tag) => tag.type == TagType.tag,
                                            )
                                            .toList(),
                                        initialSelectedChipData:
                                            controller.selectedTags,
                                        tagType: TagType.tag,
                                        onTapedSavedButton:
                                            controller.saveChanges,
                                        onChipSelectedList: (newList) {
                                          controller.selectedTags.clear();
                                          controller.selectedTags
                                              .addAll(newList);
                                        },
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Iconsax.add_circle,
                                    color: AppColors().primaryColor,
                                    size: 28,
                                  ),
                                )
                              ],
                            ),
                            Gap(AppConfig().dimens.small),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: 8.0,
                                runSpacing: 0.0,
                                children: controller.selectedTags
                                    .map((selectedTag) => Chip(
                                          side: BorderSide.none,
                                          label: Text(
                                            selectedTag.tagName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          backgroundColor:
                                              AppConfig().colors.greenColor,
                                          deleteIcon: const Icon(
                                            Icons.close,
                                            size: 18.0,
                                            color: Colors.white,
                                          ),
                                          onDeleted: () {
                                            controller.selectedTags.removeWhere(
                                                (elem) =>
                                                    elem.id == selectedTag.id);

                                            controller.saveChanges();
                                          },
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(AppConfig().dimens.medium),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppConfig().dimens.medium),
                  child: Obx(
                    () => Container(
                      clipBehavior: Clip.none,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppConfig().dimens.small),
                        border: Border.all(
                          color: AppConfig().colors.lightGrayColor,
                          width: 0.3,
                        ),
                      ),
                      child: Padding(
                        padding: AppConfig().dimens.medium.allPadding,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.studyPrograms.tr,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.to(
                                      () => TagSelectorScreen(
                                        title: AppStrings.studyPrograms.tr,
                                        tagType: TagType.studyProgram,
                                        onTapedSavedButton:
                                            controller.saveChanges,
                                        initialSelectedChipData:
                                            controller.selectedStudyProgram,
                                        initialChipData: AppRepo()
                                            .tags
                                            .where(
                                              (tag) =>
                                                  tag.type ==
                                                  TagType.studyProgram,
                                            ) // Filter tags by category
                                            .toList(),
                                        onChipSelectedList: (newList) {
                                          controller.selectedStudyProgram
                                              .clear();
                                          controller.selectedStudyProgram
                                              .addAll(newList);
                                        },
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Iconsax.add_circle,
                                    color: AppColors().primaryColor,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            Gap(AppConfig().dimens.small),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: 8.0,
                                runSpacing: 0.0,
                                children: controller.selectedStudyProgram
                                    .map((selectedTag) => Chip(
                                          side: BorderSide.none,
                                          label: Text(
                                            selectedTag.tagName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          backgroundColor:
                                              AppConfig().colors.lightBlue,
                                          deleteIcon: const Icon(
                                            Icons.close,
                                            size: 18.0,
                                            color: Colors.white,
                                          ),
                                          onDeleted: () {
                                            controller.selectedStudyProgram
                                                .removeWhere((elem) =>
                                                    elem.id == selectedTag.id);

                                            controller.saveChanges();
                                          },
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(AppConfig().dimens.large),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
