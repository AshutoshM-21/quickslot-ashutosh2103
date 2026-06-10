import 'package:dio/dio.dart';
import 'package:quickslot_app/core/network/api_client.dart';
import 'package:quickslot_app/features/venues/data/models/venue_model.dart';
import 'package:quickslot_app/features/venues/domain/entities/venue.dart';

class VenueRepository {
  VenueRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<Venue>> getVenues() async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>('/venues');
      final body = response.data;

      if (body == null || body['success'] != true) {
        throw Exception(
          body?['message'] as String? ?? 'Failed to fetch venues',
        );
      }

      final data = body['data'] as List<dynamic>? ?? [];

      return data
          .map(
            (item) => VenueModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (error) {
      throw Exception(_mapDioError(error));
    }
  }

  String _mapDioError(DioException error) {
    final responseData = error.response?.data;
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'Unable to connect. Check your internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
