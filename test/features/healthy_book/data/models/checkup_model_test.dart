import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CheckupModel checkupModel;

  setUp(() {
    checkupModel = CheckupModel(
      beratBadan: 10,
      tinggiBadan: 10,
      lingkarKepala: 10,
      jenisVaksin: 'jenisVaksin',
      riwayatKeluhan: 'riwayatKeluhan',
      diagnosa: 'diagnosa',
      tindakan: 'tindakan',
      id: 'id',
      idOrangTuaPasien: 'idOrangTua',
      idPasien: 'idPasien',
      idDokter: 'idDokter',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deletedAt: DateTime.now(),
    );
  });

  test('should be a subclass of Equatable', () {
    expect(checkupModel, isA<CheckupModel>());
  });

  group('fromMap', () {
    test('should return a valid model', () {
      final Map<String, dynamic> map = {
        'berat_badan': 10,
        'tinggi_badan': 10,
        'lingkar_kepala': 10,
        'jenis_vaksin': 'jenisVaksin',
        'riwayat_keluhan': 'riwayatKeluhan',
        'diagnosa': 'diagnosa',
        'tindakan': 'tindakan',
        'id_orang_tua_pasien': 'idOrangTua',
        'id_pasien': 'idPasien',
        'id_dokter': 'idDokter',
        'created_at': Timestamp.now(),
        'deleted_at': null,
      };
      final result = CheckupModel.fromFirebase(map, 'id');
      final expected = CheckupModel(
        beratBadan: 10,
        tinggiBadan: 10,
        lingkarKepala: 10,
        jenisVaksin: 'jenisVaksin',
        riwayatKeluhan: 'riwayatKeluhan',
        diagnosa: 'diagnosa',
        tindakan: 'tindakan',
        id: 'id',
        idOrangTuaPasien: 'idOrangTua',
        idPasien: 'idPasien',
        idDokter: 'idDokter',
        createdAt: map['created_at'].toDate(),
        updatedAt: null,
        deletedAt: null,
      );
      expect(result, expected);
    });

    test('should return a valid model with deletedAt and updatedAt', () {
      final Map<String, dynamic> map = {
        'berat_badan': 10,
        'tinggi_badan': 10,
        'lingkar_kepala': 10,
        'jenis_vaksin': 'jenisVaksin',
        'riwayat_keluhan': 'riwayatKeluhan',
        'diagnosa': 'diagnosa',
        'tindakan': 'tindakan',
        'id_orang_tua_pasien': 'idOrangTua',
        'id_pasien': 'idPasien',
        'id_dokter': 'idDokter',
        'created_at': Timestamp.now(),
        'deleted_at': Timestamp.fromDate(DateTime.now().add(Duration(days: 1))),
        'updated_at': Timestamp.fromDate(DateTime.now().add(Duration(days: 2))),
      };
      final result = CheckupModel.fromFirebase(map, 'id');
      final expected = CheckupModel(
        beratBadan: 10,
        tinggiBadan: 10,
        lingkarKepala: 10,
        jenisVaksin: 'jenisVaksin',
        riwayatKeluhan: 'riwayatKeluhan',
        diagnosa: 'diagnosa',
        tindakan: 'tindakan',
        id: 'id',
        idOrangTuaPasien: 'idOrangTua',
        idPasien: 'idPasien',
        idDokter: 'idDokter',
        createdAt: map['created_at'].toDate(),
        updatedAt: map['updated_at'].toDate(),
        deletedAt: map['deleted_at'].toDate(),
      );
      expect(result, expected);
    });
  });

  group('toMap', () {
    test('should return a JSON map containing the proper data', () {
      final result = checkupModel.toMap();
      final expected = {
        'berat_badan': 10,
        'tinggi_badan': 10,
        'lingkar_kepala': 10,
        'jenis_vaksin': 'jenisVaksin',
        'riwayat_keluhan': 'riwayatKeluhan',
        'diagnosa': 'diagnosa',
        'tindakan': 'tindakan',
        'id_orang_tua_pasien': 'idOrangTua',
        'id_pasien': 'idPasien',
        'id_dokter': 'idDokter',
        'created_at': checkupModel.createdAt,
        'updated_at': checkupModel.updatedAt,
        'deleted_at': checkupModel.deletedAt,
      };
      expect(result, expected);
    });
  });

  group('copyWith', () {
    test('should return a new instance of CheckupModel', () {
      final result = checkupModel.copyWith();
      expect(result, isA<CheckupModel>());
    });

    test('should return a new instance of CheckupModel with updated data', () {
      final result = checkupModel.copyWith(
        beratBadan: 20,
        tinggiBadan: 20,
        lingkarKepala: 20,
        jenisVaksin: 'jenisVaksin2',
        riwayatKeluhan: 'riwayatKeluhan2',
        diagnosa: 'diagnosa2',
        tindakan: 'tindakan2',
        id: 'id2',
        idOrangTuaPasien: 'idOrangTua2',
        idPasien: 'idPasien2',
        idDokter: 'idDokter2',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: DateTime.now(),
      );
      final expected = CheckupModel(
        beratBadan: 20,
        tinggiBadan: 20,
        lingkarKepala: 20,
        jenisVaksin: 'jenisVaksin2',
        riwayatKeluhan: 'riwayatKeluhan2',
        diagnosa: 'diagnosa2',
        tindakan: 'tindakan2',
        id: 'id2',
        idOrangTuaPasien: 'idOrangTua2',
        idPasien: 'idPasien2',
        idDokter: 'idDokter2',
        createdAt: result.createdAt,
        updatedAt: result.updatedAt,
        deletedAt: result.deletedAt,
      );
      expect(result, expected);
    });
  });
}