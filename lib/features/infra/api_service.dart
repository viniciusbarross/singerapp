import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:singerapp/core/constraints.dart';
import 'package:singerapp/features/domain/models/schedule.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: urlDevelopment)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("/schedules")
  Future<Schedule> createSchedule(@Body() Schedule schedule);

  @GET("/schedules")
  Future<List<Schedule>> getSchedules();

  @DELETE("/schedules/{id}")
  Future<void> deleteSchedule(@Path("id") int id);
}
