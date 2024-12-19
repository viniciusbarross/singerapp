import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:singerapp/core/services/local_storage_service.dart';
import 'package:singerapp/features/data/datasources/schedule_datasource.dart';
import 'package:singerapp/features/infra/api_service.dart';
import 'package:singerapp/features/infra/repositories/schedule_repository.dart';
import 'package:singerapp/features/presentation/cubits/background_cubit.dart';
import 'package:singerapp/features/presentation/cubits/schedule_cubit.dart';
import 'package:singerapp/features/presentation/screen/home_screen.dart';
import 'package:singerapp/features/presentation/screen/create_schedule_screen.dart';
import 'package:singerapp/features/presentation/screen/list_schedule_screen.dart';
import 'package:singerapp/features/presentation/screen/settings_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalStorageService localStorageService = LocalStorageService();
    final dio = Dio(
      BaseOptions(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    final ScheduleRepository scheduleRepository =
        ScheduleRepository(ScheduleDatabase.instance, ApiService(dio));
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              BackgroundCubit(localStorageService)..loadBackgroundImage(),
        ),
        BlocProvider(
          create: (_) => ScheduleCubit(scheduleRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Gerenciamento de Shows',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.black,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/create-schedule': (context) => const CreateScheduleScreen(),
          '/list-schedules': (context) => const ListSchedulesScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
