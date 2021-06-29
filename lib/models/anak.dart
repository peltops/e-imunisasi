class Anak {
  final String nama;
  final String nik;
  final String tempatLahir;
  final DateTime tanggalLahir;
  final String jenisKelamin;
  final String golDarah;

  Anak(this.nik, this.tempatLahir, this.jenisKelamin, this.golDarah, this.nama,
      this.tanggalLahir);

  Map<String, dynamic> toMap(int index) {
    return {
      index.toString(): {
        "nama": nama,
        "nik": nik,
        "tempat_lahir": tempatLahir,
        "tanggal_lahir": tanggalLahir,
        "jenis_kelamin": jenisKelamin,
        "gol_darah": golDarah,
      },
    };
  }
}
