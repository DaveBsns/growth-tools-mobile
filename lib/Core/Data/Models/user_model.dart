import 'package:idealize_new_version/Core/Data/Models/project_model.dart';
import 'package:idealize_new_version/Core/Data/Models/tag_model.dart';
import 'package:idealize_new_version/Core/Utils/extensions.dart';

class User {
  final String id;
  final String email;
  final String? recoveryEmail;
  final String firstname;
  final String surname;
  final bool? status;
  final String? token;
  final String? refreshToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProjectFile? profilePicture;
  final List<Tag> interestedTags;
  final List<Tag> interestedCourses;
  final List<Tag> studyPrograms;
  final String? username;
  final bool? pendingUser;
  final String? institution;

  User({
    required this.id,
    required this.email,
    required this.createdAt,
    required this.firstname,
    required this.surname,
    this.recoveryEmail,
    this.status,
    this.username,
    this.token,
    this.refreshToken,
    required this.updatedAt,
    this.profilePicture,
    this.interestedCourses = const [],
    this.interestedTags = const [],
    this.studyPrograms = const [],
    this.pendingUser,
    this.institution,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      recoveryEmail: json['recoveryEmail'],
      status: json['status'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      firstname: json['firstName'],
      surname: json['lastName'],
      token: json['token'],
      refreshToken: json['refreshToken'],
      username: json['username'],
      institution: json['institution'],
      profilePicture: (json['profilePicture'] != null &&
              json['profilePicture'] is Map<String, dynamic>)
          ? ProjectFile.fromJson(json['profilePicture'])
          : null,
      interestedTags: (json['interestedTags'] != null &&
              (json['interestedTags'] as List).isListMapStringDynamic)
          ? [...json['interestedTags'].map((e) => Tag.fromJson(e)).toList()]
          : [],
      interestedCourses: (json['interestedCourses'] != null &&
              (json['interestedCourses'] as List).isListMapStringDynamic)
          ? [...json['interestedCourses'].map((e) => Tag.fromJson(e)).toList()]
          : [],
      studyPrograms: (json['studyPrograms'] != null &&
              (json['studyPrograms'] as List).isListMapStringDynamic)
          ? [...json['studyPrograms'].map((e) => Tag.fromJson(e)).toList()]
          : [],
    );
  }

  factory User.fromLocalCacheJson(
    Map<String, dynamic> json, {
    String? token,
    String? refreshToken,
  }) {
    return User(
      id: json['_id'],
      email: json['email'],
      recoveryEmail: json['recoveryEmail'],
      status: json['status'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      firstname: json['firstName'],
      surname: json['lastName'],
      token: token ?? json['token'],
      refreshToken: refreshToken ?? json['refreshToken'],
      username: json['username'],
      institution: json['institution'],
      profilePicture: (json['profilePicture'] != null &&
              json['profilePicture'] is Map<String, dynamic>)
          ? ProjectFile.fromJson(json['profilePicture'])
          : null,
      interestedTags: (json['interestedTags'] != null &&
              json['interestedTags'] is List<dynamic>)
          ? [...json['interestedTags'].map((e) => Tag.fromJson(e)).toList()]
          : [],
      interestedCourses: (json['interestedCourses'] != null &&
              json['interestedCourses'] is List<dynamic>)
          ? [...json['interestedCourses'].map((e) => Tag.fromJson(e)).toList()]
          : [],
      studyPrograms: (json['studyPrograms'] != null &&
              json['studyPrograms'] is List<dynamic>)
          ? [...json['studyPrograms'].map((e) => Tag.fromJson(e)).toList()]
          : [],
    );
  }

  /// Returns the full name of the user, or "Deleted User" if the user data is anonymized/null
  String get displayName {
    final first = firstname.trim();
    final last = surname.trim();

    // Check if both names are empty, null, or literally "null"
    if ((first.isEmpty || first.toLowerCase() == 'null') &&
        (last.isEmpty || last.toLowerCase() == 'null')) {
      return 'Deleted User';
    }

    // Check if only one name is null/empty
    if (first.isEmpty || first.toLowerCase() == 'null') {
      return last.isNotEmpty && last.toLowerCase() != 'null'
          ? last
          : 'Deleted User';
    }
    if (last.isEmpty || last.toLowerCase() == 'null') {
      return first.isNotEmpty && first.toLowerCase() != 'null'
          ? first
          : 'Deleted User';
    }

    // Both names are valid
    return '$first $last'.trim();
  }

  /// Returns just the first name, or "Deleted" if anonymized
  String get displayFirstName {
    final first = firstname.trim();
    if (first.isEmpty || first.toLowerCase() == 'null') {
      return 'Deleted';
    }
    return first;
  }

  /// TODO Shayan: Returns the institution name, inferring from email domain if not set
  String? get institutionName {
    // If institution is already set, return it
    if (institution != null && institution!.isNotEmpty) {
      return institution;
    }

    // Try to infer from email domain for old users
    if (email.isEmpty) return null;

    final emailDomain = email.contains('@') ? email.split('@')[1] : '';

    // Map email domains to institution names
    const domainToInstitution = {
      // HHN - Hochschule Heilbronn
      'hs-heilbronn.de': 'HHN - Hochschule Heilbronn',
      'stud.hs-heilbronn.de': 'HHN - Hochschule Heilbronn',
      // IPAI (confirmed: ip.ai)
      'ip.ai': 'IPAI',
      // TUM (staff only)
      'tum.de': 'Technische Universität München (TUM)',
      // Heilbronn 42
      '42heilbronn.de': 'Heilbronn 42',
      'stud.42heilbronn.de': 'Heilbronn 42',
      // DHBW (staff only)
      'dhbw.de': 'DHBW',
      // Fraunhofer ISI (staff only)
      'isi.fraunhofer.de': 'Fraunhofer ISI',
      // Fraunhofer IAO
      'iao.fraunhofer.de': 'Fraunhofer IAO',
      'stud.iao.fraunhofer.de': 'Fraunhofer IAO',
    };

    return domainToInstitution[emailDomain];
  }
}
