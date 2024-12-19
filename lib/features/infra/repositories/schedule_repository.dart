import 'dart:async';
import 'package:flutter/material.dart';
import 'package:singerapp/features/data/datasources/schedule_datasource.dart';
import 'package:singerapp/features/domain/models/schedule.dart';
import 'package:singerapp/features/infra/api_service.dart';
import 'package:singerapp/features/infra/exceptions/schedule_exceptions.dart';

class ScheduleRepository {
  final ScheduleDatabase _scheduleDatabase;
  final ApiService _apiService;

  ScheduleRepository(this._scheduleDatabase, this._apiService);

  Future<void> saveSchedule(Schedule schedule) async {
    bool localSuccess = false;
    try {
      await _scheduleDatabase.create(schedule);
      localSuccess = true;
    } catch (e) {
      throw LocalSaveException('Erro ao salvar agendamento localmente: $e');
    }

    try {
      await _apiService.createSchedule(schedule);
    } catch (e) {
      if (localSuccess) {
        throw SyncException('Erro ao sincronizar com o servidor: $e');
      }
    }
  }

  Future<List<Schedule>> getSchedules() async {
    try {
      List<Schedule> schedules;
      schedules = await _apiService.getSchedules();

      if (schedules.isEmpty) {
        schedules = await _scheduleDatabase.readAll();
      }

      return schedules;
    } catch (e) {
      return await _scheduleDatabase.readAll();
    }
  }

  Future<void> deleteSchedule(int id) async {
    bool localSuccess = false;
    try {
      await _scheduleDatabase.delete(id);
      localSuccess = true;
    } catch (e) {
      throw LocalDeleteException('Erro ao deletar agendamento localmente: $e');
    }

    try {
      await _apiService.deleteSchedule(id);
    } catch (e) {
      if (localSuccess) {
        throw SyncException('Erro ao sincronizar exclusão com o servidor: $e');
      }
    }
  }

  Future<void> syncSchedules() async {
    try {
      final unsyncedSchedules = await _scheduleDatabase.getUnsyncedSchedules();
      for (var schedule in unsyncedSchedules) {
        try {
          await _apiService.createSchedule(schedule);
          await _scheduleDatabase.update(schedule.copyWith(isSynced: true));
        } catch (e) {
          debugPrint('Erro ao sincronizar agendamento ${schedule.id}: $e');
        }
      }

      final remoteSchedules = await _apiService.getSchedules();
      for (var schedule in remoteSchedules) {
        final existsLocally = await _scheduleDatabase.exists(schedule.id!);

        if (!existsLocally) {
          await _scheduleDatabase.create(
            schedule.copyWith(isDownloaded: true),
          );
        } else {
          final localSchedule = await _scheduleDatabase.getById(schedule.id!);
          if (localSchedule != schedule) {
            await _scheduleDatabase.update(
              schedule.copyWith(isDownloaded: true),
            );
          }
        }
      }
    } catch (e) {
      throw SyncException('Erro na sincronização: $e');
    }
  }
}
