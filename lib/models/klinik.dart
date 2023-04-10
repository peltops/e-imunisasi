class KlinikModel {
  final String? nama;
  final String? phone;
  final String? alamat;

  KlinikModel({
    this.nama,
    this.phone,
    this.alamat,
  });

  factory KlinikModel.fromMap(Map data) {
    return KlinikModel(
      nama: data['nama'],
      phone: data['phone'],
      alamat: data['alamat'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "nama": nama,
      "phone": phone,
      "alamat": alamat,
    };
  }
}
