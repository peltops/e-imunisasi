import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/utils/datetime_extension.dart';
import 'package:equatable/equatable.dart';

class Anak extends Equatable {
  final String? id;
  final String? parentId;
  final String? nama;
  final String? nik;
  final String? tempatLahir;
  final DateTime? tanggalLahir;
  final String? jenisKelamin;
  final String? golDarah;
  final String? photoURL;

  String get umurAnak {
    if (this.tanggalLahir.isNull) return 'Umur belum diisi';

    final diff = DateTime.now().difference(this.tanggalLahir.orNow);
    final years = diff.inDays / 365;
    final months = (diff.inDays % 365) / 30;
    return '${years.floor()} tahun, ${months.floor()} bulan';
  }

  Anak({
    this.id,
    this.parentId,
    this.nik,
    this.tempatLahir,
    this.jenisKelamin,
    this.golDarah,
    this.nama,
    this.tanggalLahir,
    this.photoURL,
  });

  factory Anak.fromMap(Map data) {
    return Anak(
      id: data['id'],
      parentId: data['parent_id'],
      nama: data['nama'],
      nik: data['nik'] ?? '',
      tempatLahir: data['tempat_lahir'] ?? '',
      // timestamp to date
      tanggalLahir: data['tanggal_lahir'] != null
          ? (data['tanggal_lahir'] as Timestamp).toDate()
          : null,
      jenisKelamin: data['jenis_kelamin'] ?? '',
      golDarah: data['gol_darah'] ?? '',
      photoURL: data['photo_url'] ?? '',
    );
  }

  factory Anak.fromSeribase(Map<String, dynamic> data) {
    return Anak(
      id: data['id'],
      parentId: data['parent_id'],
      nama: data['name'],
      nik: data['nik'] ?? '',
      tempatLahir: data['place_of_birth'] ?? '',
      tanggalLahir: () {
        try {
          return DateTime.parse(data['date_of_birth']);
        } catch (e) {
          return null;
        }
      }(),
      jenisKelamin: data['gender'] ?? '',
      golDarah: data['blood_type'] ?? '',
      photoURL: data['avatar_url'] ?? '',
    );
  }

  factory Anak.empty() {
    return Anak(
      id: '',
      parentId: '',
      nama: '',
      nik: '',
      tempatLahir: '',
      tanggalLahir: null,
      jenisKelamin: '',
      golDarah: '',
      photoURL: '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parent_id': parentId,
      "nama": nama,
      "nik": nik,
      "tempat_lahir": tempatLahir,
      "tanggal_lahir": tanggalLahir,
      "jenis_kelamin": jenisKelamin,
      "gol_darah": golDarah,
      "photo_url": photoURL,
    };
  }

  Map<String, dynamic> toSeribaseMap() {
    return {
      if (parentId?.isNotEmpty ?? false) 'parent_id': parentId,
      if (nama?.isNotEmpty ?? false) 'name': nama,
      if (nik?.isNotEmpty ?? false) 'nik': nik,
      if (tempatLahir?.isNotEmpty ?? false) 'place_of_birth': tempatLahir,
      if (tanggalLahir != null)
        'date_of_birth': tanggalLahir?.toIso8601String(),
      if (jenisKelamin?.isNotEmpty ?? false) 'gender': jenisKelamin,
      if (golDarah?.isNotEmpty ?? false) 'blood_type': golDarah,
      if (photoURL?.isNotEmpty ?? false) 'avatar_url': photoURL,
    };
  }

  Anak copyWith({
    String? id,
    String? parentId,
    String? nama,
    String? nik,
    String? tempatLahir,
    DateTime? tanggalLahir,
    String? jenisKelamin,
    String? golDarah,
    String? photoURL,
  }) {
    return Anak(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      golDarah: golDarah ?? this.golDarah,
      photoURL: photoURL ?? this.photoURL,
    );
  }

  @override
  List<Object?> get props => [
        id,
        parentId,
        nama,
        nik,
        tempatLahir,
        tanggalLahir,
        jenisKelamin,
        golDarah,
        photoURL,
      ];
}
