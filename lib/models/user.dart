class Users {
  final String uid;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String golDarahAyah;
  final String golDarahIbu;
  final String pekerjaanAyah;
  final String pekerjaanIbu;
  final String alamat;
  final String avatarURL;
  final bool verified;
  Users(
      {this.phoneNumber,
      this.golDarahAyah,
      this.golDarahIbu,
      this.pekerjaanAyah,
      this.pekerjaanIbu,
      this.alamat,
      this.firstName,
      this.lastName,
      this.uid,
      this.email,
      this.avatarURL,
      this.verified});

  factory Users.fromMap(Map data) {
    return Users(
      uid: data['uid'],
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      golDarahAyah: data['golDarahAyah'] ?? '',
      golDarahIbu: data['golDarahIbu'] ?? '',
      pekerjaanAyah: data['pekerjaanAyah'] ?? '',
      pekerjaanIbu: data['pekerjaanIbu'] ?? '',
      alamat: data['alamat'] ?? '',
      avatarURL: data['avatarURL'] ?? '',
      verified: data['verified'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        'golDarahAyah': golDarahAyah,
        'golDarahIbu': golDarahIbu,
        'pekerjaanAyah': pekerjaanAyah,
        'pekerjaanIbu': pekerjaanIbu,
        'alamat': alamat,
        'avatarURL': avatarURL,
        "verified": verified,
      };
}

class UserData {
  final String uid;
  final String email;
  final String avatarURL;
  final String nama;
  final String nik;
  final String tgllahir;
  final String namaAyah;
  final String pekerjaanAyah;
  final String namaIbu;
  final String pekerjaanIbu;
  final String alamat;
  final String unitKerja;
  final String noTlp;

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
  final String nama;
  final String tgllahir;
  final String email;
  final String documentID;

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
  final String idMedis;
  final String idPeserta;
  final String nama;
  final String email;
  final String tgllahir;
  final String beratBadan;
  final String tinggiBadan;
  final String lingkarBadan;
  final DateTime takeDate;
  final String documentID;

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
  final String idMedis;
  final String idPeserta;
  final String nama;
  final String email;
  final String tgllahir;
  final String jenisVaksin;
  final String namaMedis;
  final DateTime takeDate;
  final String documentID;

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
