import 'package:e_imunisasi/pages/tumbuhKembang/widget/cardGrafik.dart';
import 'package:e_imunisasi/pages/tumbuhKembang/widget/cardTabel.dart';
import 'package:flutter/material.dart';

class WrapperAnakTumbuhKembang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardTabelTumbuh(),
        CardGrafikTumbuh(),
      ],
    );
  }
}
