class ListConstant {
  static const TYPE_BLOOD = ['A', 'AB', 'B', 'O'];
  static const JOB = ['IRT', 'ASN/Karyawan', 'Wirausaha'];
  static const GENDER = ['-', 'Laki-laki', 'Perempuan'];
}

enum BloodType {
  A,
  AB,
  B,
  O,
}

enum Gender {
  MALE('Laki-laki'),
  FEMALE('Perempuan');

  final String value;

  const Gender(
    this.value,
  );
}
