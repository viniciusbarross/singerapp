import 'package:equatable/equatable.dart';

class Schedule extends Equatable {
  final int? id;
  final String location;
  final double amount;
  final bool isPaid;
  final DateTime showTime;
  final bool hasAdditionalMusicians;
  final double additionalMusicianFee;
  final bool isSynced;
  final bool isDownloaded;

  const Schedule({
    this.id,
    required this.location,
    required this.amount,
    required this.isPaid,
    required this.showTime,
    required this.hasAdditionalMusicians,
    required this.additionalMusicianFee,
    this.isDownloaded = false,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'location': location,
      'amount': amount,
      'isPaid': isPaid ? 1 : 0,
      'showTime': showTime.toIso8601String(),
      'hasAdditionalMusicians': hasAdditionalMusicians ? 1 : 0,
      'additionalMusicianFee': additionalMusicianFee,
      'isSynced': isSynced ? 1 : 0,
      'isDownloaded': isDownloaded ? 1 : 0,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'],
      location: map['location'],
      amount: map['amount'],
      isPaid: map['isPaid'] == 1,
      showTime: DateTime.parse(map['showTime']),
      hasAdditionalMusicians: map['hasAdditionalMusicians'] == 1,
      additionalMusicianFee: map['additionalMusicianFee'],
      isSynced: map['isSynced'] == 1,
      isDownloaded: map['isDownloaded'] == 1,
    );
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      location: json['location'],
      amount: (json['amount'] ?? 0 as num).toDouble(),
      isPaid: json['isPaid'] == 1,
      showTime: DateTime.parse(json['showTime'] ?? 0),
      hasAdditionalMusicians: json['hasAdditionalMusicians'] == 1,
      additionalMusicianFee:
          (json['additionalMusicianFee'] ?? 0 as num).toDouble(),
      isSynced: json['isSynced'] == 1,
      isDownloaded: json['isDownloaded'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'amount': amount,
      'isPaid': isPaid ? 1 : 0,
      'showTime': showTime.toIso8601String(),
      'hasAdditionalMusicians': hasAdditionalMusicians ? 1 : 0,
      'additionalMusicianFee': additionalMusicianFee,
      'isSynced': isSynced ? 1 : 0,
      'isDownloaded': isDownloaded ? 1 : 0,
    };
  }

  @override
  List<Object?> get props => [
        id,
        location,
        amount,
        isPaid,
        showTime,
        hasAdditionalMusicians,
        additionalMusicianFee,
        isSynced,
        isDownloaded,
      ];

  Schedule copyWith({
    int? id,
    String? location,
    double? amount,
    bool? isPaid,
    DateTime? showTime,
    bool? hasAdditionalMusicians,
    double? additionalMusicianFee,
    bool? isSynced,
    bool? isDownloaded,
  }) {
    return Schedule(
      id: id ?? this.id,
      location: location ?? this.location,
      amount: amount ?? this.amount,
      isPaid: isPaid ?? this.isPaid,
      showTime: showTime ?? this.showTime,
      hasAdditionalMusicians:
          hasAdditionalMusicians ?? this.hasAdditionalMusicians,
      additionalMusicianFee:
          additionalMusicianFee ?? this.additionalMusicianFee,
      isSynced: isSynced ?? this.isSynced,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}
