import 'package:equatable/equatable.dart';

class ClinicModel extends Equatable {
  final String? id, name, address, motto, phoneNumber;
  final List<String>? photos;

  const ClinicModel({
    this.id,
    this.name,
    this.address,
    this.motto,
    this.phoneNumber,
    this.photos,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        motto,
        phoneNumber,
        photos,
      ];

  factory ClinicModel.fromSeribase(Map<String, dynamic> data) {
    return ClinicModel(
      id: data['id'],
      name: data['name'],
      address: data['address'],
      motto: data['motto'],
      phoneNumber: data['phone_number'],
      photos: List<String>.from(data['photos']),
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
