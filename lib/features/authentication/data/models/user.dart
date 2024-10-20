import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Users extends Equatable {
  final String? uid;
  final String? momName;
  final String? dadName;
  final String? nomorhpAyah;
  final String? nomorhpIbu;
  final String? email;
  final String? golDarahAyah;
  final String? golDarahIbu;
  final String? pekerjaanAyah;
  final String? pekerjaanIbu;
  final String? alamat;
  final String? avatarURL;
  final bool? verified;
  final String? tempatLahir;
  final DateTime? tanggalLahir;
  final String? noKK;
  final String? noKTP;
  Users({
    this.golDarahAyah,
    this.golDarahIbu,
    this.pekerjaanAyah,
    this.pekerjaanIbu,
    this.nomorhpAyah,
    this.nomorhpIbu,
    this.alamat,
    this.momName,
    this.dadName,
    this.uid,
    this.email,
    this.avatarURL,
    this.verified,
    this.tempatLahir,
    this.tanggalLahir,
    this.noKK,
    this.noKTP,
  });

  factory Users.fromMap(Map data) {
    return Users(
      uid: data['uid'],
      email: data['email'] ?? '',
      momName: data['momName'] ?? '',
      dadName: data['dadName'] ?? '',
      nomorhpAyah: data['nomorhpAyah'] ?? '',
      nomorhpIbu: data['nomorhpIbu'] ?? '',
      golDarahAyah: data['golDarahAyah'] ?? '',
      golDarahIbu: data['golDarahIbu'] ?? '',
      pekerjaanAyah: data['pekerjaanAyah'] ?? '',
      pekerjaanIbu: data['pekerjaanIbu'] ?? '',
      alamat: data['alamat'] ?? '',
      avatarURL: data['avatarURL'] ?? '',
      verified: data['verified'] ?? false,
      tempatLahir: data['tempatLahir'] ?? '',
      tanggalLahir: () {
        if (data['tanggalLahir'] is Timestamp) {
          return (data['tanggalLahir'] as Timestamp).toDate();
        } else {
          return null;
        }
      }(),
      noKK: data['noKK'] ?? '',
      noKTP: data['noKTP'] ?? '',
    );
  }

  factory Users.fromSeribase(Map<String, dynamic> data) {
    return Users(
      uid: data['user_id'],
      email: data['email'] ?? '',
      momName: data['mother_name'] ?? '',
      dadName: data['father_name'] ?? '',
      nomorhpAyah: data['father_phone_number'] ?? '',
      nomorhpIbu: data['mother_phone_number'] ?? '',
      golDarahAyah: data['father_blood_type'] ?? '',
      golDarahIbu: data['mother_blood_type'] ?? '',
      pekerjaanAyah: data['father_job'] ?? '',
      pekerjaanIbu: data['mother_job'] ?? '',
      alamat: data['address'] ?? '',
      avatarURL: data['avatar_url'] ?? '',
      verified: data['verified'] ?? false,
      tempatLahir: data['place_of_birth'] ?? '',
      tanggalLahir: () {
        try {
          return DateTime.parse(data['date_of_birth']);
        } catch (e) {
          return null;
        }
      }(),
      noKK: data['no_kartu_keluarga'] ?? '',
      noKTP: data['no_induk_kependudukan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "momName": momName,
        "dadName": dadName,
        "nomorhpAyah": nomorhpAyah,
        "nomorhpIbu": nomorhpIbu,
        'golDarahAyah': golDarahAyah,
        'golDarahIbu': golDarahIbu,
        'pekerjaanAyah': pekerjaanAyah,
        'pekerjaanIbu': pekerjaanIbu,
        'alamat': alamat,
        'avatarURL': avatarURL,
        "verified": verified,
        "tempatLahir": tempatLahir,
        "tanggalLahir": tanggalLahir,
        "noKK": noKK,
        "noKTP": noKTP,
      };

  Map<String, dynamic> toSeribaseMap() {
    return {
      if (uid?.isNotEmpty ?? false) "user_id": uid,
      if (momName?.isNotEmpty ?? false) "mother_name": momName,
      if (dadName?.isNotEmpty ?? false) "father_name": dadName,
      if (nomorhpAyah?.isNotEmpty ?? false) "father_phone_number": nomorhpAyah,
      if (nomorhpIbu?.isNotEmpty ?? false) "mother_phone_number": nomorhpIbu,
      if (golDarahAyah?.isNotEmpty ?? false) "father_blood_type": golDarahAyah,
      if (golDarahIbu?.isNotEmpty ?? false) "mother_blood_type": golDarahIbu,
      if (pekerjaanAyah?.isNotEmpty ?? false) "father_job": pekerjaanAyah,
      if (pekerjaanIbu?.isNotEmpty ?? false) "mother_job": pekerjaanIbu,
      if (alamat?.isNotEmpty ?? false) "address": alamat,
      if (avatarURL?.isNotEmpty ?? false) "avatar_url": avatarURL,
      if (tempatLahir?.isNotEmpty ?? false) "place_of_birth": tempatLahir,
      if (tanggalLahir != null)
        "date_of_birth": tanggalLahir?.toIso8601String(),
      if (noKK?.isNotEmpty ?? false) "no_kartu_keluarga": noKK,
      if (noKTP?.isNotEmpty ?? false) "no_induk_kependudukan": noKTP,
    };
  }

  Users copyWith({
    String? uid,
    String? email,
    String? momName,
    String? dadName,
    String? nomorhpAyah,
    String? nomorhpIbu,
    String? golDarahAyah,
    String? golDarahIbu,
    String? pekerjaanAyah,
    String? pekerjaanIbu,
    String? alamat,
    String? avatarURL,
    bool? verified,
    String? tempatLahir,
    DateTime? tanggalLahir,
    String? noKK,
    String? noKTP,
  }) {
    return Users(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      momName: momName ?? this.momName,
      dadName: dadName ?? this.dadName,
      nomorhpAyah: nomorhpAyah ?? this.nomorhpAyah,
      nomorhpIbu: nomorhpIbu ?? this.nomorhpIbu,
      golDarahAyah: golDarahAyah ?? this.golDarahAyah,
      golDarahIbu: golDarahIbu ?? this.golDarahIbu,
      pekerjaanAyah: pekerjaanAyah ?? this.pekerjaanAyah,
      pekerjaanIbu: pekerjaanIbu ?? this.pekerjaanIbu,
      alamat: alamat ?? this.alamat,
      avatarURL: avatarURL ?? this.avatarURL,
      verified: verified ?? this.verified,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      noKK: noKK ?? this.noKK,
      noKTP: noKTP ?? this.noKTP,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        momName,
        dadName,
        nomorhpAyah,
        nomorhpIbu,
        golDarahAyah,
        golDarahIbu,
        pekerjaanAyah,
        pekerjaanIbu,
        alamat,
        avatarURL,
        verified,
        tempatLahir,
        tanggalLahir,
        noKK,
        noKTP,
      ];
}

class UserData {
  final String? uid;
  final String? email;
  final String? avatarURL;
  final String? nama;
  final String? nik;
  final String? tgllahir;
  final String? namaAyah;
  final String? pekerjaanAyah;
  final String? namaIbu;
  final String? pekerjaanIbu;
  final String? alamat;
  final String? unitKerja;
  final String? noTlp;

  UserData(
      {this.uid,
      this.email,
      this.avatarURL,
      this.nama,
      this.nik,
      this.tgllahir,
      this.namaAyah,
      this.pekerjaanAyah,
      this.namaIbu,
      this.pekerjaanIbu,
      this.alamat,
      this.unitKerja,
      this.noTlp});
}

class GetAllUser {
  final String? nama;
  final String? tgllahir;
  final String? email;
  final String? documentID;

  GetAllUser({this.nama, this.tgllahir, this.email, this.documentID});
  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "nama": nama,
      "tgllahir": tgllahir,
    };
  }
}

class DataTumbuh {
  final String? idMedis;
  final String? idPeserta;
  final String? nama;
  final String? email;
  final String? tgllahir;
  final String? beratBadan;
  final String? tinggiBadan;
  final String? lingkarBadan;
  final DateTime? takeDate;
  final String? documentID;

  DataTumbuh(
      {this.idPeserta,
      this.idMedis,
      this.nama,
      this.email,
      this.tgllahir,
      this.beratBadan,
      this.tinggiBadan,
      this.lingkarBadan,
      this.takeDate,
      this.documentID});
  Map<String, dynamic> toMap() {
    return {
      "idMedis": idMedis,
      "idPeserta": idPeserta,
      "nama": nama,
      "email": email,
      "tgllahir": tgllahir,
      "beratBadan": beratBadan,
      "tinggiBadan": tinggiBadan,
      "lingkarBadan": lingkarBadan,
      "take_date": takeDate,
    };
  }
}

class DataRiwayatImunisasi {
  final String? idMedis;
  final String? idPeserta;
  final String? nama;
  final String? email;
  final String? tgllahir;
  final String? jenisVaksin;
  final String? namaMedis;
  final DateTime? takeDate;
  final String? documentID;

  DataRiwayatImunisasi(
      {this.idPeserta,
      this.idMedis,
      this.nama,
      this.email,
      this.tgllahir,
      this.jenisVaksin,
      this.namaMedis,
      this.takeDate,
      this.documentID});
  Map<String, dynamic> toMap() {
    return {
      "idMedis": idMedis,
      "idPeserta": idPeserta,
      "nama": nama,
      "email": email,
      "tgllahir": tgllahir,
      "jenisVaksin": jenisVaksin,
      "namaMedis": namaMedis,
      "take_date": takeDate,
    };
  }
}
