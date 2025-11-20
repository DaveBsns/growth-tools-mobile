import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:idealize_new_version/Core/Data/Models/project_model.dart';

import '../../../Core/Data/Models/tag_model.dart';

abstract class RegisterRepository {
  Future<Map<String, dynamic>?> createUser({
    required String firstname,
    required String surname,
    required String email,
    required String recoveryEmail,
    required String password,
    String? institution,
  });

  Future<Map<String, dynamic>?> verifyAccount({
    required String email,
    required String code,
  });

  Future<Map<String, dynamic>?> resendCode({
    required String email,
  });

  Future<Map<String, dynamic>?> updateUser({
    String? firstname,
    String? surname,
    String? username,
    String? profilePicture,
    List<String> interstedTags = const [],
    List<String> interstedCourses = const [],
    List<String> studyPrograms = const [],
    String? overview,
  });

  Future<void> updateUserFromLocalCache(Map<String, dynamic> data);

  Future<ProjectFile?> uploadFile(
    String path,
    http_parser.MediaType mediaType,
  );

  Future<List<Tag>> fetchAllTags();
}
