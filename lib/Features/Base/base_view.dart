import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Features/Base/base_viewmodel.dart';
import 'package:idealize_new_version/Features/Base/base_navigation_view.dart';
import 'package:idealize_new_version/Features/Create_New_Project/presentation/views/create_new_project_base_screen.dart';
import 'package:idealize_new_version/Features/home/presentation/home_view.dart';
import 'package:idealize_new_version/Features/app_setting/presentation/screens/app_setting_screen.dart';

import 'package:flutter_svg/svg.dart';
import 'package:idealize_new_version/gen/assets.gen.dart';

import '../Profile/presentation/profile_screen.dart';

class AppBaseView extends GetView<BaseViewModel> {
  const AppBaseView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.connectSocket();

    return GetBuilder<BaseViewModel>(
        init: controller,
        builder: (_) => Scaffold(
              backgroundColor: AppConfig().colors.backGroundColor,
              resizeToAvoidBottomInset: false,
              extendBody: true,
              extendBodyBehindAppBar: true,

              // TODO should be uncoment after realse version 1.0.0
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FloatingActionButton(
                  onPressed: controller.openChatScreen,
                  backgroundColor: const Color(0xff6675AE),
                  shape: const CircleBorder(),
                  child: SvgPicture.asset(Assets.svg.chatIc),
                ),
              ),
              body: IndexedStack(
                  index: controller.model.currentNavigationbarIndex,
                  children: const [
                    SafeArea(child: HomeView()),
                    SafeArea(child: CreateNewProjectBaseScreen()),
                    ProfileScreen(),
                    SafeArea(child: AppSettingScreen()),
                  ]),
              bottomNavigationBar: HomeNavigationBar(
                  currentIndex: controller.model.currentNavigationbarIndex,
                  onChangedMenu: controller.updateNavigationIndex),
            ));
  }
}
