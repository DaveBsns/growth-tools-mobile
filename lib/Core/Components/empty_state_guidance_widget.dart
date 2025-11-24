import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';

/// Reusable empty state widget with refresh button and guidance message

class EmptyStateGuidanceWidget extends StatelessWidget {
  final VoidCallback onRefresh;
  final String? customGuidanceMessage;
  final String emptyStateLabel;
  final IconData? iconData;
  final Color? iconColor;
  final TextStyle? messageStyle;

  const EmptyStateGuidanceWidget({
    super.key,
    required this.onRefresh,
    this.customGuidanceMessage,
    this.emptyStateLabel = '',
    this.iconData,
    this.iconColor,
    this.messageStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppConfig().dimens.large),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Empty state message with refresh button
              TextButton(
                onPressed: onRefresh,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      emptyStateLabel.isNotEmpty
                          ? emptyStateLabel
                          : AppStrings.emptyList.tr,
                      style: messageStyle ??
                          TextStyle(
                            color: AppConfig().colors.darkGrayColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    Gap(AppConfig().dimens.medium),
                    Icon(
                      iconData ?? Icons.refresh,
                      size: 60,
                      color: iconColor ?? AppConfig().colors.secondaryColor,
                    ),
                  ],
                ),
              ),
              // Optional custom guidance message below
              if (customGuidanceMessage != null) ...[
                Gap(AppConfig().dimens.large),
                Container(
                  padding: EdgeInsets.all(AppConfig().dimens.medium),
                  decoration: BoxDecoration(
                    color: AppConfig().colors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppConfig().colors.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppConfig().colors.primaryColor,
                        size: 20,
                      ),
                      Gap(AppConfig().dimens.small),
                      Expanded(
                        child: Text(
                          customGuidanceMessage!,
                          style: TextStyle(
                            color: AppConfig().colors.darkGrayColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
