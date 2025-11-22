import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Constants/colors.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/Constants/routes.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Features/home/presentation/controller/home_controller.dart';

class HomeTopSegmentWidget extends GetView<HomeController> {
  const HomeTopSegmentWidget({super.key});

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
          _filteredByTagWidget(context),
        ],
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
