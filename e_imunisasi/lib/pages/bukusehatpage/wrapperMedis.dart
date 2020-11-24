import 'package:e_imunisasi/pages/bukusehatpage/widget/cardTabelMedis.dart';
import 'package:flutter/material.dart';

class WrapperMedisBukuSehat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardTabelRiwayatImunisasiMedis(),
      ],
    );
  }
}
