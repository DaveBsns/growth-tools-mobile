/// selecting interests and study courses from user model.
///
/// It takes the following parameters:
/// * `chipData`: A list of strings representing the data for the chips.
/// * `selectedChipData`: A list of strings representing the currently selected chips.
/// * `onChipSelectedList`: A callback function that is called when the list of selected chips changes.
///
library;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Components/buttons_widget.dart';
import 'package:idealize_new_version/Core/Components/textfields_widget.dart';
import 'package:idealize_new_version/Core/Constants/colors.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/Constants/icons.dart';
import 'package:idealize_new_version/Core/Data/Models/user_model.dart';
import 'package:idealize_new_version/Core/Utils/extensions.dart';
import 'package:idealize_new_version/Core/I18n/messages.dart';

class TeamMembersSelectorBottomSheetWidget extends StatefulWidget {
  final List<User> chipData;
  final List<User> selectedChipData;
  final Function(List<User>)? onChipSelectedList;

  const TeamMembersSelectorBottomSheetWidget(
      {super.key,
      required this.chipData,
      required this.selectedChipData,
      this.onChipSelectedList});

  @override
  State<TeamMembersSelectorBottomSheetWidget> createState() =>
      _InterestAndCourseSelectorBottomSheetState();
}

class _InterestAndCourseSelectorBottomSheetState
    extends State<TeamMembersSelectorBottomSheetWidget> {
  final List<User> _selectedUsers = [];
  final List<User> _users = [];
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _users.addAll(widget.chipData);
    _users.removeWhere((element) => element.firstname.isEmpty);
    _selectedUsers.addAll(widget.selectedChipData);
    _searchCtrl.addListener(_search);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_search);
    super.dispose();
  }

  void _search() {
    final searchValue = _searchCtrl.text;
    if (searchValue.isEmpty) {
      _users.clear();
      _users.addAll(widget.chipData);
      _users.removeWhere((element) => element.firstname.isEmpty);
      setState(() {});
      return;
    }

    final searchList = _users
        .where((element) =>
            element.firstname
                .toLowerCase()
                .contains(searchValue.toLowerCase()) ||
            element.surname.toLowerCase().contains(searchValue.toLowerCase()))
        .toList();

    _users.clear();
    _users.addAll(searchList);

    setState(() {});
  }

  void _updateUserSelection(User user, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedUsers.add(user);
      } else {
        _selectedUsers.removeWhere((elem) => elem.id == user.id);
      }
    });

    widget.onChipSelectedList?.call(_selectedUsers);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textStyles = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      child: SizedBox(
        child: ColoredBox(
          color: Colors.white,
          child: Padding(
            padding: AppConfig().dimens.medium.allPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(AppConfig().dimens.small),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: CustomSearchField(
                    secondIcon: Iconsax.search_normal_14,
                    labelText: AppStrings.search.tr,
                    controller: _searchCtrl,
                  ),
                ),
                Gap(AppConfig().dimens.medium),
                Expanded(
                  child: _users.isNotEmpty
                      ? SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: _users.map((entry) {
                              bool isSelected = _selectedUsers.indexWhere(
                                      (element) => element.id == entry.id) !=
                                  -1;
                              return ChoiceChip(
                                checkmarkColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppConfig().colors.greenColor
                                        : AppConfig().colors.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConfig().dimens.small),
                                ),
                                selectedColor: AppConfig().colors.greenColor,
                                label: Text(entry.displayName),
                                labelStyle: isSelected
                                    ? textStyles.titleMedium!
                                        .copyWith(color: Colors.white)
                                    : textStyles.titleMedium!.copyWith(
                                        color: AppConfig().colors.primaryColor),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  _updateUserSelection(entry, selected);
                                },
                              );
                            }).toList(),
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.info_circle,
                                size: 70,
                                color: Colors.grey[400],
                              ),
                              Gap(AppConfig().dimens.medium),
                              Text(
                                textAlign: TextAlign.center,
                                AppStrings.noUsersToShow.tr,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              Gap(AppConfig().dimens.extraLarge),
                            ],
                          ),
                        ),
                ),
                Gap(AppConfig().dimens.medium),
                CustomIconButton(
                  color: AppConfig().colors.secondaryColor,
                  title: AppStrings.save.tr,
                  txtColor: AppColors().primaryColor,
                  onTap: Get.back,
                ),
                Gap(AppConfig().dimens.medium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
