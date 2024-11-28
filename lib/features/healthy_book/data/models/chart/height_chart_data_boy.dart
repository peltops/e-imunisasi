import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:math_expressions/math_expressions.dart';

class HeightChartDataBoy {
  //method lineChartBarData of y = -0,0002501x4 + 0,0150547x3 - 0,3376376x2 + 4,3399430x + 46,9700427
  List<FlSpot> listDataLine1() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(-0.0002501);
      Number const2 = Number(0.0150547);
      Number const3 = Number(-0.3376376);
      Number const4 = Number(4.3399430);
      Number const5 = Number(46.9700427);
      final exp = const1 * Power(x, 4) +
          const2 * Power(x, 3) +
          const3 * Power(x, 2) +
          const4 * x +
          const5;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y = 0,0000180x5 - 0,0013348x4 + 0,0381623x3 - 0,5429746x2 + 5,0483717x + 48,1241895
  List<FlSpot> listDataLine2() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.0000180);
      Number const2 = Number(-0.0013348);
      Number const3 = Number(0.0381623);
      Number const4 = Number(-0.5429746);
      Number const5 = Number(5.0483717);
      Number const6 = Number(48.1241895);
      final exp = const1 * Power(x, 5) +
          const2 * Power(x, 4) +
          const3 * Power(x, 3) +
          const4 * Power(x, 2) +
          const5 * x +
          const6;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y = 0,0000184x5 - 0,0013628x4 + 0,0389492x3 - 0,5514154x2 + 5,1166274x + 50,1041928
  List<FlSpot> listDataLine3() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.0000184);
      Number const2 = Number(-0.0013628);
      Number const3 = Number(0.0389492);
      Number const4 = Number(-0.5514154);
      Number const5 = Number(5.1166274);
      Number const6 = Number(50.1041928);
      final exp = const1 * Power(x, 5) +
          const2 * Power(x, 4) +
          const3 * Power(x, 3) +
          const4 * Power(x, 2) +
          const5 * x +
          const6;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y = 0,0000192x5 - 0,0014133x4 + 0,0401177x3 - 0,5620420x2 + 5,1877005x + 52,0832685
  List<FlSpot> listDataLine4() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.0000192);
      Number const2 = Number(-0.0014133);
      Number const3 = Number(0.0401177);
      Number const4 = Number(-0.5620420);
      Number const5 = Number(5.1877005);
      Number const6 = Number(52.0832685);
      final exp = const1 * Power(x, 5) +
          const2 * Power(x, 4) +
          const3 * Power(x, 3) +
          const4 * Power(x, 2) +
          const5 * x +
          const6;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y = 0,0000189x5 - 0,0013986x4 + 0,0399272x3 - 0,5613172x2 + 5,2210823x + 53,6888801
  List<FlSpot> listDataLine5() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.0000189);
      Number const2 = Number(-0.0013986);
      Number const3 = Number(0.0399272);
      Number const4 = Number(-0.5613172);
      Number const5 = Number(5.2210823);
      Number const6 = Number(53.6888801);
      final exp = const1 * Power(x, 5) +
          const2 * Power(x, 4) +
          const3 * Power(x, 3) +
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
      list.add(
          FlSpot(i.toDouble(), listData[i - 1].tinggiBadan?.toDouble() ?? 0.0));
    }
    return list;
  }
}
