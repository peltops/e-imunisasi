import 'package:eimunisasi/core/extension.dart';
import 'package:eimunisasi/features/health_worker/data/models/clinic_model.dart';
import 'package:equatable/equatable.dart';

class HealthWorkerModel extends Equatable {
  final String? id;
  final ClinicModel? clinic;
  final String? email;
  final List<Schedule>? schedules;
  final List<Schedule>? practiceSchedules;
  final String? kartuKeluarga;
  final String? fullName;
  final String? nik;
  final String? phoneNumber;
  final String? photoURL;
  final String? profession;
  final DateTime? date_of_birth;
  final String? place_of_date;
  final String? bookingFee;

  const HealthWorkerModel({
    this.id,
    this.clinic,
    this.email,
    this.schedules,
    this.practiceSchedules,
    this.kartuKeluarga,
    this.fullName,
    this.nik,
    this.phoneNumber,
    this.photoURL,
    this.profession,
    this.date_of_birth,
    this.place_of_date,
    this.bookingFee,
  });

  factory HealthWorkerModel.fromSeribase(Map<String, dynamic> data) {
    return HealthWorkerModel(
      id: data['id'],
      clinic: () {
        try {
          return ClinicModel.fromSeribase(data['clinic']);
        } catch (e) {
          return null;
        }
      }(),
      email: data['email'],
      schedules: () {
        try {
          return (data['schedule'] as List? ?? [])
              .map((e) => Schedule.fromSeribase(e))
              .toList();
        } catch (e) {
          return <Schedule>[];
        }
      }(),
      practiceSchedules: () {
        try {
          return (data['practice_schedules'] as List? ?? [])
              .map((e) => Schedule.fromSeribase(e))
              .toList();
        } catch (e) {
          return <Schedule>[];
        }
      }(),
      kartuKeluarga: data['no_kartu_keluarga'],
      fullName: data['full_name'],
      nik: data['no_induk_kependudukan'],
      phoneNumber: data['phone_number'],
      photoURL: data['avatar_url'],
      profession: data['profession'],
      date_of_birth: () {
        try {
          return DateTime.parse(data['date_of_birth']);
        } catch (e) {
          return null;
        }
      }(),
      place_of_date: data['place_of_birth'],
      bookingFee: data['booking_fee'].toString(),
    );
  }

  Map<String, dynamic> toSeribase() {
    return {
      if (id != null) "id": id,
      if (clinic != null) "clinic": clinic!.toSeribase(),
      if (email != null) "email": email,
      if (schedules != null)
        "schedule": schedules!.map((e) => e.toSeribase()).toList(),
      if (practiceSchedules != null)
        "practice_schedules":
            practiceSchedules!.map((e) => e.toSeribase()).toList(),
      if (kartuKeluarga != null) "no_kartu_keluarga": kartuKeluarga,
      if (fullName != null) "full_name": fullName,
      if (nik != null) "no_induk_kependudukan": nik,
      if (phoneNumber != null) "phone_number": phoneNumber,
      if (photoURL != null) "avatar_url": photoURL,
      if (profession != null) "profession": profession,
      if (date_of_birth != null)
        "date_of_birth": date_of_birth?.toIso8601String(),
      if (place_of_date != null) "place_of_birth": place_of_date,
    };
  }

  @override
  List<Object?> get props => [
        id,
        clinic,
        email,
        schedules,
        practiceSchedules,
        kartuKeluarga,
        fullName,
        nik,
        phoneNumber,
        photoURL,
        profession,
        date_of_birth,
        place_of_date,
        bookingFee,
      ];
}

class Schedule extends Equatable {
  final Day? day;
  final String? startTime;
  final String? endTime;

  const Schedule({
    this.day,
    this.startTime,
    this.endTime,
  });

  String get time => () {
        if (startTime != null && endTime != null) {
          final startTime = this.startTime?.split(":").getRange(0, 2).join(":");
          final endTime = this.endTime?.split(":").getRange(0, 2).join(":");
          return "$startTime - $endTime";
        }
        return emptyString;
      }();

  factory Schedule.fromSeribase(Map<String, dynamic> data) {
    return Schedule(
      day: Day.fromSeribase(data['day']),
      startTime: data['start_time'],
      endTime: data['end_time'],
    );
  }

  Map<String, dynamic> toSeribase() {
    return {
      "day_id": day?.id,
      "start_time": startTime,
      "end_time": endTime,
    };
  }

  @override
  List<Object?> get props => [day, startTime, endTime];
}

class Day extends Equatable {
  final int? id;
  final String? name;

  const Day({
    this.id,
    this.name,
  });

  factory Day.fromSeribase(Map<String, dynamic> data) {
    return Day(
      id: data['id'],
      name: data['name'],
    );
  }

  Map<String, dynamic> toSeribase() {
    return {
      "id": id,
      "name": name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}
