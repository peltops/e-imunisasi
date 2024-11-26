import 'package:eimunisasi/features/health_worker/data/models/health_worker_model.dart';
import 'package:equatable/equatable.dart';

class ClinicModel extends Equatable {
  final String? id, name, address, motto, phoneNumber;
  final List<String>? photos;
  final List<Schedule> schedules;

  const ClinicModel({
    this.id,
    this.name,
    this.address,
    this.motto,
    this.phoneNumber,
    this.photos,
    this.schedules = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        motto,
        phoneNumber,
        photos,
        schedules,
      ];

  factory ClinicModel.fromSeribase(Map<String, dynamic> data) {
    return ClinicModel(
      id: data['id'],
      name: data['name'],
      address: data['address'],
      motto: data['motto'],
      phoneNumber: data['phone_number'],
      photos: () {
        if (data['photos'] == null) {
          return null;
        }
        try {
          return List<String>.from(data['photos']);
        } catch (e) {
          return null;
        }
      }(),
      schedules: () {
        try {
          return List<Schedule>.from(
              data['clinic_schedules'].map((x) => Schedule.fromSeribase(x)),
          );
        } catch (e) {
          return <Schedule>[];
        }
      }(),
    );
  }

  Map<String, dynamic> toSeribase() {
    return {
      if (id != null) "id": id,
      if (name != null) "name": name,
      if (address != null) "address": address,
      if (motto != null) "motto": motto,
      if (phoneNumber != null) "phone_number": phoneNumber,
      if (photos != null) "photos": photos,
    };
  }
}
