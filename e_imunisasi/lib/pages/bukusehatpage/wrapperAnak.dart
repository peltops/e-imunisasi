import 'package:e_imunisasi/pages/bukusehatpage/widget/cardTabel.dart';
import 'package:flutter/material.dart';

class WrapperAnakBukuSehat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardTabelRiwayatImunisasiAnak(),
      ],
    );
  }
}
