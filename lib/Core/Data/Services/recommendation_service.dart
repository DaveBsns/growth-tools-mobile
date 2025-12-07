import 'package:idealize_new_version/Core/Data/Models/recommendation_response_model.dart';
import 'package:idealize_new_version/Core/Utils/enums.dart';
import './services_helper.dart';

class RecommendationService extends ServicesHelper {
  /// Fetches "For You" recommendations using content-based filtering
  ///
  /// Algorithm: Content-based filtering using:
  /// - Tag matching (50% weight)
  /// - Course matching (30% weight)
  /// - Recency score (20% weight)
  Future<RecommendationResponse?> fetchForYouRecommendations({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    Map<String, dynamic> queryParameters = {
      'id': userId,
      'page': page,
      'limit': limit,
    };

    final query = queryMaker(queryParameters);

    final mappedData = await request(
      '$baseURL/recommendations/for-you$query',
      serviceType: ServiceType.get,
      requiredDefaultHeader: true,
    );

    if (mappedData != null) {
      return RecommendationResponse.fromJson(mappedData);
    }

    return null;
  }

  /// Fetches basic filtered recommendations
  ///
  /// Algorithm: Simple filtering returning projects that match
  /// user's interested tags OR courses sorted by most recent
  Future<RecommendationResponse?> fetchBasicRecommendations({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    Map<String, dynamic> queryParameters = {
      'id': userId,
      'page': page,
      'limit': limit,
    };

    final query = queryMaker(queryParameters);

    final mappedData = await request(
      '$baseURL/recommendations/basic$query',
      serviceType: ServiceType.get,
      requiredDefaultHeader: true,
    );

    if (mappedData != null) {
      return RecommendationResponse.fromJson(mappedData);
    }

    return null;
  }

  /// Fetches hybrid recommendations
  ///
  /// Algorithm: Combines:
  /// - Content-based filtering (70% weight)
  /// - Popularity based on likes (30% weight)
  Future<RecommendationResponse?> fetchHybridRecommendations({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    Map<String, dynamic> queryParameters = {
      'id': userId,
      'page': page,
      'limit': limit,
    };

    final query = queryMaker(queryParameters);

    final mappedData = await request(
      '$baseURL/recommendations/hybrid$query',
      serviceType: ServiceType.get,
      requiredDefaultHeader: true,
    );

    if (mappedData != null) {
      return RecommendationResponse.fromJson(mappedData);
    }

    return null;
  }
}
