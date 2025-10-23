import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Components/buttons_widget.dart';
import 'package:idealize_new_version/Core/Components/textfields_widget.dart';
import 'package:idealize_new_version/Core/Constants/colors.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Features/delete_account/presentation/controller/delete_account_controller.dart';

class DeleteAccountKeepDataPage extends GetView<DeleteAccountController> {
  const DeleteAccountKeepDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          AppStrings.deleteAccountKeepData.tr,
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
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.deleteAccountOption0Desc.tr,
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
                                onTap: controller.sendCodeForKeepingDataDelete,
                                title: AppStrings.deleteAccountOption0Button.tr,
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
                      labelText: AppStrings.deleteAccountOption0TextField.tr,
                      keyboardType: TextInputType.number,
                      isCode: true,
                      onChanged: (p0) => controller.enteredCode.value = p0,
                    ),
                    const Gap(20),
                    TextButton(
                      onPressed: () {
                        if (controller.firstTimeChangeToRecoveryOpt1) {
                          controller.firstTimeChangeToRecoveryOpt1 = false;

                          controller.canSendCode.value = true;
                          controller.sendCodeForKeepingDataDelete(
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
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
                left: 24,
                right: 24,
              ),
              child: Obx(
                () => controller.isLoadingDelete.value
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
                                  keepData: true,
                                  useRecoveryEmail: controller
                                          .firstTimeChangeToRecoveryOpt1 ==
                                      false,
                                );
                              }),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
