import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Components/buttons_widget.dart';
import 'package:idealize_new_version/Core/Components/checkbox_btn_widget.dart';
import 'package:idealize_new_version/Core/Constants/colors.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';
import 'package:idealize_new_version/Core/Utils/enums.dart';
import 'package:idealize_new_version/Features/create_new_project/presentation/controller/create_new_project_controller.dart';
import 'package:idealize_new_version/Features/create_new_project/presentation/widgets/tag_container_widget.dart';
import '../../../../Core/Components/textfields_widget.dart';

class CreateNewProjectStepOneScreen
    extends GetView<CreateNewProjectController> {
  const CreateNewProjectStepOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig().colors.backGroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
            left: AppConfig().dimens.medium,
            right: AppConfig().dimens.medium,
            bottom: AppConfig().dimens.medium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                    children: [
                      TextSpan(text: AppStrings.projectTitle.tr),
                      TextSpan(
                        text: ' ${AppStrings.projectTitleCharacterRange.tr}',
                        style: const TextStyle(
                            fontSize: 12,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                      ),
                    ]),
              ),
              Gap(AppConfig().dimens.small),
              CustomTextField(
                labelText: AppStrings.projectTitleHint.tr,
                controller: controller.titleCtrl,
                onChanged: controller.updateTitle,
              ),
              Gap(AppConfig().dimens.medium),
              RichText(
                text: TextSpan(
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                    children: [
                      TextSpan(text: '${AppStrings.desciption.tr}*'),
                      TextSpan(
                        text: ' ${AppStrings.minimum100Characters.tr}',
                        style: const TextStyle(
                            fontSize: 12,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                      ),
                    ]),
              ),
              Gap(AppConfig().dimens.small),
              CustomMultiLineTextField(
                controller: controller.descriptionCtrl,
                onChanged: controller.updateDescription,
                labelText: AppStrings.descriptionHint.tr,
                minChars: 100,
              ),
              Gap(AppConfig().dimens.medium),
              TagsContainer(
                selectedTags: controller.selectedTags,
                onTagsChanged: (newTags) {
                  controller.selectedTags.clear();
                  controller.selectedTags.addAll(newTags);
                  controller.update();
                },
              ),
              Gap(AppConfig().dimens.large),
              Text(AppStrings.thisFieldAreRequired.tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppConfig().colors.txtColor,
                  )),
              Gap(AppConfig().dimens.large),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(
                      () => SizedBox(
                        width: 24,
                        height: 24,
                        child: CustomCheckboxButton(
                          key: UniqueKey(),
                          value: controller.checkboxValue.value,
                          onTapped: () {
                            if (controller.checkboxValue.value ==
                                CustomCheckBoxValue.checked) {
                              controller.checkboxValue.value =
                                  CustomCheckBoxValue.unchecked;
                            } else {
                              controller.checkboxValue.value =
                                  CustomCheckBoxValue.checked;
                            }
                            controller.update();
                          },
                        ),
                      ),
                    ),
                    Gap(AppConfig().dimens.mediumSmall),
                    Expanded(
                      child: Text(
                        AppStrings.rightsForMedia.tr,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors().darkGrayColor,
                                  fontSize: 13,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: AppConfig().dimens.medium,
          right: AppConfig().dimens.medium,
          bottom: AppConfig().dimens.large,
          top: AppConfig().dimens.small,
        ),
        child: GetBuilder<CreateNewProjectController>(
          init: controller,
          builder: (_) {
            final isTitleValid = controller.isTitleValid();
            return Row(
              children: [
                Expanded(
                  child: CustomOutlineIconButton(
                    title: (controller.updateProjectModel == null)
                        ? AppStrings.saveAsDraft.tr
                        : (controller.routeFrom == "add-project")
                            ? AppStrings.saveAsDraft.tr
                            : AppStrings.editAndSave.tr,
                    onTap: (isTitleValid &&
                            controller.descriptionCtrl.text.isNotEmpty &&
                            controller.selectedTags.isNotEmpty &&
                            controller.checkboxValue.value ==
                                CustomCheckBoxValue.checked)
                        ? (controller.updateProjectModel != null
                            ? () => controller.updateProject(
                                isDraft: controller.updateProjectModel!.isDraft)
                            : controller.createNewProjectAsDraft)
                        : null,
                  ),
                ),
                Gap(AppConfig().dimens.small),
                Expanded(
                  child: CustomIconButton(
                    color: AppConfig().colors.primaryColor,
                    title: AppStrings.next.tr,
                    txtColor: Colors.white,
                    onTap: (!isTitleValid ||
                            controller.descriptionCtrl.text.isEmpty ||
                            controller.loading.value ||
                            controller.selectedTags.isEmpty ||
                            controller.checkboxValue.value !=
                                CustomCheckBoxValue.checked)
                        ? null
                        : controller.createNewProjectStep2,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
