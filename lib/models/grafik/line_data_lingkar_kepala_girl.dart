// ignore_for_file: file_names

import 'package:eimunisasi/models/checkup_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:math_expressions/math_expressions.dart';

class LineDataLingkarKepalaGirlModel {
  //method lineChartBarData of y = 0,00000818x5 - 0,00061260x4 + 0,01816480x3 - 0,27842781x2 + 2,53981612x + 33,44617271
  List<FlSpot> listDataLine1() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.00000818);
      Number const2 = Number(0.00061260);
      Number const3 = Number(0.01816480);
      Number const4 = Number(0.27842781);
      Number const5 = Number(2.53981612);
      Number const6 = Number(33.44617271);
      final exp = const1 * Power(x, 5) -
          const2 * Power(x, 4) +
          const3 * Power(x, 3) -
          const4 * Power(x, 2) +
          const5 * x +
          const6;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y = 0,00000767x5 - 0,00058298x4 + 0,01765221x3 - 0,27850528x2 + 2,62746400x + 37,06022569R² = 0,99976359
  List<FlSpot> listDataLine2() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.00000767);
      Number const2 = Number(0.00058298);
      Number const3 = Number(0.01765221);
      Number const4 = Number(0.27850528);
      Number const5 = Number(2.62746400);
      Number const6 = Number(37.06022569);
      final exp = const1 * Power(x, 5) -
          const2 * Power(x, 4) +
          const3 * Power(x, 3) -
          const4 * Power(x, 2) +
          const5 * x +
          const6;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y = 0,00000838x5 - 0,00062466x4 + 0,01849628x3 - 0,28462621x2 + 2,62032518x + 35,84568666
  List<FlSpot> listDataLine3() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.00000838);
      Number const2 = Number(0.00062466);
      Number const3 = Number(0.01849628);
      Number const4 = Number(0.28462621);
      Number const5 = Number(2.62032518);
      Number const6 = Number(35.84568666);
      final exp = const1 * Power(x, 5) -
          const2 * Power(x, 4) +
          const3 * Power(x, 3) -
          const4 * Power(x, 2) +
          const5 * x +
          const6;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y = 0,00000911x5 - 0,00067119x4 + 0,01952798x3 - 0,29314885x2 + 2,62238884x + 34,61361672
  List<FlSpot> listDataLine4() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.00000911);
      Number const2 = Number(0.00067119);
      Number const3 = Number(0.01952798);
      Number const4 = Number(0.29314885);
      Number const5 = Number(2.62238884);
      Number const6 = Number(34.61361672);
      final exp = const1 * Power(x, 5) -
          const2 * Power(x, 4) +
          const3 * Power(x, 3) -
          const4 * Power(x, 2) +
          const5 * x +
          const6;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y = 0,00000847x5 - 0,00062752x4 + 0,01836595x3 - 0,27725656x2 + 2,49592593x + 32,27184983
  List<FlSpot> listDataLine5() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.00000847);
      Number const2 = Number(0.00062752);
      Number const3 = Number(0.01836595);
      Number const4 = Number(0.27725656);
      Number const5 = Number(2.49592593);
      Number const6 = Number(32.27184983);
      final exp = const1 * Power(x, 5) -
          const2 * Power(x, 4) +
          const3 * Power(x, 3) -
          const4 * Power(x, 2) +
          const5 * x +
          const6;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y = 0,00000955x5 - 0,00069062x4 + 0,01965735x3 - 0,28787021x2 + 2,51369006x + 30,98830812
  List<FlSpot> listDataLine6() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.00000955);
      Number const2 = Number(0.00069062);
      Number const3 = Number(0.01965735);
      Number const4 = Number(0.28787021);
      Number const5 = Number(2.51369006);
      Number const6 = Number(30.98830812);
      final exp = const1 * Power(x, 5) -
          const2 * Power(x, 4) +
          const3 * Power(x, 3) -
          const4 * Power(x, 2) +
          const5 * x +
          const6;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y = 0,00000955x5 - 0,00069061x4 + 0,01961847x3 - 0,28582585x2 + 2,47565050x + 29,79702364
  List<FlSpot> listDataLine7() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.00000955);
      Number const2 = Number(0.00069061);
      Number const3 = Number(0.01961847);
      Number const4 = Number(0.28582585);
      Number const5 = Number(2.47565050);
      Number const6 = Number(29.79702364);
      final exp = const1 * Power(x, 5) -
          const2 * Power(x, 4) +
          const3 * Power(x, 3) -
          const4 * Power(x, 2) +
          const5 * x +
          const6;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method data pasien
  List<FlSpot> listDataPasienLine(List<CheckupModel> listData) {
    List<FlSpot> list = [];
    for (int i = 1; i <= listData.length; i++) {
      list.add(FlSpot(
          i.toDouble(), listData[i - 1].lingkarKepala?.toDouble() ?? 0.0));
    }
    return list;
  }
}
