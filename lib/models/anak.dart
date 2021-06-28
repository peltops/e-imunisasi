class Anak {
  final List nama;
  final DateTime tglLahir;

  Anak({this.nama, this.tglLahir});

  Map<String, dynamic> toMap() {
    return {
      "nama": nama,
      "tanggal_lahir": tglLahir,
    };
  }
}
