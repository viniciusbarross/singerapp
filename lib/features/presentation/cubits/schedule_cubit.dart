import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:singerapp/features/domain/models/schedule.dart';
import 'package:singerapp/features/infra/exceptions/schedule_exceptions.dart';
import 'package:singerapp/features/infra/repositories/schedule_repository.dart';

part 'states/schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository scheduleRepository;

  ScheduleCubit(this.scheduleRepository) : super(ScheduleInitial());

  Future<void> loadSchedules() async {
    emit(ScheduleLoading());
    try {
      final schedules = await scheduleRepository.getSchedules();
      emit(ScheduleLoaded(schedules));
    } catch (e) {
      emit(const ScheduleError('Erro ao carregar agendamentos.'));
    }
  }

  Future<void> syncSchedules() async {
    emit(ScheduleLoading());
    try {
      await scheduleRepository.syncSchedules();

      emit(const ScheduleSynced());
    } catch (e) {
      emit(const ScheduleError('Erro ao sincronizar agendamentos.'));
    }
  }

  Future<void> addSchedule(Schedule schedule) async {
    emit(ScheduleLoading());
    try {
      final existingSchedules = await scheduleRepository.getSchedules();
      final conflict = existingSchedules.any(
        (s) => s.showTime == schedule.showTime,
      );

      if (conflict) {
        emit(const ScheduleConflictError(
            'Já existe um agendamento para este horário.'));
        return;
      }

      await scheduleRepository.saveSchedule(schedule);
      emit(const ScheduleSyncSuccess(
          'Agendamento salvo localmente e sincronizado.'));
      await loadSchedules();
    } on LocalSaveException catch (e) {
      emit(ScheduleError(e.message));
    } on SyncException catch (e) {
      emit(ScheduleSyncError(e.message));
      await loadSchedules();
    } catch (e) {
      emit(const ScheduleError('Erro ao adicionar agendamento.'));
    }
  }

  Future<void> deleteSchedule(int id) async {
    emit(ScheduleLoading());
    try {
      await scheduleRepository.deleteSchedule(id);
      emit(const ScheduleSyncSuccess(
          'Agendamento excluído localmente e sincronizado.'));
      await loadSchedules();
    } on LocalDeleteException catch (e) {
      emit(ScheduleError(e.message));
    } on SyncException catch (e) {
      emit(ScheduleSyncError(e.message));
    } catch (e) {
      emit(const ScheduleError('Erro ao excluir agendamento.'));
    }
  }
}
