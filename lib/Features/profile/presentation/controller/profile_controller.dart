import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:idealize_new_version/Core/Data/Models/tag_model.dart';
import 'package:idealize_new_version/Core/Data/Models/user_model.dart';
import 'package:idealize_new_version/Core/Utils/extensions.dart';
import 'package:idealize_new_version/Core/Utils/image_upload_utils.dart';
import 'package:idealize_new_version/Features/profile/domain/profile_repo.dart';
import 'package:idealize_new_version/Features/edit_profile/domain/edit_profile_repo.dart';
import 'package:idealize_new_version/app_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:idealize_new_version/Core/I18n/messages.dart';

class ProfileController extends GetxController {
  late ProfileRepository repo;
  late EditProfileRepository editRepo;

  // late ProfileModel _model;

  RxList<Tag> selectedTags = <Tag>[].obs;
  RxList<Tag> selectedCourses = <Tag>[].obs;
  RxList<Tag> selectedStudyProgram = <Tag>[].obs;

  // ProfileViewModel() {
  //   _model = ProfileModel();
  // }

  ProfileController({
    required this.repo,
    required this.editRepo,
  });

  // ProfileModel get model => _model;

  Future<void> saveChanges() async {
    Map<String, dynamic> bodyParams = {};

    bodyParams['interestedTags'] =
        selectedTags.map((element) => element.id).toList();

    bodyParams['interestedCourses'] =
        selectedCourses.map((element) => element.id).toList();

    bodyParams['studyPrograms'] =
        selectedStudyProgram.map((element) => element.id).toList();

    if (bodyParams.isNotEmpty) {
      AppRepo().showLoading();
      final updatedUserData = await repo.updateUser(bodyParams);
      if (updatedUserData != null) {
        await repo.updateUserInLocalCache(updatedUserData);

        final userObject = User.fromJson(updatedUserData);
        AppRepo().user = userObject;

        AppRepo().hideLoading();

        AppRepo().showSnackbar(
          label: "Success",
          text: AppStrings.profileUpdated.tr,
          position: SnackPosition.TOP,
        );
      } else {
        AppRepo().hideLoading();
        AppRepo().showSnackbar(
          label: "Error",
          text: AppStrings.profileUpdateFailed.tr,
          position: SnackPosition.TOP,
        );
      }
    }
  }

  @override
  void onInit() async {
    _init();

    super.onInit();
  }

  void refreshUI() async {
    update();
    selectedCourses.refresh();
    selectedTags.refresh();
    selectedStudyProgram.refresh();
  }

  void _init() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      usernameCtrl.text = AppRepo().user?.username ?? '';
      firstNameCtrl.text = AppRepo().user?.firstname ?? '';
      lastNameCtrl.text = AppRepo().user?.surname ?? '';
      recoveryEmailCtrl.text = AppRepo().user?.recoveryEmail ?? '';
      overviewCtrl.text = AppRepo().user?.overview ?? ''; 

      selectedTags.clear();
      selectedTags.addAll(AppRepo().user?.interestedTags ?? []);

      selectedCourses.clear();
      selectedCourses.addAll(AppRepo().user?.interestedCourses ?? []);

      selectedStudyProgram.clear();
      selectedStudyProgram.addAll(AppRepo().user?.studyPrograms ?? []);
    });
  }

  final usernameCtrl = TextEditingController();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final recoveryEmailCtrl = TextEditingController();
  final overviewCtrl = TextEditingController(); 
  final imagePicker = ImagePicker();

  XFile? image;

  Future<void> selectImageFromGallery() async {
    try {
      final XFile? selectedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (selectedImage != null) {
        image = selectedImage;
        update();
      }
    } on PlatformException catch (exception) {
      if (exception.code == 'photo_access_denied') {
        await AppRepo().checkPermission();
      }
    } catch (er) {
      AppRepo().showSnackbar(
        label: AppStrings.error.tr,
        text: er.toString(),
      );
    }
  }

  Future<void> takePicture() async {
    try {
      final XFile? picture =
          await imagePicker.pickImage(source: ImageSource.camera);

      if (picture != null) {
        image = picture;
        update();
      }
    } catch (er) {
      AppRepo().showSnackbar(
        label: AppStrings.error.tr,
        text: er.toString(),
      );
    }
  }

  Future<void> editProfile() async {
    Map<String, dynamic> bodyParams = {};

    if (image != null) {
      image = await compressImage(image!);
      final attachedFile = await editRepo.uploadFile(
        image!.path,
        (image!.mimeType ?? 'image/jpeg').toMediaType(),
      );

      bodyParams['profilePicture'] = attachedFile!.id;
    }

    if (usernameCtrl.text.isNotEmpty) {
      bodyParams['username'] = usernameCtrl.text;
    }

    if (firstNameCtrl.text.isNotEmpty) {
      bodyParams['firstName'] = firstNameCtrl.text;
    }

    if (lastNameCtrl.text.isNotEmpty) {
      bodyParams['lastName'] = lastNameCtrl.text;
    }

    if (recoveryEmailCtrl.text.isNotEmpty) {
      bodyParams['recoveryEmail'] = recoveryEmailCtrl.text;
    }

  
    if (overviewCtrl.text.trim().isNotEmpty) {
      bodyParams['overview'] = overviewCtrl.text.trim();
    }

    if (bodyParams.isNotEmpty) {
      AppRepo().showLoading();

      final updatedUserData = await repo.updateUser(bodyParams);
      if (updatedUserData != null) {
        await repo.updateUserInLocalCache(updatedUserData);

        final userObject = User.fromJson(updatedUserData);
        AppRepo().user = userObject;

        AppRepo().hideLoading();
        refreshUI();
        Get.back();

        AppRepo().showSnackbar(
          label: 'Profile updated successfully',
          text: AppStrings.profileUpdated.tr,
          position: SnackPosition.TOP,
        );
      } else {
        AppRepo().hideLoading();

        AppRepo().showSnackbar(
          label: 'Profile update failed',
          text: AppStrings.profile.tr,
          position: SnackPosition.TOP,
        );
      }
    }
  }
}
