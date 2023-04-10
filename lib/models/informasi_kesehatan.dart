class InformasiKesehatanModel {
  final String? penulis;
  final String? deskripsi;
  final String? judul;
  final DateTime? createdAt;

  InformasiKesehatanModel({
    this.penulis,
    this.judul,
    this.deskripsi,
    this.createdAt,
  });

  factory InformasiKesehatanModel.fromMap(Map data) {
    return InformasiKesehatanModel(
      penulis: data['penulis'],
      judul: data['judul'],
      deskripsi: data['deskripsi'],
      createdAt: data['created_at'].toDate(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "penulis": penulis,
      "judul": judul,
      "deskripsi": deskripsi,
      "created_at": createdAt,
    };
  }
}
