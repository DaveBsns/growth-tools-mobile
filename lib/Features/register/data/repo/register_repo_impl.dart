import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:idealize_new_version/Core/Data/Models/project_model.dart';
import 'package:idealize_new_version/Core/Data/Models/tag_model.dart';
import 'package:idealize_new_version/Core/Data/Services/tags_service.dart';
import 'package:idealize_new_version/Core/Data/Services/upload_service.dart';
import 'package:idealize_new_version/Features/authentication/data/remote/authentication_service.dart';

import '../../domain/register_repo.dart';
import '../data/local/register_local_services.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final localService = RegisterLocalServices();

  @override
  Future<Map<String, dynamic>?> createUser({
    required String firstname,
    required String surname,
    required String email,
    required String recoveryEmail,
    required String password,
    String? institution,
  }) async {
    return await AuthenticationService().createUser(
      firstname: firstname,
      surname: surname,
      email: email,
      recoveryEmail: recoveryEmail,
      password: password,
      institution: institution,
    );
  }

  @override
  Future<List<Tag>> fetchAllTags() async {
    return await TagService().fetchAllTags();
  }

  @override
  Future<Map<String, dynamic>?> resendCode({
    required String email,
  }) async {
    return await AuthenticationService().resendCode(
      email: email,
    );
  }

  @override
  Future<Map<String, dynamic>?> updateUser({
    String? firstname,
    String? surname,
    String? username,
    String? profilePicture,
    List<String> interstedTags = const [],
    List<String> interstedCourses = const [],
    List<String> studyPrograms = const [],
    String? overview,
  }) async {
    return await AuthenticationService().updateUser(
      firstname: firstname,
      surname: surname,
      username: username,
      profilePicture: profilePicture,
      interstedTags: interstedTags,
      interstedCourses: interstedCourses,
      studyPrograms: studyPrograms,
      overview: overview,
    );
  }

  @override
  Future<ProjectFile?> uploadFile(
    String path,
    http_parser.MediaType mediaType,
  ) async {
    return await UploadService().uploadFile(path: path, mediaType: mediaType);
  }

  @override
  Future<Map<String, dynamic>?> verifyAccount({
    required String email,
    required String code,
  }) async {
    return await AuthenticationService().verify(
      code: code,
      email: email,
    );
  }

  @override
  Future<void> updateUserFromLocalCache(Map<String, dynamic> data) async {
    await localService.updateUser(data);
  }
}
