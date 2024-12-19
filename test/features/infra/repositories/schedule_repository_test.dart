import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:singerapp/features/domain/models/schedule.dart';
import 'package:singerapp/features/infra/exceptions/schedule_exceptions.dart';
import 'package:singerapp/features/infra/repositories/schedule_repository.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockScheduleDatabase mockDatabase;
  late MockApiService mockApiService;
  late ScheduleRepository repository;

  setUp(() {
    mockDatabase = MockScheduleDatabase();
    mockApiService = MockApiService();
    repository = ScheduleRepository(mockDatabase, mockApiService);
  });

  group('saveSchedule', () {
    test('Deve lançar SyncException ao falhar na sincronização remota',
        () async {
      final schedule = Schedule(
        location: 'Test Location',
        amount: 100.0,
        isPaid: true,
        showTime: DateTime.now(),
        hasAdditionalMusicians: false,
        additionalMusicianFee: 0.0,
      );

      when(mockDatabase.create(schedule)).thenAnswer((_) async => 1);
      when(mockApiService.createSchedule(schedule))
          .thenThrow(Exception('Erro na API'));

      expect(() => repository.saveSchedule(schedule),
          throwsA(isA<SyncException>()));
      verify(mockDatabase.create(schedule)).called(1);
    });
  });

  group('getSchedules', () {
    test('Deve buscar os agendamentos da API se disponíveis', () async {
      final schedules = [
        Schedule(
          location: 'API Location',
          amount: 200.0,
          isPaid: false,
          showTime: DateTime.now(),
          hasAdditionalMusicians: true,
          additionalMusicianFee: 50.0,
        ),
      ];

      when(mockApiService.getSchedules()).thenAnswer((_) async => schedules);

      final result = await repository.getSchedules();

      expect(result, equals(schedules));
      verify(mockApiService.getSchedules()).called(1);
    });

    test('Deve buscar agendamentos locais se API falhar', () async {
      final schedules = [
        Schedule(
          location: 'Local Location',
          amount: 150.0,
          isPaid: true,
          showTime: DateTime.now(),
          hasAdditionalMusicians: false,
          additionalMusicianFee: 0.0,
        ),
      ];

      when(mockApiService.getSchedules()).thenThrow(Exception('Erro na API'));
      when(mockDatabase.readAll()).thenAnswer((_) async => schedules);

      final result = await repository.getSchedules();

      expect(result, equals(schedules));
      verify(mockDatabase.readAll()).called(1);
    });
  });

  group('deleteSchedule', () {
    test('Deve deletar localmente e sincronizar com sucesso', () async {
      const id = 1;

      when(mockDatabase.delete(id)).thenAnswer((_) async => 1);
      when(mockApiService.deleteSchedule(id)).thenAnswer((_) async => {});

      await repository.deleteSchedule(id);

      verify(mockDatabase.delete(id)).called(1);
      verify(mockApiService.deleteSchedule(id)).called(1);
    });

    test('Deve lançar SyncException ao falhar na sincronização de exclusão',
        () async {
      const id = 1;

      when(mockDatabase.delete(id)).thenAnswer((_) async => 1);
      when(mockApiService.deleteSchedule(id))
          .thenThrow(Exception('Erro na API'));

      expect(
          () => repository.deleteSchedule(id), throwsA(isA<SyncException>()));
      verify(mockDatabase.delete(id)).called(1);
    });
  });
}
