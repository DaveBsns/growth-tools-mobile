import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:idealize_new_version/Core/Components/buttons_widget.dart';
import 'package:idealize_new_version/Core/Components/info_icon_widget.dart';
import 'package:idealize_new_version/Core/Constants/colors.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/Constants/icons.dart';
import 'package:idealize_new_version/Core/Data/Models/tag_model.dart';
import 'package:idealize_new_version/Core/Utils/enums.dart';
import 'package:idealize_new_version/Core/Utils/extensions.dart';
import 'package:idealize_new_version/Features/tag_selector/presentation/tag_selector_screen.dart';
import 'package:idealize_new_version/app_repo.dart';
import 'package:get/get.dart';

import 'package:idealize_new_version/Core/I18n/messages.dart';

class TagsContainer extends StatelessWidget {
  final List<Tag> selectedTags;
  final Function(List<Tag>) onTagsChanged;

  const TagsContainer({
    super.key,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        clipBehavior: Clip.none,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: AppColors().backGroundColor,
          borderRadius: BorderRadius.circular(AppConfig().dimens.small),
          border: Border.all(
            color: AppConfig().colors.darkGrayColor,
            width: 0.3,
          ),
        ),
        child: Padding(
          padding: AppConfig().dimens.medium.allPadding,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 0.0,
                      children: [
                        Text(
                          AppStrings.tags.tr,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        InfoIconWidget(
                          title: AppStrings.dailogAddTagsTitle.tr,
                          content: AppStrings.dailogAddTagsContent.tr,
                        ),
                        Gap(AppConfig().dimens.small),
                      ],
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      onPressed: () {
                        Get.to(
                          () => TagSelectorScreen(
                            title: AppStrings.tags.tr,
                            tagType: TagType.tag,
                            limit: 3,
                            initialSelectedChipData: selectedTags,
                            initialChipData: AppRepo()
                                .tags
                                .where((tag) => tag.type == TagType.tag)
                                .toList(),
                            onChipSelectedList: (newList) {
                              onTagsChanged(newList);
                            },
                          ),
                        );
                      },
                      icon: Icon(
                        Iconsax.add_circle,
                        color: AppColors().primaryColor,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
              selectedTags.isNotEmpty
                  ? Gap(AppConfig().dimens.small)
                  : const SizedBox.shrink(),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 8.0,
                  runSpacing: 0.0,
                  children: selectedTags
                      .map((selectedTag) => Chip(
                            side: BorderSide.none,
                            label: Text(
                              selectedTag.tagName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: AppConfig().colors.greenColor,
                            deleteIcon: const Icon(
                              Icons.close,
                              size: 18.0,
                              color: Colors.white,
                            ),
                            onDeleted: () {
                              // onTagsChanged(selectedTags..remove(selectedTag));
                              selectedTags.removeWhere(
                                  (elem) => elem.id == selectedTag.id);
                              onTagsChanged(List.from(selectedTags));
                            },
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
