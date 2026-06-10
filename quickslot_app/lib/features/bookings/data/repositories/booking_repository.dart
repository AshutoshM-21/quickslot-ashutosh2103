import 'package:dio/dio.dart';
import 'package:quickslot_app/core/network/api_client.dart';
import 'package:quickslot_app/features/bookings/data/models/booking_model.dart';
import 'package:quickslot_app/features/bookings/domain/entities/booking.dart';

class BookingRepository {
  BookingRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Booking> createBooking({
    required int slotId,
    required int userId,
  }) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/bookings',
        data: {'slotId': slotId},
        options: Options(
          headers: {'X-User-Id': userId.toString()},
        ),
      );
      final body = response.data;

      if (body == null || body['success'] != true) {
        throw Exception(
          body?['message'] as String? ?? 'Booking failed',
        );
      }

      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Booking failed');
      }

      return BookingModel.fromJson(data);
    } on DioException catch (error) {
      throw Exception(_mapDioError(error));
    }
  }

  Future<void> cancelBooking({required int bookingId}) async {
    try {
      final response = await _apiClient.dio.delete<Map<String, dynamic>>(
        '/bookings/$bookingId',
      );
      final body = response.data;

      if (body == null || body['success'] != true) {
        throw Exception(
          body?['message'] as String? ?? 'Cancellation failed',
        );
      }
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
