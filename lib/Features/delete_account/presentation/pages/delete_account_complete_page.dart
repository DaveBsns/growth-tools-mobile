import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Components/buttons_widget.dart';
import 'package:idealize_new_version/Core/Components/textfields_widget.dart';
import 'package:idealize_new_version/Core/Constants/colors.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Features/delete_account/presentation/controller/delete_account_controller.dart';
import 'package:idealize_new_version/Features/delete_account/presentation/widgets/project_widget.dart';

class DeleteAccountCompletelyPage extends GetView<DeleteAccountController> {
  const DeleteAccountCompletelyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          AppStrings.deleteAccountComplete.tr,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Obx(
                () => controller.isLoadingCheckingProjects.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      )
                    : controller.projectsMustBeConsider.isEmpty
                        ? _confirmationCode
                        : _projectsCheck,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
                left: 24,
                right: 24,
              ),
              child: Obx(
                () => controller.projectsMustBeConsider.isNotEmpty
                    ? const SizedBox.shrink()
                    : controller.isLoadingDelete.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          )
                        : CustomIconButton(
                            title: AppStrings.deleteAccount.tr,
                            onTap: controller.enteredCode.value.length != 4
                                ? null
                                : (() {
                                    controller.verifyDelete(
                                        keepData: false,
                                        useRecoveryEmail: controller
                                                .firstTimeChangeToRecoveryOpt3 ==
                                            false);
                                  }),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _projectsCheck => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppStrings.deleteAccountOption3Desc.tr,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
          const Gap(40),
          ListView.builder(
            shrinkWrap: true,
            itemCount: controller.projectsMustBeConsider.length,
            itemBuilder: (context, index) => ProjectMustBeDeleteWidget(
              project: controller.projectsMustBeConsider[index],
              onOwnerChanged: (newOwner) => controller.changeProjectOwner(
                  controller.projectsMustBeConsider[index], newOwner),
            ),
          ),
        ],
      );

  Widget get _confirmationCode => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppStrings.deleteAccountOption2Desc.tr,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
          const Gap(40),
          controller.isLoadingSendCode.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                )
              : controller.canSendCode.value
                  ? CustomIconButton(
                      onTap: controller.sendCodeForCompletelyDelete,
                      title: AppStrings.deleteAccountOption1Button.tr,
                      color: AppColors().primaryColor,
                      width: 250,
                    )
                  : Text(
                      controller.formattedTime,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
          const Gap(20),
          CustomTextField(
            labelText: AppStrings.deleteAccountOption1TextField.tr,
            keyboardType: TextInputType.number,
            isCode: true,
            onChanged: (p0) => controller.enteredCode.value = p0,
          ),
          const Gap(20),
          TextButton(
            onPressed: () {
              if (controller.firstTimeChangeToRecoveryOpt3) {
                controller.firstTimeChangeToRecoveryOpt3 = false;

                controller.canSendCode.value = true;
                controller.sendCodeForCompletelyDelete(
                  useRecoveryEmail: true,
                );
              }
            },
            child: Text(
              AppStrings.useRecoveryEmailDesc.tr,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const Gap(20),
        ],
      );
}
