import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:math_expressions/math_expressions.dart';

class WeightChartDataBoy {
  //method lineChartBarData of y=3.8182*ln(x)+3.782
  List<FlSpot> listDataLine1() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(3.8182);
      Number const2 = Number(3.782);
      final exp = (const1 * Ln(x)) + const2;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y=3.4693*ln(x)+3.4059
  List<FlSpot> listDataLine2() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(3.4693);
      Number const2 = Number(3.4059);
      final exp = (const1 * Ln(x)) + const2;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y=3.1113*ln(x)+3.0207
  List<FlSpot> listDataLine3() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(3.1113);
      Number const2 = Number(3.0207);
      final exp = (const1 * Ln(x)) + const2;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y=2.8107*ln(x)+2.6236
  List<FlSpot> listDataLine4() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(2.8107);
      Number const2 = Number(2.6236);
      final exp = (const1 * Ln(x)) + const2;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y=2.561*ln(x)+2.1886
  List<FlSpot> listDataLine5() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(2.561);
      Number const2 = Number(2.1886);
      final exp = (const1 * Ln(x)) + const2;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y=2.3198*ln(x)+1.8911
  List<FlSpot> listDataLine6() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(2.3198);
      Number const2 = Number(1.8911);
      final exp = (const1 * Ln(x)) + const2;
      final double yvalue = exp.evaluate(EvaluationType.REAL, cm);
      list.add(FlSpot(i.toDouble(), double.parse(yvalue.toStringAsFixed(2))));
    }
    return list;
  }

  //method lineChartBarData of y=2.1049*ln(x)+1.6098
  List<FlSpot> listDataLine7() {
    List<FlSpot> list = [];
    for (int i = 1; i <= 24; i++) {
      Variable x = Variable('x');
      final xValue = Number(i);
      ContextModel cm = ContextModel()..bindVariable(x, xValue);
      Number const1 = Number(2.1049);
      Number const2 = Number(1.6098);
      final exp = (const1 * Ln(x)) + const2;
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
          FlSpot(i.toDouble(), listData[i - 1].beratBadan?.toDouble() ?? 0.0));
    }
    return list;
  }
}
