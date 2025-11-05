import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Components/buttons_widget.dart';
import 'package:idealize_new_version/Core/Components/checkbox_btn_widget.dart';
import 'package:idealize_new_version/Core/Components/textfields_widget.dart';
import 'package:idealize_new_version/Core/Components/dropdown_widget.dart';
import 'package:idealize_new_version/Core/Data/Models/institution_model.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Core/Utils/enums.dart';
import 'package:idealize_new_version/Core/Utils/extensions.dart';
import 'package:idealize_new_version/Features/register/presentation/controller/register_controller.dart';
import '../../../../Core/Components/stepper_widget.dart';
import '../../../../Core/Constants/colors.dart';

class RegisterFirstStepScreen extends GetView<RegisterController> {
  const RegisterFirstStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppConfig().colors.backGroundColor,
      appBar: AppBar(
        title: Text(AppStrings.signUp.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomStepperWidget(
              backgroundColor: AppConfig().colors.backGroundColor,
              stepCount: 3,
              activeStep: 1,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(AppStrings.thisFieldAreRequired.tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppConfig().colors.lightGrayColor,
                  )),
            ),
            Gap(AppConfig().dimens.medium),
            Text(
              "${AppStrings.firstName.tr}: *",
              style: textTheme.titleMedium,
            ),
            Gap(AppConfig().dimens.small),
            CustomTextField(
              key: const Key('auth_fn'),
              controller: controller.firstnameCtrl,
              labelText: AppStrings.firstName.tr,
              validator: (newTextfieldValue) {
                if (newTextfieldValue!.trim().isEmpty) {
                  controller.firstNameCheck = false;
                  return AppStrings.isEmpty.tr;
                } else {
                  controller.firstNameCheck = true;
                  return null;
                }
              },
            ),
            Gap(AppConfig().dimens.medium),
            Text(
              "${AppStrings.lastName.tr}: *",
              style: textTheme.titleMedium,
            ),
            Gap(AppConfig().dimens.small),
            CustomTextField(
              key: const Key('auth_sn'),
              controller: controller.surnameCtrl,
              labelText: AppStrings.lastName.tr,
              validator: (newTextfieldValue) {
                if (newTextfieldValue!.trim().isEmpty) {
                  controller.surnameCheck = false;
                  return AppStrings.isEmpty.tr;
                } else {
                  controller.surnameCheck = true;
                  return null;
                }
              },
            ),
            Gap(AppConfig().dimens.medium),
            // Institution Dropdown
            Text(
              "${AppStrings.institution.tr}: *",
              style: textTheme.titleMedium,
            ),
            Gap(AppConfig().dimens.small),
            Obx(() => CustomDropdownWidget(
                  items: Institutions.names,
                  hintText: AppStrings.selectInstitution.tr,
                  initialValue: controller.selectedInstitution.value?.name,
                  onSelectedItem: (String selectedName) {
                    final institution = Institutions.getByName(selectedName);
                    controller.selectedInstitution.value = institution;
                    // Clear email validation when institution changes
                    controller.emailCheck = false;
                  },
                )),
            Gap(AppConfig().dimens.medium),
            Text(
              "${AppStrings.email.tr}: *",
              style: textTheme.titleMedium,
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => Text(
                    controller.selectedInstitution.value != null
                        ? '${AppStrings.institutionEmailHint.tr} (${controller.institutionEmailPlaceholder})'
                        : AppStrings.emailShouldBeHHNHint.tr,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConfig().colors.lightGrayColor,
                    ),
                  )),
            ),
            Gap(AppConfig().dimens.small),
            CustomTextField(
              key: const Key('auth_email'),
              controller: controller.emailCtrl,
              labelText: AppStrings.email.tr,
              validator: (newTextfieldValue) {
                if (!newTextfieldValue!.isEmail) {
                  controller.emailCheck = false;
                  return AppStrings.isEmpty.tr;
                } else {
                  if (controller.selectedInstitution.value == null) {
                    controller.emailCheck = false;
                    return AppStrings.selectInstitution.tr;
                  }

                  final isValid = controller
                      .isValidInstitutionEmail(newTextfieldValue.trim());
                  controller.emailCheck = isValid;

                  if (!isValid) {
                    return '${AppStrings.institutionEmailHint.tr} (${controller.institutionEmailPlaceholder})';
                  }

                  return null;
                }
              },
            ),
            Gap(AppConfig().dimens.medium),
            Text(
              "${AppStrings.recoveryEmail.tr}: *",
              style: textTheme.titleMedium,
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppStrings.recoveryEmailExplanation.tr,
                style: TextStyle(
                  fontSize: 12,
                  color: AppConfig().colors.lightGrayColor,
                ),
              ),
            ),
            Gap(AppConfig().dimens.small),
            CustomTextField(
              key: const Key('auth_recovery_email'),
              controller: controller.reEmailCtrl,
              labelText: AppStrings.recoveryEmail.tr,
              validator: (newTextfieldValue) {
                controller.reEmailCheck = true;

                if ((newTextfieldValue ?? '').isNotEmpty) {
                  if (!newTextfieldValue!.isEmail) {
                    controller.reEmailCheck = false;
                    return AppStrings.isNotEmail.tr;
                  }
                }

                return null;
              },
            ),
            Gap(AppConfig().dimens.medium),
            Text(
              "${AppStrings.password.tr}: *",
              style: textTheme.titleMedium,
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppStrings.passwordInstructions.tr,
                style: TextStyle(
                  fontSize: 12,
                  color: AppConfig().colors.lightGrayColor,
                ),
              ),
            ),
            Gap(AppConfig().dimens.small),
            CustomTextField(
              controller: controller.passwordCtrl,
              labelText: AppStrings.password.tr,
              isPassword: true,
              secondIcon: Icons.remove_red_eye,
              validator: (newTextfieldValue) {
                if (newTextfieldValue!.isEmpty) {
                  controller.passwordCheck = false;
                  return AppStrings.couldNotBeEmpty.tr;
                } else if (!controller.isStrongPassword(newTextfieldValue)) {
                  controller.passwordCheck = false;
                  return AppStrings.passIsNotStrong.tr;
                } else {
                  controller.passwordCheck = true;
                  return null;
                }
              },
            ),
            Gap(AppConfig().dimens.medium),
            Text(
              "${AppStrings.reEnterPassword.tr}: *",
              style: textTheme.titleMedium,
            ),
            Gap(AppConfig().dimens.small),
            CustomTextField(
              key: const Key('auth_reEnterPassword'),
              controller: controller.reEnterPasswordCtrl,
              labelText: AppStrings.reEnterPassword.tr,
              isPassword: true,
              secondIcon: Icons.remove_red_eye,
              validator: (newTextfieldValue) {
                if (newTextfieldValue!.isEmpty) {
                  controller.passwordCheck = false;
                  return AppStrings.couldNotBeEmpty.tr;
                } else if (newTextfieldValue != controller.passwordCtrl.text) {
                  controller.passwordCheck = false;
                  return AppStrings.passIsNotMatch.tr;
                } else {
                  controller.passwordCheck = true;
                  return null;
                }
              },
            ),
            Gap(AppConfig().dimens.large),
            Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      const Gap(20),
                      _checkbox(textTheme),
                      const Gap(20),
                      CustomIconButton(
                        title: AppStrings.next.tr,
                        onTap: controller.loading.value
                            ? null
                            : controller.nextStep,
                        txtColor: AppColors().primaryColor,
                      ),
                    ],
                  ),
                  Gap(AppConfig().dimens.medium),
                  GestureDetector(
                    onTap: () =>
                        Get.offAndToNamed(AppConfig().routes.externalAuth),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: AppStrings.alreadyHaveAnAccount.tr,
                        style:
                            TextStyle(color: AppConfig().colors.primaryColor),
                        children: [
                          const WidgetSpan(
                            child: SizedBox(width: 7),
                          ),
                          TextSpan(
                            text: AppStrings.login.tr,
                            style: const TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: "  ${AppStrings.here.tr}",
                            style: TextStyle(
                              color: AppConfig().colors.secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ).paddingAll(AppConfig().dimens.medium),
      ),
    );
  }

  Widget _checkbox(TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => CustomCheckboxButton(
              key: UniqueKey(),
              value: controller.checkboxValue.value,
              onTapped: () {
                if (controller.checkboxValue.value ==
                    CustomCheckBoxValue.checked) {
                  controller.checkboxValue.value =
                      CustomCheckBoxValue.unchecked;
                } else {
                  controller.checkboxValue.value = CustomCheckBoxValue.checked;
                }
              },
            )),
        const Gap(10),
        Expanded(
            child: RichText(
          text: TextSpan(
            style: textTheme.titleMedium,
            children: <TextSpan>[
              TextSpan(text: AppStrings.iAgree.tr),
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    AppConfig().termsCondiftionsUrl.launchURL();
                  },
                text: AppStrings.termsAndConditions.tr,
                style: textTheme.titleMedium!.copyWith(
                  color: AppColors().secondaryColor,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
