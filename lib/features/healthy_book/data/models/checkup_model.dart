import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CheckupModel extends Equatable {
  final int? beratBadan;
  final int? tinggiBadan;
  final int? lingkarKepala;
  final String? jenisVaksin;
  final String? riwayatKeluhan;
  final String? diagnosa;
  final String? tindakan;
  final String? id;
  final String? idOrangTuaPasien;
  final String? idPasien;
  final String? idDokter;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const CheckupModel({
    this.beratBadan,
    this.tinggiBadan,
    this.lingkarKepala,
    this.jenisVaksin,
    this.riwayatKeluhan,
    this.diagnosa,
    this.tindakan,
    this.id,
    this.idOrangTuaPasien,
    this.idPasien,
    this.idDokter,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  List<Object?> get props => [
        beratBadan,
        tinggiBadan,
        lingkarKepala,
        jenisVaksin,
        riwayatKeluhan,
        diagnosa,
        tindakan,
        id,
        idOrangTuaPasien,
        idPasien,
        idDokter,
        createdAt,
        updatedAt,
        deletedAt
      ];

  factory CheckupModel.fromFirebase(Map<String, dynamic> map, String docId) {
    return CheckupModel(
      beratBadan: map['berat_badan'],
      tinggiBadan: map['tinggi_badan'],
      lingkarKepala: map['lingkar_kepala'],
      jenisVaksin: map['jenis_vaksin'],
      riwayatKeluhan: map['riwayat_keluhan'],
      diagnosa: map['diagnosa'],
      tindakan: map['tindakan'],
      id: docId,
      idOrangTuaPasien: map['id_orang_tua_pasien'],
      idPasien: map['id_pasien'],
      idDokter: map['id_dokter'],
      createdAt: ((map['created_at'] != null)
          ? (map['created_at'] as Timestamp).toDate()
          : null),
      updatedAt: ((map['updated_at'] != null)
          ? (map['updated_at'] as Timestamp).toDate()
          : null),
      deletedAt: ((map['deleted_at'] != null)
          ? (map['deleted_at'] as Timestamp).toDate()
          : null),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'berat_badan': beratBadan,
      'tinggi_badan': tinggiBadan,
      'lingkar_kepala': lingkarKepala,
      'jenis_vaksin': jenisVaksin,
      'riwayat_keluhan': riwayatKeluhan,
      'diagnosa': diagnosa,
      'tindakan': tindakan,
      'id_pasien': idPasien,
      'id_orang_tua_pasien': idOrangTuaPasien,
      'id_dokter': idDokter,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  CheckupModel copyWith({
    int? beratBadan,
    int? tinggiBadan,
    int? lingkarKepala,
    String? jenisVaksin,
    String? riwayatKeluhan,
    String? diagnosa,
    String? tindakan,
    String? id,
    String? idOrangTuaPasien,
    String? idPasien,
    String? idDokter,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return CheckupModel(
      beratBadan: beratBadan ?? this.beratBadan,
      tinggiBadan: tinggiBadan ?? this.tinggiBadan,
      lingkarKepala: lingkarKepala ?? this.lingkarKepala,
      jenisVaksin: jenisVaksin ?? this.jenisVaksin,
      riwayatKeluhan: riwayatKeluhan ?? this.riwayatKeluhan,
      diagnosa: diagnosa ?? this.diagnosa,
      tindakan: tindakan ?? this.tindakan,
      id: id ?? this.id,
      idOrangTuaPasien: idOrangTuaPasien ?? this.idOrangTuaPasien,
      idPasien: idPasien ?? this.idPasien,
      idDokter: idDokter ?? this.idDokter,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
