class InformasiAplikasiModel {
  final String? penulis;
  final String? deskripsi;
  final String? judul;
  final DateTime? createdAt;

  InformasiAplikasiModel({
    this.penulis,
    this.judul,
    this.deskripsi,
    this.createdAt,
  });

  factory InformasiAplikasiModel.fromMap(Map data) {
    return InformasiAplikasiModel(
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
