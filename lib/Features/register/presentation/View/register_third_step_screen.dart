import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Components/buttons_widget.dart';
import 'package:idealize_new_version/Core/Components/image_picker_btmsheet_widget.dart';
import 'package:idealize_new_version/Core/Components/stepper_widget.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Features/register/presentation/controller/register_controller.dart';
import '../../../../Core/Constants/colors.dart';
import 'package:idealize_new_version/Core/Components/textfields_widget.dart';

class RegisterThirdStepScreen extends GetView<RegisterController> {
  const RegisterThirdStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.signUp.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              controller.cancelOptionalStepsRegistration();
            },
          ).paddingOnly(right: AppConfig().dimens.medium),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomStepperWidget(
              backgroundColor: AppConfig().colors.backGroundColor,
              stepCount: 3,
              activeStep: 3,
            ),
            // Text(
            //   AppStrings.userName.tr,
            //   style: textTheme.titleMedium,
            // ),
            // Gap(AppConfig().dimens.small),
            // CustomTextField(
            //   key: const Key('auth_username'),
            //   controller: controller.usernameCtrl,
            //   labelText: AppStrings.userName.tr,
            // ),
            // Gap(AppConfig().dimens.large),
            Text(
              AppStrings.profilePicture.tr,
              style: textTheme.titleMedium,
            ),
            const Gap(50),
            Center(
              child: DottedBorder(
                color: Colors.grey.shade400,
                strokeWidth: 2.5,
                dashPattern: const [12, 6],
                borderType: BorderType.Circle,
                child: GetBuilder<RegisterController>(
                  init: controller,
                  builder: (viewModel) => IconButton(
                    padding: controller.image != null
                        ? const EdgeInsets.all(8)
                        : const EdgeInsets.all(25),
                    onPressed: () => showModalBottomSheet(
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (BuildContext context) {
                        return ImagePickerBottomSheetWidget(
                          onTapGallery: () async {
                            await controller.selectImageFromGallery();
                            viewModel.update();
                          },
                          onTapCamera: () async {
                            await controller.takePicture();
                            viewModel.update();
                          },
                        );
                      },
                    ),
                    icon: controller.image != null
                        ? Stack(
                            children: [
                              SizedBox(
                                width: 130,
                                height: 130,
                                child: CircleAvatar(
                                  backgroundImage: FileImage(
                                    File(controller.image!.path),
                                  ),
                                  radius: 45,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    controller.clearImage();
                                  },
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors().lightBlue,
                                    child: const Icon(Icons.clear,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 90,
                            color: Colors.grey.shade400,
                          ),
                  ),
                ),
              ),
            ),
            Gap(AppConfig().dimens.large),
            Text(
              AppStrings.aboutYou.tr,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Gap(AppConfig().dimens.small),
            Text(
              AppStrings.aboutYouDescription.tr,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            Gap(AppConfig().dimens.medium),
            CustomMultiLineTextField(
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
                  controller.overviewCtrl.text = value.substring(0, 500);
                  controller.overviewCtrl.selection =
                      TextSelection.fromPosition(
                    TextPosition(offset: 500),
                  );
                }
              },
            ),
            Gap(AppConfig().dimens.large),
          ],
        ).paddingAll(AppConfig().dimens.medium),
      ),
      bottomNavigationBar: CustomIconButton(
        title: AppStrings.finish.tr,
        onTap: controller.finish,
        txtColor: AppColors().primaryColor,
      ).paddingOnly(
        left: AppConfig().dimens.medium,
        right: AppConfig().dimens.medium,
        bottom: MediaQuery.of(context).padding.bottom > 0
            ? MediaQuery.of(context).padding.bottom
            : AppConfig().dimens.medium,
        top: AppConfig().dimens.small,
      ),
    );
  }
}
