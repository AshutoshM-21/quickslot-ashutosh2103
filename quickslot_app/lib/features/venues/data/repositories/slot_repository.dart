import 'package:dio/dio.dart';
import 'package:quickslot_app/core/network/api_client.dart';
import 'package:quickslot_app/core/utils/date_utils.dart';
import 'package:quickslot_app/features/venues/data/models/slot_model.dart';
import 'package:quickslot_app/features/venues/domain/entities/slot.dart';

class SlotRepository {
  SlotRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<Slot>> getSlots({
    required int venueId,
    required DateTime date,
    String? sport,
  }) async {
    try {
      final response = await _apiClient.dio.get<Map<String, dynamic>>(
        '/venues/$venueId/slots',
        queryParameters: {
          'date': DateUtils.formatForApi(date),
          if (sport != null && sport.isNotEmpty) 'sport': sport,
        },
      );
      final body = response.data;

      if (body == null || body['success'] != true) {
        throw Exception(
          body?['message'] as String? ?? 'Failed to fetch slots',
        );
      }

      final data = body['data'] as List<dynamic>? ?? [];

      return data
          .map(
            (item) => SlotModel.fromJson(item as Map<String, dynamic>),
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
