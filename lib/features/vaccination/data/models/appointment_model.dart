import 'package:eimunisasi/features/health_worker/data/models/health_worker_model.dart';
import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:eimunisasi/features/authentication/data/models/user.dart';
import 'package:equatable/equatable.dart';

class AppointmentModel extends Equatable {
  final String? id;
  final DateTime? date;
  final Anak? child;
  final Users? parent;
  final HealthWorkerModel? healthWorker;
  final String? purpose;
  final String? note;
  final String? startTime;
  final String? endTime;


  const AppointmentModel({
    this.id,
    this.date,
    this.child,
    this.parent,
    this.healthWorker,
    this.note,
    this.purpose,
    this.startTime,
    this.endTime,
  });

  static const String tableName = 'appointments';

  AppointmentModel copyWith({
    String? id,
    DateTime? date,
    Anak? child,
    Users? parent,
    HealthWorkerModel? healthWorker,
    String? note,
    String? purpose,
    String? startTime,
    String? endTime,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      date: date ?? this.date,
      child: child ?? this.child,
      parent: parent ?? this.parent,
      healthWorker: healthWorker ?? this.healthWorker,
      note: note ?? this.note,
      purpose: purpose ?? this.purpose,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  List<Object?> get props => [
        id,
        date,
        child,
        parent,
        healthWorker,
        note,
        purpose,
        startTime,
        endTime,
      ];

  factory AppointmentModel.fromSeribase(
    Map<String, dynamic> map,
  ) {
    return AppointmentModel(
      id: map['id'],
      date: () {
        try {
          if (map['date'] == null) return null;
          return DateTime.parse(map['date']);
        } catch (e) {
          return null;
        }
      }(),
      child: map['children'] != null
          ? Anak.fromSeribase(map['children'])
          : null,
      parent: map['profiles'] != null
          ? Users.fromSeribase(map['profiles'])
          : null,
      note: map['note'],
      purpose: map['purpose'],
      healthWorker: map['health_worker'] != null
          ? HealthWorkerModel.fromSeribase(map['health_worker'])
          : null,
      startTime: map['start_time'],
      endTime: map['end_time'],
    );
  }

  Map<String, dynamic> toSeribase() {
    return {
      if (id != null) 'id': id,
      if (parent != null) 'parent_id': parent?.uid,
      if (child != null) 'child_id': child?.id,
      if (healthWorker != null) 'inspector_id': healthWorker?.id,
      if (date != null) 'date': date?.toIso8601String(),
      if (note != null) 'note': note,
      if (purpose != null) 'purpose': purpose,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
    };
  }
}
