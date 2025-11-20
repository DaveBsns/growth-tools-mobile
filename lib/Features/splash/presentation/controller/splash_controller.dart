import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Constants/config.dart';
import 'package:idealize_new_version/Core/Data/Models/user_model.dart';
import 'package:idealize_new_version/Core/Utils/enums.dart';
import 'package:idealize_new_version/Core/Utils/extensions.dart';
import 'package:idealize_new_version/app_repo.dart';

import '../../domain/splash_repo.dart';

class SplashController extends GetxController {
  late SplashRepository repo;

  SplashController({
    required this.repo,
  });

  Future<void> checkUserStatusFromLocalCache() async {
    // TODO SH: Cache migration - clear old cached data if version < 2
    await _migrateCacheIfNeeded();

    final rawUserStatusFromLocalCache = AppRepo()
        .localCache
        .read<int>(AppConfig().localCacheKeys.userLoggedInStatus);

    await Future.delayed(const Duration(seconds: 2));

    switch (rawUserStatusFromLocalCache.toUserStatus()) {
      case UserStatus.loggedIn:
        final userObjectStr = await repo.fetchUserFromLocalCache();
        final userJwtToken = await repo.fetchUserJwtTokenFromLocalCache();
        final userJwtRefreshToken =
            await repo.fetchUserJwtRefreshTokenFromLocalCache();

        if (userObjectStr == null || userObjectStr == 'null') {
          AppRepo().logoutUser();
          break;
        }

        final userObject = User.fromLocalCacheJson(jsonDecode(userObjectStr!));

        AppRepo().user = userObject;
        AppRepo().jwtToken = userJwtToken;
        AppRepo().jwtRefreshToken = userJwtRefreshToken;

        await AppRepo().refillAllTheData();

        Get.offNamed(AppConfig().routes.base);
        break;
      case UserStatus.loggedOut:
        Get.offNamed(AppConfig().routes.authentication);
        break;
    }
  }

  /// TODO SH: Migrate cache from old version - clears outdated cached user data
  /// This ensures users get fresh data with new email field after backend update
  Future<void> _migrateCacheIfNeeded() async {
    const int currentCacheVersion = 2; // Increment when schema changes
    final int? savedCacheVersion =
        AppRepo().localCache.read<int>('cache_version');

    if (savedCacheVersion == null || savedCacheVersion < currentCacheVersion) {
      // Clear old cached user data that might not have email field
      await AppRepo()
          .secureLocalCache
          .write(AppConfig().localSecureCacheKeys.userObject, '');
      await AppRepo()
          .secureLocalCache
          .write(AppConfig().localSecureCacheKeys.jwtToken, '');
      await AppRepo()
          .secureLocalCache
          .write(AppConfig().localSecureCacheKeys.jwtRefreshToken, '');

      // Clear login status to force fresh login
      AppRepo().localCache.write(
            AppConfig().localCacheKeys.userLoggedInStatus,
            2, // UserStatus.loggedOut
          );

      // Update cache version
      AppRepo().localCache.write('cache_version', currentCacheVersion);
    }
  }

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppRepo().setDefaultLocale();
      checkUserStatusFromLocalCache();
    });
  }
}
