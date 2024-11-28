import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:math_expressions/math_expressions.dart';

class HeightChartDataGirl {
  //method lineChartBarData of y = 0,0000174x5 - 0,0012670x4 + 0,0354700x3 - 0,4918635x2 + 4,7666046x + 53,0871778
  List<FlSpot> listDataLine1() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.0000174);
      Number const2 = Number(-0.0012670);
      Number const3 = Number(0.0354700);
      Number const4 = Number(-0.4918635);
      Number const5 = Number(4.7666046);
      Number const6 = Number(53.0871778);
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

  //method lineChartBarData of y = 0,0000169x5 - 0,0012335x4 + 0,0346578x3 - 0,4829910x2 + 4,6774520x + 51,5412374
  List<FlSpot> listDataLine2() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.0000169);
      Number const2 = Number(-0.0012335);
      Number const3 = Number(0.0346578);
      Number const4 = Number(-0.4829910);
      Number const5 = Number(4.6774520);
      Number const6 = Number(51.5412374);
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

  //method lineChartBarData of y = 0,0000165x5 - 0,0012051x4 + 0,0338645x3 - 0,4733287x2 + 4,5726876x + 49,6252014
  List<FlSpot> listDataLine3() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.0000165);
      Number const2 = Number(-0.0012051);
      Number const3 = Number(0.0338645);
      Number const4 = Number(-0.4733287);
      Number const5 = Number(4.5726876);
      Number const6 = Number(49.6252014);
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

  //method lineChartBarData of y = 0,0000165x5 - 0,0012013x4 + 0,0335757x3 - 0,4672027x2 + 4,4715740x + 47,7060634
  List<FlSpot> listDataLine4() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.0000165);
      Number const2 = Number(-0.0012013);
      Number const3 = Number(0.0335757);
      Number const4 = Number(-0.4672027);
      Number const5 = Number(4.4715740);
      Number const6 = Number(47.7060634);
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

  //method lineChartBarData of y = 0,0000164x5 - 0,0011908x4 + 0,0332493x3 - 0,4632810x2 + 4,4101066x + 46,0943392
  List<FlSpot> listDataLine5() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(0.0000164);
      Number const2 = Number(-0.0011908);
      Number const3 = Number(0.0332493);
      Number const4 = Number(-0.4632810);
      Number const5 = Number(4.4101066);
      Number const6 = Number(46.0943392);
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
