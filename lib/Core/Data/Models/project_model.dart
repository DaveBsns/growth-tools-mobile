import 'package:idealize_new_version/Core/Data/Models/link_model.dart';
import 'package:idealize_new_version/Core/Data/Models/tag_model.dart';
import 'package:idealize_new_version/Core/Data/Models/user_model.dart';
import 'package:idealize_new_version/Core/Data/Models/user_permission_user_model.dart';
import 'package:idealize_new_version/Core/Utils/extensions.dart';

class Project {
  final String id;
  final String title;
  final bool isDraft;
  final String description;
  final List<Tag> tags;
  final List<Tag> courses;
  final List<ProjectUser> projectUsers;
  final List<ProjectUser> pendingMembers;
  final User? owner;
  final DateTime createdAt;
  final List<ProjectFile> attachments;
  final ProjectFile? thumbnail;
  final List<LinkModel> links;
  final bool isLiked;
  final int comments;
  final int likes;
  bool? isArchived;
  String? archiveId;
  String? joinedStatus;
  bool isReported;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.isDraft,
    required this.tags,
    required this.courses,
    required this.projectUsers,
    required this.pendingMembers,
    this.owner,
    required this.createdAt,
    this.attachments = const [],
    this.links = const [],
    this.isLiked = false,
    this.comments = 0,
    this.likes = 0,
    this.isArchived = false,
    this.archiveId,
    this.thumbnail,
    this.joinedStatus,
    this.isReported = false,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isDraft: json['isDraft'] ?? false,
      owner: (json['owner'] != null && json['owner'] is Map<String, dynamic>)
          ? User.fromJson(json['owner'])
          : null,
      tags: (json['tags'] != null &&
              (json['tags'] as List).isListMapStringDynamic)
          ? json['tags']
              .map((tagJSON) =>
                  tagJSON.isNotEmpty ? Tag.fromJson(tagJSON) : null)
              .whereType<Tag>()
              .toList()
          : [],
      courses: (json['courses'] != null &&
              (json['courses'] as List).isListMapStringDynamic)
          ? json['courses']
              .map((tagJSON) =>
                  tagJSON.isNotEmpty ? Tag.fromJson(tagJSON) : null)
              .whereType<Tag>()
              .toList()
          : [],
      projectUsers: (json['teamMembers'] != null &&
              (json['teamMembers'] as List).isListMapStringDynamic)
          ? json['teamMembers']
              .map((userJson) =>
                  userJson.isNotEmpty ? ProjectUser.fromJson(userJson) : null)
              .whereType<ProjectUser>()
              .toList()
          : [],
      pendingMembers: (json['pendingMembers'] != null &&
              (json['pendingMembers'] as List).isListMapStringDynamic)
          ? json['pendingMembers']
              .map((userJson) =>
                  userJson.isNotEmpty ? ProjectUser.fromJson(userJson) : null)
              .whereType<ProjectUser>()
              .toList()
          : [],
      attachments: (json['attachments'] != null &&
              json['attachments'] != [] &&
              (json['attachments'] as List).isListMapStringDynamic)
          ? [for (final file in json['attachments']) ProjectFile.fromJson(file)]
          : [],
      links: json['links'] != null
          ? [for (final link in json['links']) LinkModel.fromJson(link)]
          : [],
      isLiked: json['isLiked'] ?? false,
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      isArchived: json['isArchived'] ?? false,
      archiveId: json['archiveId'],
      thumbnail: (json['thumbnail'] != null &&
              json['thumbnail'] is Map<String, dynamic>)
          ? ProjectFile.fromJson(json['thumbnail'])
          : null,
      joinedStatus: json['joinedStatus'],
      isReported: json['isReported'] ?? false,
    );
  }
}

class SaveProject {
  int id;
  UsersPermissionsUser usersPermissionsUser;

  SaveProject({
    required this.id,
    required this.usersPermissionsUser,
  });

  factory SaveProject.fromJson(Map<String, dynamic> json) {
    return SaveProject(
        id: json['id'],
        usersPermissionsUser:
            json['attributes']['users_permissions_user']['data'] != null &&
                    json['attributes']['users_permissions_user']['data'] != []
                ? UsersPermissionsUser.fromJson(
                    json['attributes']['users_permissions_user']['data'])
                : UsersPermissionsUser(
                    id: 0,
                    // Set the alternative values here
                    username: '',
                    email: '',
                    provider: '',
                    confirmed: false,
                    blocked: false,
                    firstname: '',
                    surname: '',
                  ));
  }
}

class ProjectFile {
  final String id;
  final String originalName;
  final String newFileName;
  final int size;
  final String mimeType;
  final String filename;
  final String path;
  final ProjectUser? user;

  ProjectFile({
    required this.id,
    required this.originalName,
    required this.newFileName,
    required this.size,
    required this.mimeType,
    required this.filename,
    required this.path,
    this.user,
  });

  factory ProjectFile.fromJson(Map<String, dynamic> json) {
    return ProjectFile(
      id: json['_id'],
      originalName: json['originalName'],
      newFileName: json['newFileName'],
      size: json['size'],
      mimeType: json['mimeType'],
      filename: json['filename'],
      path: json['path'],
      user: (json['user'] != null && json['user'] is! String)
          ? ProjectUser.fromJson(json['user'])
          : null,
    );
  }
}

class ProjectUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String userType;

  ProjectUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userType,
  });

  factory ProjectUser.fromJson(Map<String, dynamic> json) {
    return ProjectUser(
      id: json['_id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userType: json['userType'] ?? 'student',
    );
  }

  /// Returns the full name of the user, or "Deleted User" if the user data is anonymized/null
  String get displayName {
    final first = firstName.trim();
    final last = lastName.trim();

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
}
