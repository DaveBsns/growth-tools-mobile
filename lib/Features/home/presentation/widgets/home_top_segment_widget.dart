import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Constants/colors.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/Constants/routes.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Features/home/presentation/controller/home_controller.dart';

class HomeTopSegmentWidget extends GetView<HomeController> {
  const HomeTopSegmentWidget({super.key});

  /// Maps recommendation type keys to their display labels
  String _getRecommendationTypeLabel(String type) {
    switch (type) {
      case 'basic':
        return AppStrings.recommendationTypeBasic.tr;
      case 'for-you':
        return AppStrings.recommendationTypeForYou.tr;
      case 'hybrid':
        return AppStrings.recommendationTypeHybrid.tr;
      default:
        return AppStrings.recommendationTypeBasic.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: controller,
      initState: (_) => controller.init(),
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            // height: 40,
            width: MediaQuery.sizeOf(context).width,
            child: SegmentedButton<String>(
              showSelectedIcon: false,
              multiSelectionEnabled: false,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppConfig().colors.primaryColor;
                    }
                    return Colors.white;
                  },
                ),
                side: WidgetStateProperty.resolveWith<BorderSide>(
                  (Set<WidgetState> states) {
                    return BorderSide(
                        color:
                            AppConfig().colors.lightGrayColor.withOpacity(0.5),
                        width: 1.1);
                  },
                ),
                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.white;
                    }
                    return Colors.black;
                  },
                ),
                iconColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.black;
                    }
                    return AppConfig().colors.primaryColor;
                  },
                ),
                // maximumSize: MaterialStateProperty.resolveWith<Size>(
                //   (Set<MaterialState> states) {
                //     if (states.contains(MaterialState.selected)) {
                //       return const Size(400, 50);
                //     }
                //     return const Size(400, 50);
                //   },
                // ),
                // minimumSize: MaterialStateProperty.resolveWith<Size>(
                //   (Set<MaterialState> states) {
                //     if (states.contains(MaterialState.selected)) {
                //       return const Size(400, 50);
                //     }
                //     return const Size(400, 50);
                //   },
                // ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              segments: [
                ButtonSegment<String>(
                    value: 'all-projects',
                    label: Text(
                      AppStrings.projects.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                ButtonSegment<String>(
                    value: 'for-you',
                    label: Text(
                      AppStrings.forYou.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                ButtonSegment<String>(
                    value: 'favorite-projects',
                    label: Text(
                      AppStrings.favorites.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
              selected: {controller.selectedFilter},
              onSelectionChanged: controller.updateSegmentValue,
            ),
          ),
          _recommendationTypeDropdown(context),
          _filteredByTagWidget(context),
        ],
      ),
    );
  }

  /// Dropdown widget to select recommendation type
  /// Only visible when "For You" segment is selected
  /// Note: This widget is rebuilt by the parent GetBuilder when selectedFilter changes
  Widget _recommendationTypeDropdown(BuildContext context) {
    // Only show dropdown when "For You" segment is selected
    if (controller.selectedFilter != 'for-you') {
      return const SizedBox.shrink();
    }

    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0.5,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: DropdownMenu<String>(
            key: ValueKey(controller.selectedRecommendationType.value),
            width: MediaQuery.sizeOf(context).width -
                (AppConfig().dimens.medium * 2),
            initialSelection: controller.selectedRecommendationType.value,
            label: Text(
              AppStrings.selectRecommendationType.tr,
              style: TextStyle(
                fontSize: 14,
                color: AppConfig().colors.darkGrayColor,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              fillColor: AppConfig().colors.backGroundColor,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppConfig().colors.lightGrayColor.withOpacity(0.5),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppConfig().colors.primaryColor,
                  width: 1.5,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppConfig().colors.lightGrayColor.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            dropdownMenuEntries: [
              DropdownMenuEntry<String>(
                value: 'basic',
                label: _getRecommendationTypeLabel('basic'),
              ),
              DropdownMenuEntry<String>(
                value: 'for-you',
                label: _getRecommendationTypeLabel('for-you'),
              ),
              DropdownMenuEntry<String>(
                value: 'hybrid',
                label: _getRecommendationTypeLabel('hybrid'),
              ),
            ],
            onSelected: (String? value) {
              if (value != null) {
                controller.updateRecommendationType(value);
              }
            },
            menuStyle: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.white),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filteredByTagWidget(BuildContext context) => Obx(
        () => controller.selectedFilter == 'all-projects'
            ? (controller.filteredByTag.value != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes().projectDetails,
                              arguments: controller.filteredByTagProject?.id);
                        },
                        style: const ButtonStyle(
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.all(0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.chevron_left,
                              color: AppColors().primaryColor,
                            ),
                            Text(
                              controller.filteredByTagProject?.title ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppColors().primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors().greenColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        margin: const EdgeInsets.only(top: 0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              controller.updateFilteredByTag(null, null);
                            },
                            child: Ink(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3.5, horizontal: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      controller.filteredByTag.value!.tagName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink())
            : const SizedBox.shrink(),
      );
}
