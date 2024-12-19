import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:singerapp/features/presentation/cubits/background_cubit.dart';
import 'package:singerapp/features/presentation/cubits/schedule_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleCubit = context.read<ScheduleCubit>();
    scheduleCubit.syncSchedules();
    return Scaffold(
      appBar: AppBar(
        title: const Text('SingerApp'),
      ),
      body: Stack(
        children: [
          BlocBuilder<BackgroundCubit, File?>(
            builder: (context, backgroundImage) {
              if (backgroundImage != null) {
                return Opacity(
                  opacity: 0.3,
                  child: Image.file(
                    backgroundImage,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/create-schedule');
                    },
                    child: const Text('Criar Agendamento'),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/list-schedules');
                    },
                    child: const Text('Lista de Agendamentos'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/settings');
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
}
