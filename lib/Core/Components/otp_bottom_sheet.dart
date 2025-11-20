import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Components/buttons_widget.dart';
import 'dart:async';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpController extends GetxController {
  var code = ''.obs;
  var timeLeft = 300.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    timeLeft.value = 300;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  String get formattedTime {
    int minutes = timeLeft.value ~/ 60;
    int seconds = timeLeft.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class OtpBottomSheet extends StatelessWidget {
  final Function(String code) onCodeSubmitted;
  final VoidCallback onTappedResendCode;
  final VoidCallback onTappedEditInformation;

  const OtpBottomSheet({
    super.key,
    required this.onCodeSubmitted,
    required this.onTappedResendCode,
    required this.onTappedEditInformation,
  });

  @override
  Widget build(BuildContext context) {
    final OtpController controller = Get.put(OtpController());
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppStrings.enterVerificationCode.tr,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            Gap(AppConfig().dimens.medium),
            Text(AppStrings.enterVerificationCodeHint.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppConfig().colors.lightGrayColor,
                ),
                textAlign: TextAlign.center),
            Gap(AppConfig().dimens.extraLarge),
            PinCodeTextField(
              appContext: context,
              keyboardType: TextInputType.number,
              length: 4,
              onChanged: (newCode) {
                controller.code.value = newCode;
              },
              pinTheme: PinTheme(
                borderRadius: BorderRadius.circular(4),
                borderWidth: 1,
                selectedColor: AppConfig().colors.primaryColor,
                selectedFillColor: Colors.white,
                inactiveColor: AppConfig().colors.lightGrayColor,
                inactiveFillColor: Colors.white,
                activeColor: AppConfig().colors.primaryColor,
                activeFillColor: Colors.white,
                disabledColor: AppConfig().colors.lightGrayColor,
                shape: PinCodeFieldShape.box,
                fieldWidth: 50,
                fieldHeight: 50,
                fieldOuterPadding: EdgeInsets.zero,
              ),
            ).paddingSymmetric(horizontal: 30),
            Gap(AppConfig().dimens.large),
            Text(controller.formattedTime,
                style: TextStyle(
                    color: AppConfig().colors.txtColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            const Gap(85),
            CustomIconButton(
              title: AppStrings.next.tr,
              onTap:
                  controller.code.value.length == 4 && controller.timeLeft > 0
                      ? () {
                          String code = controller.code.value;

                          onCodeSubmitted(code);
                        }
                      : null,
              txtColor: AppConfig().colors.primaryColor,
            ),
            TextButton(
              onPressed: () {
                controller.startTimer();
                onTappedResendCode();
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: AppConfig().colors.txtColor),
                  children: <TextSpan>[
                    TextSpan(text: AppStrings.didntReceiveCode.tr + "  "),
                    TextSpan(
                      text: AppStrings.resendCode.tr,
                      style: TextStyle(
                          color: AppConfig().colors.secondaryColor,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () => onTappedEditInformation(),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: AppConfig().colors.txtColor),
                  children: <TextSpan>[
                    TextSpan(text: AppStrings.editInformation.tr + "  "),
                    TextSpan(
                      text: AppStrings.edit.tr,
                      style: TextStyle(
                          color: AppConfig().colors.secondaryColor,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
