import 'package:flutter_test/flutter_test.dart';
import 'package:singerapp/features/domain/models/schedule.dart';

void main() {
  group('Schedule', () {
    test('deve criar uma instância corretamente', () {
      final schedule = Schedule(
        id: 1,
        location: 'São Paulo',
        amount: 1000.0,
        isPaid: true,
        showTime: DateTime(2024, 12, 25),
        hasAdditionalMusicians: false,
        additionalMusicianFee: 0.0,
        isSynced: false,
        isDownloaded: true,
      );

      expect(schedule.id, 1);
      expect(schedule.location, 'São Paulo');
      expect(schedule.amount, 1000.0);
      expect(schedule.isPaid, true);
      expect(schedule.showTime, DateTime(2024, 12, 25));
      expect(schedule.hasAdditionalMusicians, false);
      expect(schedule.additionalMusicianFee, 0.0);
      expect(schedule.isSynced, false);
      expect(schedule.isDownloaded, true);
    });

    test('deve converter para Map corretamente', () {
      final schedule = Schedule(
        id: 1,
        location: 'Rio de Janeiro',
        amount: 500.0,
        isPaid: false,
        showTime: DateTime(2024, 11, 10),
        hasAdditionalMusicians: true,
        additionalMusicianFee: 200.0,
        isSynced: true,
        isDownloaded: false,
      );

      final map = schedule.toMap();

      expect(map['id'], 1);
      expect(map['location'], 'Rio de Janeiro');
      expect(map['amount'], 500.0);
      expect(map['isPaid'], 0);
      expect(map['showTime'], '2024-11-10T00:00:00.000');
      expect(map['hasAdditionalMusicians'], 1);
      expect(map['additionalMusicianFee'], 200.0);
      expect(map['isSynced'], 1);
      expect(map['isDownloaded'], 0);
    });

    test('deve criar instância a partir de Map corretamente', () {
      final map = {
        'id': 2,
        'location': 'Brasília',
        'amount': 1500.0,
        'isPaid': 1,
        'showTime': '2024-12-15T20:00:00.000',
        'hasAdditionalMusicians': 0,
        'additionalMusicianFee': 0.0,
        'isSynced': 0,
        'isDownloaded': 1,
      };

      final schedule = Schedule.fromMap(map);

      expect(schedule.id, 2);
      expect(schedule.location, 'Brasília');
      expect(schedule.amount, 1500.0);
      expect(schedule.isPaid, true);
      expect(schedule.showTime, DateTime(2024, 12, 15, 20, 0));
      expect(schedule.hasAdditionalMusicians, false);
      expect(schedule.additionalMusicianFee, 0.0);
      expect(schedule.isSynced, false);
      expect(schedule.isDownloaded, true);
    });

    test('deve criar instância a partir de JSON corretamente', () {
      final json = {
        'id': 3,
        'location': 'Salvador',
        'amount': 750.0,
        'isPaid': 1,
        'showTime': '2024-10-20T18:00:00.000',
        'hasAdditionalMusicians': 1,
        'additionalMusicianFee': 150.0,
        'isSynced': 1,
        'isDownloaded': 1,
      };

      final schedule = Schedule.fromJson(json);

      expect(schedule.id, 3);
      expect(schedule.location, 'Salvador');
      expect(schedule.amount, 750.0);
      expect(schedule.isPaid, true);
      expect(schedule.showTime, DateTime(2024, 10, 20, 18, 0));
      expect(schedule.hasAdditionalMusicians, true);
      expect(schedule.additionalMusicianFee, 150.0);
      expect(schedule.isSynced, true);
      expect(schedule.isDownloaded, true);
    });

    test('deve converter para JSON corretamente', () {
      final schedule = Schedule(
        id: 4,
        location: 'Curitiba',
        amount: 2000.0,
        isPaid: true,
        showTime: DateTime(2024, 12, 31),
        hasAdditionalMusicians: false,
        additionalMusicianFee: 0.0,
        isSynced: true,
        isDownloaded: true,
      );

      final json = schedule.toJson();

      expect(json['id'], 4);
      expect(json['location'], 'Curitiba');
      expect(json['amount'], 2000.0);
      expect(json['isPaid'], 1);
      expect(json['showTime'], '2024-12-31T00:00:00.000');
      expect(json['hasAdditionalMusicians'], 0);
      expect(json['additionalMusicianFee'], 0.0);
      expect(json['isSynced'], 1);
      expect(json['isDownloaded'], 1);
    });

    test('deve criar uma cópia com copyWith corretamente', () {
      final schedule = Schedule(
        id: 5,
        location: 'Florianópolis',
        amount: 1200.0,
        isPaid: false,
        showTime: DateTime(2024, 12, 5),
        hasAdditionalMusicians: true,
        additionalMusicianFee: 300.0,
        isSynced: false,
        isDownloaded: false,
      );

      final updatedSchedule = schedule.copyWith(amount: 1500.0, isPaid: true);

      expect(updatedSchedule.id, 5);
      expect(updatedSchedule.location, 'Florianópolis');
      expect(updatedSchedule.amount, 1500.0);
      expect(updatedSchedule.isPaid, true);
      expect(updatedSchedule.showTime, DateTime(2024, 12, 5));
      expect(updatedSchedule.hasAdditionalMusicians, true);
      expect(updatedSchedule.additionalMusicianFee, 300.0);
      expect(updatedSchedule.isSynced, false);
      expect(updatedSchedule.isDownloaded, false);
    });
  });
}
