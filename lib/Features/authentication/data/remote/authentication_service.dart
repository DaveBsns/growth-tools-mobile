import 'package:idealize_new_version/Core/Utils/enums.dart';
import '../../../../Core/Data/Services/services_helper.dart';

class AuthenticationService extends ServicesHelper {
  String get apiURL => '$baseURL/users';

  Future<Map<String, dynamic>?> login(Map<String, dynamic> input) async {
    return await request('$apiURL/login',
        serviceType: ServiceType.post, body: input);
  }

  Future<Map<String, dynamic>?> createUser({
    required String firstname,
    required String surname,
    required String email,
    required String recoveryEmail,
    required String password,
    String? institution,
  }) async {
    final Map<String, dynamic> data = {
      "firstName": firstname,
      "lastName": surname,
      "email": email,
      "recoveryEmail": recoveryEmail,
      "password": password,
      "userType": "student",
    };

    // Add institution if provided (backend will add this field as optional)
    if (institution != null && institution.isNotEmpty) {
      data["institution"] = institution;
    }

    final mappedData = await request(
      '$apiURL/new',
      body: data,
      serviceType: ServiceType.post,
      requiredDefaultHeader: false,
    );

    return mappedData;
  }

  Future<Map<String, dynamic>?> verify({
    required String email,
    required String code,
  }) async {
    final Map<String, dynamic> data = {
      "email": email,
      "code": code,
    };

    final mappedData = await request(
      '$apiURL/verify',
      body: data,
      serviceType: ServiceType.post,
      requiredDefaultHeader: false,
    );

    return mappedData;
  }

  Future<Map<String, dynamic>?> resendCode({
    required String email,
  }) async {
    final Map<String, dynamic> data = {
      "email": email,
    };

    final mappedData = await request(
      '$apiURL/resend-code',
      body: data,
      serviceType: ServiceType.post,
      requiredDefaultHeader: false,
    );

    return mappedData;
  }

  Future<Map<String, dynamic>?> updateUser({
    String? firstname,
    String? surname,
    String? username,
    String? profilePicture,
    List<String> interstedTags = const [],
    List<String> interstedCourses = const [],
    List<String> studyPrograms = const [],
  }) async {
    final Map<String, dynamic> data = {};

    if (firstname != null) {
      data['firstName'] = firstname;
    }

    if (surname != null) {
      data['lastName'] = surname;
    }

    if (username != null) {
      data['username'] = username;
    }

    if (profilePicture != null) {
      data['profilePicture'] = profilePicture;
    }

    if (interstedTags.isNotEmpty) {
      data['interestedTags'] = interstedTags;
    }

    if (interstedCourses.isNotEmpty) {
      data['interestedCourses'] = interstedCourses;
    }

    if (studyPrograms.isNotEmpty) {
      data['studyPrograms'] = studyPrograms;
    }

    final mappedData = await request(
      apiURL,
      body: data,
      serviceType: ServiceType.put,
      requiredDefaultHeader: true,
    );

    // debugPrint(mappedData);

    return mappedData;
  }

  Future<Map<String, dynamic>?> resetPasswordRequest({
    required String email,
    required bool isRecovery,
  }) async {
    final Map<String, dynamic> data = {
      "email": email,
    };

    final mappedData = await request(
      '$apiURL/reset-password?useRecoveryEmail=$isRecovery',
      body: data,
      serviceType: ServiceType.post,
      requiredDefaultHeader: false,
    );

    return mappedData;
  }

  Future<Map<String, dynamic>?> resetPasswordVerify({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final Map<String, dynamic> data = {
      "email": email,
      "code": code,
      "newPassword": newPassword,
    };

    final mappedData = await request(
      '$apiURL/reset-password-verify',
      body: data,
      serviceType: ServiceType.post,
      requiredDefaultHeader: false,
    );

    return mappedData;
  }
}
