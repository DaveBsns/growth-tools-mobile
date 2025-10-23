import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Features/authentication/presentation/controllers/reset_password_controller.dart';

import '../../../../Core/Components/buttons_widget.dart';
import '../../../../Core/Components/textfields_widget.dart';
import '../../../../Core/Constants/colors.dart';
import '../../../../Core/Constants/config.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors().backGroundColor,
      appBar: AppBar(
        title: Text(AppStrings.resetPassword.tr),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              '${AppStrings.newPassword.tr}:',
              style: textTheme.titleMedium,
            ),
            Gap(AppConfig().dimens.small),
            CustomTextField(
              key: const Key('auth_password'),
              controller: controller.passwordController,
              labelText: AppStrings.newPasswordHint.tr,
              isPassword: true,
              secondIcon: Icons.remove_red_eye,
              onSecondIconPressed: () {
                controller.isPassword.value = !controller.isPassword.value;
              },
            ),
            Gap(AppConfig().dimens.medium),
            Text(
              '${AppStrings.reEnterNewPassword.tr}:',
              style: textTheme.titleMedium,
            ),
            Gap(AppConfig().dimens.small),
            CustomTextField(
              key: const Key('auth_re_password'),
              controller: controller.rePasswordController,
              labelText: AppStrings.reEnterNewPassword.tr,
              isPassword: true,
              secondIcon: Icons.remove_red_eye,
              onSecondIconPressed: () {
                controller.isPassword.value = !controller.isPassword.value;
              },
            ),
            Gap(AppConfig().dimens.large),
          ],
        ).paddingAll(
          AppConfig().dimens.medium,
        ),
      ),
      bottomNavigationBar: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconButton(
                title: AppStrings.resetPassword.tr,
                onTap: controller.loading.value ? null : controller.reset,
                txtColor: AppColors().primaryColor,
              ),
              Gap(AppConfig().dimens.medium),
            ],
          )).paddingOnly(
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
