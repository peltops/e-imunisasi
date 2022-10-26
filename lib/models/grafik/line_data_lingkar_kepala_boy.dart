// ignore_for_file: file_names

import 'package:eimunisasi/models/checkup_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:math_expressions/math_expressions.dart';

class LineDataLingkarKepalaBoyModel {
  //method lineChartBarData of y = 0,00000721x5 - 0,00055096x4 + 0,01688394x3 - 0,27192347x2 + 2,63126903x + 37,78553641
  List<FlSpot> listDataLine1() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.00000721);
      Number const2 = Number(0.00055096);
      Number const3 = Number(0.01688394);
      Number const4 = Number(0.27192347);
      Number const5 = Number(2.63126903);
      Number const6 = Number(37.78553641);
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

  //method lineChartBarData of y = 0,00000819x5 - 0,00061770x4 + 0,01854033x3 - 0,28971686x2 + 2,69602649x + 36,49431684
  List<FlSpot> listDataLine2() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.00000819);
      Number const2 = Number(0.00061770);
      Number const3 = Number(0.01854033);
      Number const4 = Number(0.28971686);
      Number const5 = Number(2.69602649);
      Number const6 = Number(36.49431684);
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

  //method lineChartBarData of y = 0,00000906x5 - 0,00067693x4 + 0,02002894x3 - 0,30609367x2 + 2,75838731x + 35,19629667
  List<FlSpot> listDataLine3() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.00000906);
      Number const2 = Number(0.00067693);
      Number const3 = Number(0.02002894);
      Number const4 = Number(0.30609367);
      Number const5 = Number(2.75838731);
      Number const6 = Number(35.19629667);
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

  //method lineChartBarData of y = 0,00000973x5 - 0,00071813x4 + 0,02095051x3 - 0,31507558x2 + 2,78335970x + 33,94425959
  List<FlSpot> listDataLine4() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.00000973);
      Number const2 = Number(0.00071813);
      Number const3 = Number(0.02095051);
      Number const4 = Number(0.31507558);
      Number const5 = Number(2.78335970);
      Number const6 = Number(33.94425959);
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

  //method lineChartBarData of y = 0,00000977x5 - 0,00071947x4 + 0,02098946x3 - 0,31613969x2 + 2,78348667x + 32,73469469
  List<FlSpot> listDataLine5() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.00000977);
      Number const2 = Number(0.00071947);
      Number const3 = Number(0.02098946);
      Number const4 = Number(0.31613969);
      Number const5 = Number(2.78348667);
      Number const6 = Number(32.73469469);
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

  //method lineChartBarData of y = 0,00001121x5 - 0,00081471x4 + 0,02326989x3 - 0,33948538x2 + 2,86775428x + 31,40958799
  List<FlSpot> listDataLine6() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.00001121);
      Number const2 = Number(0.00081471);
      Number const3 = Number(0.02326989);
      Number const4 = Number(0.33948538);
      Number const5 = Number(2.86775428);
      Number const6 = Number(31.40958799);
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

  //method lineChartBarData of y = 0,00001113x5 - 0,00081778x4 + 0,02355179x3 - 0,34454875x2 + 2,88741952x + 30,15595154
  List<FlSpot> listDataLine7() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.00001113);
      Number const2 = Number(0.00081778);
      Number const3 = Number(0.02355179);
      Number const4 = Number(0.34454875);
      Number const5 = Number(2.88741952);
      Number const6 = Number(30.15595154);
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
