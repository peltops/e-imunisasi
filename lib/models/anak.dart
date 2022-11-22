class Anak {
  final String id;
  final String parentId;
  final String nama;
  final String nik;
  final String tempatLahir;
  final DateTime tanggalLahir;
  final String jenisKelamin;
  final String golDarah;
  final String photoURL;

  get umurAnak {
    // ignore: unrelated_type_equality_checks
    if (this.tanggalLahir == null || this.tanggalLahir == '') {
      return 'Umur belum diisi';
    }
    Duration dur = DateTime.now().difference(this.tanggalLahir);
    String tahun = (dur.inDays / 365).floor().toString();
    String bulan = ((dur.inDays % 365) / 30).floor().toString();

    return tahun + " tahun, " + bulan + " bulan ";
  }

  Anak({
    this.id,
    this.parentId,
    this.nik,
    this.tempatLahir,
    this.jenisKelamin,
    this.golDarah,
    this.nama,
    this.tanggalLahir,
    this.photoURL,
  });

  factory Anak.fromMap(Map data) {
    return Anak(
      id: data['id'],
      parentId: data['parent_id'],
      nama: data['nama'],
      nik: data['nik'] ?? '',
      tempatLahir: data['tempat_lahir'] ?? '',
      tanggalLahir: data['tanggal_lahir'].toDate() ?? '',
      jenisKelamin: data['jenis_kelamin'] ?? '',
      golDarah: data['gol_darah'] ?? '',
      photoURL: data['photo_url'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'parent_id': parentId,
      "nama": nama,
      "nik": nik,
      "tempat_lahir": tempatLahir,
      "tanggal_lahir": tanggalLahir,
      "jenis_kelamin": jenisKelamin,
      "gol_darah": golDarah,
      "photo_url": photoURL,
    };
  }

  Anak copyWith({
    String id,
    String parentId,
    String nama,
    String nik,
    String tempatLahir,
    DateTime tanggalLahir,
    String jenisKelamin,
    String golDarah,
    String photoURL,
  }) {
    return Anak(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      golDarah: golDarah ?? this.golDarah,
      photoURL: photoURL ?? this.photoURL,
    );
  }
}
