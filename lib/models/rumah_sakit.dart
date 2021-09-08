class RumahSakitModel {
  final String nama;
  final String telepon;
  final String alamat;

  RumahSakitModel({
    this.nama,
    this.telepon,
    this.alamat,
  });

  factory RumahSakitModel.fromMap(Map data) {
    return RumahSakitModel(
      nama: data['nama'],
      telepon: data['telepon'],
      alamat: data['alamat'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "nama": nama,
      "telepon": telepon,
      "alamat": alamat,
    };
  }
}
