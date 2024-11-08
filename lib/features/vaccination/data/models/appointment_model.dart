import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:eimunisasi/models/nakes.dart';
import 'package:eimunisasi/features/authentication/data/models/user.dart';
import 'package:equatable/equatable.dart';

class AppointmentModel extends Equatable {
  final String? id;
  final DateTime? date;
  final Anak? child;
  final Users? parent;
  final Nakes? healthWorker;
  final String? purpose;
  final String? note;

  const AppointmentModel({
    this.id,
    this.date,
    this.child,
    this.parent,
    this.healthWorker,
    this.note,
    this.purpose,
  });

  static const String tableName = 'appointments';

  AppointmentModel copyWith({
    String? id,
    DateTime? date,
    Anak? child,
    Users? parent,
    Nakes? healthWorker,
    String? note,
    String? purpose,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      date: date ?? this.date,
      child: child ?? this.child,
      parent: parent ?? this.parent,
      healthWorker: healthWorker ?? this.healthWorker,
      note: note ?? this.note,
      purpose: purpose ?? this.purpose,
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
      note: map['note'],
      purpose: map['purpose'],
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
    };
  }
}
