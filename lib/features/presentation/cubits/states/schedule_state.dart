part of '../schedule_cubit.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<Schedule> schedules;

  const ScheduleLoaded(this.schedules);

  ScheduleLoaded copyWith({List<Schedule>? schedules}) {
    return ScheduleLoaded(schedules ?? this.schedules);
  }

  @override
  List<Object?> get props => [schedules];
}

class ScheduleSynced extends ScheduleState {
  const ScheduleSynced();
}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError(this.message);

  @override
  List<Object?> get props => [message];
}

class ScheduleConflictError extends ScheduleState {
  final String message;

  const ScheduleConflictError(this.message);

  @override
  List<Object?> get props => [message];
}

class ScheduleSyncSuccess extends ScheduleState {
  final String message;

  const ScheduleSyncSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ScheduleSyncError extends ScheduleState {
  final String message;

  const ScheduleSyncError(this.message);

  @override
  List<Object?> get props => [message];
}
