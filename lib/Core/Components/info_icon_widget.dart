import 'package:flutter/material.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/Constants/icons.dart';
import 'package:idealize_new_version/app_repo.dart';

class InfoIconWidget extends StatelessWidget {
  final String title;
  final String content;

  const InfoIconWidget({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppRepo().showCustomAlertDialog(
        title: title,
        content: content,
        buttonText: 'OK',
        buttonTextStyle: TextStyle(
          color: AppConfig().colors.primaryColor,
          fontWeight: FontWeight.w700,
        ),
        buttonColor: AppConfig().colors.secondaryColor,
      ),
      child: Icon(
        Iconsax.info_circle,
        color: AppConfig().colors.lightGrayColor,
        size: 22,
      ),
    );
  }
}
