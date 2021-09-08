class NakesModel {
  final String nama;
  final String telepon;
  final String spesialis;

  NakesModel({
    this.nama,
    this.telepon,
    this.spesialis,
  });

  factory NakesModel.fromMap(Map data) {
    return NakesModel(
      nama: data['nama'],
      telepon: data['telepon'],
      spesialis: data['spesialis'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "nama": nama,
      "telepon": telepon,
      "spesialis": spesialis,
    };
  }
}
