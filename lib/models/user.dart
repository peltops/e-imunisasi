class User {
  final String uid;
  final String email;
  User({this.uid, this.email});
}

class TypeUser {
  final String typeUser;
  TypeUser({this.typeUser});
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

class DataKalender {
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String documentID;

  DataKalender(
      {this.id, this.title, this.description, this.eventDate, this.documentID});
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "event_date": eventDate,
      "id": id,
    };
  }
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
