import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Components/buttons_widget.dart';
import 'package:idealize_new_version/Core/Components/image_loader_widget.dart';
import 'package:idealize_new_version/Core/Components/image_picker_btmsheet_widget.dart';
import 'package:idealize_new_version/Core/Components/textfields_widget.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Features/profile/presentation/controller/profile_controller.dart';
import 'package:idealize_new_version/Features/edit_profile/presentation/widgets/row_widget.dart';
import 'package:idealize_new_version/app_repo.dart';
import 'package:idealize_new_version/gen/assets.gen.dart';

class EditProfileScreen extends GetView<ProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppConfig().colors.backGroundColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: AppConfig().colors.backGroundColor,
          appBar: AppBar(
            title: Text(AppStrings.editProfile.tr),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GetBuilder<ProfileController>(
                  builder: (viewModel) => controller.image != null
                      ? Container(
                          height: 170,
                          width: 170,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppConfig().colors.primaryColor,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(
                                File(controller.image!.path),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(170),
                          child: showImageFromNetwork(
                            AppRepo().user?.profilePicture?.id ?? '',
                            width: 170,
                            height: 170,
                            placeholder: Container(
                              height: 170,
                              width: 170,
                              decoration: controller.image != null
                                  ? BoxDecoration(
                                      border: Border.all(
                                        color: AppConfig().colors.primaryColor,
                                        width: 2,
                                      ),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: FileImage(
                                          File(controller.image!.path),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : BoxDecoration(
                                      border: Border.all(
                                        color: AppConfig().colors.primaryColor,
                                        width: 2,
                                      ),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            Assets.png.placeholderProfile.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                ),
                Gap(AppConfig().dimens.large),
                CustomOutlineIconButton(
                  title: AppStrings.changePicture.tr,
                  onTap: () => showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context,
                    builder: (BuildContext context) {
                      return ImagePickerBottomSheetWidget(
                        onTapGallery: () async {
                          await controller.selectImageFromGallery();
                        },
                        onTapCamera: () async {
                          await controller.takePicture();
                        },
                      );
                    },
                  ),
                  width: MediaQuery.sizeOf(context).width / 2.4,
                  height: 45,
                ),
                Gap(AppConfig().dimens.small),
                // const Divider(
                //   height: 50,
                // ),
                // CustomRow(
                //   lable: AppStrings.userName.tr,
                //   lableValue: AppStrings.userNameHint.tr,
                //   controller: controller.usernameCtrl,
                // ),
                Gap(AppConfig().dimens.large),
                CustomRow(
                  lable: AppStrings.firstName.tr,
                  lableValue: AppStrings.firstNameHint.tr,
                  controller: controller.firstNameCtrl,
                ),
                Gap(AppConfig().dimens.small),
                CustomRow(
                  lable: AppStrings.lastName.tr,
                  lableValue: AppStrings.lastNameHint.tr,
                  controller: controller.lastNameCtrl,
                ),
                Gap(AppConfig().dimens.small),
                CustomRow(
                  lable: AppStrings.recoveryEmail.tr,
                  lableValue: AppStrings.recoveryEmail.tr,
                  controller: controller.recoveryEmailCtrl,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.aboutYou.tr,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Gap(AppConfig().dimens.medium),
                    Text(
                      AppStrings.aboutYouDescription.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    Gap(AppConfig().dimens.medium),
                    GetBuilder<ProfileController>(
                      builder: (controller) => CustomMultiLineTextField(
                        controller: controller.overviewCtrl,
                        labelText: AppStrings.aboutYouHint.tr,
                        maxCharcters: 500,
                        maxLines: 8,
                        onChanged: (value) {
                          if (value.trim().length > 500) {
                            Get.snackbar(
                              AppStrings.error.tr,
                              AppStrings.aboutYouTooLong.tr,
                              backgroundColor: Colors.red.shade100,
                            );
                            controller.overviewCtrl.text =
                                value.substring(0, 500);
                            controller.overviewCtrl.selection =
                                TextSelection.fromPosition(
                              const TextPosition(offset: 500),
                            );
                          }
                        },
                      ),
                    ),
                    Gap(AppConfig().dimens.large),
                  ],
                ).paddingAll(
                  AppConfig().dimens.medium,
                ),
              ],
            ).paddingAll(
              AppConfig().dimens.medium,
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              left: AppConfig().dimens.medium,
              right: AppConfig().dimens.medium,
              // bottom: AppConfig().dimens.large,
              bottom: MediaQuery.of(context).padding.bottom > 0
                  ? MediaQuery.of(context).padding.bottom
                  : AppConfig().dimens.medium,
              top: AppConfig().dimens.small,
            ),
            child: CustomIconButton(
              title: AppStrings.save.tr,
              txtColor: AppConfig().colors.primaryColor,
              onTap: controller.editProfile,
            ),
          ),
        ),
      ),
    );
  }
}
