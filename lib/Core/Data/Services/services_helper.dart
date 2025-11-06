import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:idealize_new_version/Core/Data/Models/user_model.dart';
import 'package:idealize_new_version/Core/Utils/enums.dart';
import 'package:idealize_new_version/Features/user_forbidden_screen.dart';
import 'package:idealize_new_version/app_repo.dart';
import '../../Constants/config.dart';
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:idealize_new_version/Core/I18n/messages.dart';

class ServicesHelper {
  final String baseURL = AppConfig().baseURL;
  final String baseFileUrl = AppConfig().baseFileUrl;
  final int pageSize = 50;
  final int timeout = 5;

  Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppRepo().jwtToken}'
      };

  String queryMaker(Map<String, dynamic> parameters) {
    String query = '';
    parameters.forEach((key, value) {
      if (query.isEmpty) {
        query = '?$key=$value';
      } else {
        query = '$query&$key=$value';
      }
    });

    return query;
  }

  Future<dynamic> request(
    String url, {
    required ServiceType serviceType,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiredDefaultHeader = false,
    bool isFile = false,
  }) async {
    final uri = Uri.parse(url);

    Map<String, String> newHeaders = defaultHeaders;
    if (!requiredDefaultHeader) {
      newHeaders = {
        'Content-Type': 'application/json',
      };
    }

    try {
      http.Response? response;

      final client = http.Client();

      final durationTimeOut = Duration(seconds: timeout);

      switch (serviceType) {
        case ServiceType.post:
          response = await client
              .post(uri, body: jsonEncode(body), headers: headers ?? newHeaders)
              .timeout(durationTimeOut);
        case ServiceType.get:
          response = await client
              .get(uri, headers: headers ?? newHeaders)
              .timeout(durationTimeOut);

        case ServiceType.delete:
          response = await client
              .delete(uri,
                  body: body != null ? jsonEncode(body) : null,
                  headers: headers ?? newHeaders)
              .timeout(durationTimeOut);
        case ServiceType.patch:
        case ServiceType.put:
          response = await client
              .put(uri, body: jsonEncode(body), headers: headers ?? newHeaders)
              .timeout(durationTimeOut);
      }

      if (!AppRepo().networkConnectivity) {
        AppRepo().networkConnectivity = true;
      }

      return _responseHandler(
        response,
        () => request(url,
            serviceType: serviceType,
            body: body,
            headers: headers,
            requiredDefaultHeader: requiredDefaultHeader),
        isFile: isFile,
      );
    } on TimeoutException catch (_) {
      // debugPrint('Connection timeout');
      return null;
    } on SocketException catch (_) {
      // debugPrint('socketError: $socketError');
      AppRepo().networkConnectivity = false;
      AppRepo().networkConnectivityStream.add(1);

      return null;
    } catch (error) {
      // debugPrint(error.toString());
      return null;
    }
  }

  Future<dynamic> uploadRequest(
    String url, {
    required String filePath,
    required http_parser.MediaType mediaType,
    Map<String, String>? body,
    Map<String, String>? headers,
    bool requiredDefaultHeader = false,
    bool isFile = false,
  }) async {
    // print('jwtToken ${AppRepo().jwtToken}');
    final uri = Uri.parse(url);

    try {
      http.Response? response;
      final durationTimeOut = Duration(seconds: timeout);
      final client = http.MultipartRequest('POST', uri);

      if (body != null) {
        client.fields.addAll(body);
      }
      if (headers != null) {
        client.headers.addAll(headers);
      } else {
        if (requiredDefaultHeader) {
          client.headers.addAll(defaultHeaders);
        }
      }

      client.files.add(await http.MultipartFile.fromPath('file', filePath,
          contentType: mediaType));

      response = await http.Response.fromStream(
          await client.send().timeout(durationTimeOut));

      return _responseHandler(
        response,
        () => uploadRequest(
          url,
          filePath: filePath,
          mediaType: mediaType,
          body: body,
          headers: headers,
          requiredDefaultHeader: requiredDefaultHeader,
        ),
        isFile: isFile,
      );
    } on TimeoutException catch (_) {
      // debugPrint('Connection timeout');
      return null;
    } on SocketException catch (_) {
      // debugPrint('socketError: $socketError');
      AppRepo().networkConnectivity = false;
      AppRepo().networkConnectivityStream.add(1);

      return null;
    } catch (error) {
      // debugPrint(error.toString());
      return null;
    }
  }

  Future<dynamic> _responseHandler(
    http.Response response,
    Function? originalRequest, {
    bool isFile = false,
  }) async {
    // debugPrint('statusCode : ${response.statusCode}');
    // debugPrint('body : ${response.body}');
    AppRepo().hideLoading();

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (isFile) {
        return response.bodyBytes;
      }
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
      // Success
    } else if (response.statusCode == 405) {
      // Method Not Allowed

      final apiURL = '$baseURL/users';
      if (response.request?.url == Uri.parse('$apiURL/login')) {
        return {'custom-response': ServiceHelperCustomResponse.activateAccount};
      } else {
        return null;
      }
    } else if (response.statusCode == 401) {
      final message = jsonDecode(response.body);
      if (message['message'] is String &&
          message['message'].contains('invalid csrf token')) {
        return null;
      }

      // TODO SH: Attempt token refresh when access token expires
      final updatedUserStr = await request(
        '${AppConfig().baseURL}/users/refresh-token',
        serviceType: ServiceType.post,
        requiredDefaultHeader: false,
        headers: {
          'refresh-token': AppRepo().jwtRefreshToken ?? '',
          'expired-token': AppRepo().jwtToken ?? '',
        },
      );

      // TODO SH: If refresh fails, logout user and route to login
      if (updatedUserStr == null) {
        AppRepo().hideLoading();

        await AppRepo()
            .secureLocalCache
            .write(AppConfig().localSecureCacheKeys.userObject, '');
        await AppRepo()
            .secureLocalCache
            .write(AppConfig().localSecureCacheKeys.jwtToken, '');
        await AppRepo()
            .secureLocalCache
            .write(AppConfig().localSecureCacheKeys.jwtRefreshToken, '');

        AppRepo().localCache.write(
              AppConfig().localCacheKeys.userLoggedInStatus,
              2, // UserStatus.loggedOut
            );

        AppRepo().user = null;
        AppRepo().jwtToken = null;
        AppRepo().jwtRefreshToken = null;
        AppRepo().savedProjectsList.clear();
        AppRepo().updatingProjectsList.clear();
        AppRepo().tags.clear();
        AppRepo().users.clear();

        Get.offAllNamed(AppConfig().routes.externalAuth);
        return null;
      }

      // TODO SH: Validate refresh response contains valid tokens
      final updatedUserObject = User.fromLocalCacheJson(updatedUserStr);

      if (updatedUserObject.token == null ||
          updatedUserObject.token!.isEmpty ||
          updatedUserObject.refreshToken == null ||
          updatedUserObject.refreshToken!.isEmpty) {
        AppRepo().hideLoading();
        await AppRepo()
            .secureLocalCache
            .write(AppConfig().localSecureCacheKeys.userObject, '');
        await AppRepo()
            .secureLocalCache
            .write(AppConfig().localSecureCacheKeys.jwtToken, '');
        await AppRepo()
            .secureLocalCache
            .write(AppConfig().localSecureCacheKeys.jwtRefreshToken, '');
        AppRepo()
            .localCache
            .write(AppConfig().localCacheKeys.userLoggedInStatus, 2);
        AppRepo().user = null;
        AppRepo().jwtToken = null;
        AppRepo().jwtRefreshToken = null;
        AppRepo().savedProjectsList.clear();
        AppRepo().updatingProjectsList.clear();
        AppRepo().tags.clear();
        AppRepo().users.clear();
        Get.offAllNamed(AppConfig().routes.externalAuth);
        return null;
      }

      // TODO SH: Store new tokens in secure storage
      await AppRepo().secureLocalCache.write(
          AppConfig().localSecureCacheKeys.userObject,
          jsonEncode(updatedUserStr));

      await AppRepo().secureLocalCache.write(
          AppConfig().localSecureCacheKeys.jwtToken, updatedUserObject.token);

      await AppRepo().secureLocalCache.write(
          AppConfig().localSecureCacheKeys.jwtRefreshToken,
          updatedUserObject.refreshToken);

      AppRepo().user = updatedUserObject;
      AppRepo().jwtToken = updatedUserObject.token;
      AppRepo().jwtRefreshToken = updatedUserObject.refreshToken;

      return await originalRequest!();
    } else if (response.statusCode == 429) {
      AppRepo()
          .showSnackbar(label: 'Server', text: AppStrings.tooManyRequests.tr);
      return null;
    } else if (response.statusCode == 403) {
      AppRepo().hideLoading();

      final message = jsonDecode(response.body);

      final errorTitle = message['error']?.toString().toLowerCase() ?? '';
      final errorMessage = message['message']?.toString().toLowerCase() ?? '';

      // TODO SH: If 403 is token-related, attempt refresh (backend returns 403 for expired tokens on some endpoints)
      if ((errorTitle.contains('forbidden') &&
              errorMessage.contains('token')) ||
          errorMessage.contains('expired') ||
          errorMessage.contains('token is expired')) {
        final updatedUserStr = await request(
          '${AppConfig().baseURL}/users/refresh-token',
          serviceType: ServiceType.post,
          requiredDefaultHeader: false,
          headers: {
            'refresh-token': AppRepo().jwtRefreshToken ?? '',
            'expired-token': AppRepo().jwtToken ?? '',
          },
        );

        if (updatedUserStr == null) {
          await AppRepo()
              .secureLocalCache
              .write(AppConfig().localSecureCacheKeys.userObject, '');
          await AppRepo()
              .secureLocalCache
              .write(AppConfig().localSecureCacheKeys.jwtToken, '');
          await AppRepo()
              .secureLocalCache
              .write(AppConfig().localSecureCacheKeys.jwtRefreshToken, '');

          AppRepo()
              .localCache
              .write(AppConfig().localCacheKeys.userLoggedInStatus, 2);

          AppRepo().user = null;
          AppRepo().jwtToken = null;
          AppRepo().jwtRefreshToken = null;
          AppRepo().savedProjectsList.clear();
          AppRepo().updatingProjectsList.clear();
          AppRepo().tags.clear();
          AppRepo().users.clear();

          Get.offAllNamed(AppConfig().routes.externalAuth);
          return null;
        }

        final updatedUserObject = User.fromLocalCacheJson(updatedUserStr);

        if (updatedUserObject.token == null ||
            updatedUserObject.token!.isEmpty ||
            updatedUserObject.refreshToken == null ||
            updatedUserObject.refreshToken!.isEmpty) {
          await AppRepo()
              .secureLocalCache
              .write(AppConfig().localSecureCacheKeys.userObject, '');
          await AppRepo()
              .secureLocalCache
              .write(AppConfig().localSecureCacheKeys.jwtToken, '');
          await AppRepo()
              .secureLocalCache
              .write(AppConfig().localSecureCacheKeys.jwtRefreshToken, '');
          AppRepo()
              .localCache
              .write(AppConfig().localCacheKeys.userLoggedInStatus, 2);
          AppRepo().user = null;
          AppRepo().jwtToken = null;
          AppRepo().jwtRefreshToken = null;
          AppRepo().savedProjectsList.clear();
          AppRepo().updatingProjectsList.clear();
          AppRepo().tags.clear();
          AppRepo().users.clear();
          Get.offAllNamed(AppConfig().routes.externalAuth);
          return null;
        }

        await AppRepo().secureLocalCache.write(
            AppConfig().localSecureCacheKeys.userObject,
            jsonEncode(updatedUserStr));

        await AppRepo().secureLocalCache.write(
            AppConfig().localSecureCacheKeys.jwtToken, updatedUserObject.token);

        await AppRepo().secureLocalCache.write(
            AppConfig().localSecureCacheKeys.jwtRefreshToken,
            updatedUserObject.refreshToken);

        AppRepo().user = updatedUserObject;
        AppRepo().jwtToken = updatedUserObject.token;
        AppRepo().jwtRefreshToken = updatedUserObject.refreshToken;

        return await originalRequest!();
      }

      Get.offAll(
        () => UserForbiddenScreen(
          title: message['error'] ?? '',
          caption: message['message'] ?? '',
        ),
      );

      return null;
    } else {
      AppRepo().hideLoading();

      final message = jsonDecode(response.body);

      if (message['message'] is List<dynamic>) {
        AppRepo().showSnackbar(
            label: message['error'] ?? '',
            text: message['message'].join('\n') ?? '');
      } else {
        AppRepo().showSnackbar(
            label: message['error'] ?? '', text: message['message'] ?? '');
      }

      // debugPrint('Error: $message');
      return null;
    }
  }
}
