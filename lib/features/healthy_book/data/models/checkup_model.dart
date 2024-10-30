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

  factory CheckupModel.fromSeribase(Map<String, dynamic> map) {
    return CheckupModel(
      beratBadan: map['weight'],
      tinggiBadan: map['height'],
      lingkarKepala: map['head_circumference'],
      jenisVaksin: map['vaccine_type'],
      riwayatKeluhan: map['complaint'],
      diagnosa: map['diagnosis'],
      tindakan: map['action'],
      id: map['id'],
      idOrangTuaPasien: map['parent_id'],
      idPasien: map['child_id'],
      idDokter: map['inspector_id'],
      createdAt: () {
        try {
          return DateTime.parse(map['created_at']);
        } catch (e) {
          return null;
        }
      }(),
      updatedAt: () {
        try {
          return DateTime.parse(map['updated_at']);
        } catch (e) {
          return null;
        }
      }(),
      deletedAt: () {
        try {
          return DateTime.parse(map['deleted_at']);
        } catch (e) {
          return null;
        }
      }(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (beratBadan != null) 'weight': beratBadan,
      if (tinggiBadan != null) 'height': tinggiBadan,
      if (lingkarKepala != null) 'head_circumference': lingkarKepala,
      // TODO: check if this is correct
      if (jenisVaksin != null) 'vaccine_type': jenisVaksin,
      if (riwayatKeluhan != null) 'complaint': riwayatKeluhan,
      if (diagnosa != null) 'diagnosis': diagnosa,
      if (tindakan != null) 'action': tindakan,
      if (idPasien != null) 'child_id': idPasien,
      if (idOrangTuaPasien != null) 'parent_id': idOrangTuaPasien,
      if (idDokter != null) 'inspector_id': idDokter,
      if (createdAt != null) 'created_at': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt?.toIso8601String(),
      if (deletedAt != null) 'deleted_at': deletedAt?.toIso8601String(),
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
