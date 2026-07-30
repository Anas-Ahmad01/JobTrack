import 'package:dio/dio.dart';
import 'dio_client.dart';

class ArbeitnowService {
  final Dio _dio;

  ArbeitnowService() : _dio = DioClient().dio;

  Future<List<Map<String , dynamic>>> fetchJobs() async{
    try{
      final response = await _dio.get('/job-board-api');
      final data = response.data as Map<String ,dynamic>;
      final jobs = data['data'] as List<dynamic>? ?? [];
      return jobs.cast<Map<String,dynamic>>();
    } on DioException catch (e){
      throw _handleError(e);
    }
  }
 
  Future<List<Map<String,dynamic>>> searchJobs(String query) async{
    try{
      final response = await _dio.get(
        '/job-board-api',
        queryParameters: {'search': query},
      );

      final data = response.data as Map<String, dynamic>;
      final jobs = data['data'] as List<dynamic>? ?? [];
      return jobs.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        return 'Server error. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}