import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:eimunisasi/models/grafik/line_data_lingkar_kepala_boy.dart';
import 'package:eimunisasi/models/grafik/line_data_lingkar_kepala_girl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _LineChart extends StatelessWidget {
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;
  final bool isBoy;
  final List<CheckupModel>? listData;
  const _LineChart({
    required this.isShowingMainData,
    required this.minX,
    required this.maxX,
    this.minY,
    this.maxY,
    required this.isBoy,
    required this.listData,
  });

  final bool? isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData2,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData2 => LineChartData(
        minX: minX,
        maxX: maxX,
        maxY: maxY != null ? (maxY! + maxY! * 0.1) : null,
        clipData: FlClipData.all(),
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
      );

  LineTouchData get lineTouchData2 => LineTouchData(
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> indicators) {
          return indicators.map(
            (int index) {
              final line = FlLine(
                  color: Colors.black, strokeWidth: 1, dashArray: [4, 2]);
              return TouchedSpotIndicatorData(
                line,
                FlDotData(show: false),
              );
            },
          ).toList();
        },
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (LineBarSpot touchedBar) => Colors.white,
          fitInsideHorizontally: true,
          tooltipMargin: 0,
          tooltipRoundedRadius: 20,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              if (touchedSpot.bar.color == Colors.black) {
                return LineTooltipItem(
                  '(${touchedSpot.y})',
                  TextStyle(
                    color: touchedSpot.bar.gradient?.colors.first ??
                        touchedSpot.bar.color ??
                        Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                );
              }
            }).toList();
          },
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData_1,
        lineChartBarData_2,
        lineChartBarData_3,
        lineChartBarData_4,
        lineChartBarData_5,
        lineChartBarData_6,
        lineChartBarData_7,
        lineChartDataPasien,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    return Text(value.toInt().toString(),
        style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: false,
        interval: 1,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    return Padding(
        child: Text(value.toInt().toString(), style: style),
        padding: const EdgeInsets.only(top: 10.0));
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(width: 2),
          left: BorderSide(width: 2),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: const Color.fromARGB(108, 136, 32, 255),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: (isBoy)
            ? LineDataLingkarKepalaBoyModel().listDataLine1()
            : LineDataLingkarKepalaGirlModel().listDataLine1(),
      );

  LineChartBarData get lineChartBarData_2 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: const Color.fromARGB(199, 25, 0, 255),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: (isBoy)
            ? LineDataLingkarKepalaBoyModel().listDataLine2()
            : LineDataLingkarKepalaGirlModel().listDataLine2(),
      );

  LineChartBarData get lineChartBarData_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: const Color.fromARGB(68, 0, 170, 255),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: (isBoy)
            ? LineDataLingkarKepalaBoyModel().listDataLine3()
            : LineDataLingkarKepalaGirlModel().listDataLine3(),
      );

  LineChartBarData get lineChartBarData_4 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: const Color.fromARGB(68, 0, 255, 98),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: (isBoy)
            ? LineDataLingkarKepalaBoyModel().listDataLine4()
            : LineDataLingkarKepalaGirlModel().listDataLine4(),
      );

  LineChartBarData get lineChartBarData_5 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: const Color.fromARGB(68, 255, 251, 0),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: (isBoy)
            ? LineDataLingkarKepalaBoyModel().listDataLine5()
            : LineDataLingkarKepalaGirlModel().listDataLine5(),
      );

  LineChartBarData get lineChartBarData_6 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: const Color.fromARGB(68, 255, 174, 0),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: (isBoy)
            ? LineDataLingkarKepalaBoyModel().listDataLine6()
            : LineDataLingkarKepalaGirlModel().listDataLine6(),
      );

  LineChartBarData get lineChartBarData_7 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: const Color.fromARGB(68, 255, 39, 23),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: (isBoy)
            ? LineDataLingkarKepalaBoyModel().listDataLine7()
            : LineDataLingkarKepalaGirlModel().listDataLine7(),
      );

  LineChartBarData get lineChartDataPasien => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.black,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: (isBoy)
            ? LineDataLingkarKepalaBoyModel().listDataPasienLine(listData!)
            : LineDataLingkarKepalaGirlModel().listDataPasienLine(listData!),
      );
}

class GrafikLingkarKepala extends StatefulWidget {
  final List<CheckupModel>? listData;
  final bool isBoy;
  const GrafikLingkarKepala({
    Key? key,
    required this.listData,
    required this.isBoy,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => GrafikLingkarKepalaState();
}

class GrafikLingkarKepalaState extends State<GrafikLingkarKepala> {
  bool? isShowingMainData;
  double? minX;
  double? maxX;
  bool isZoomIn = false;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    minX = 1;
    maxX = 5;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onDoubleTap: () {
            if (isZoomIn) {
              setState(() {
                isZoomIn = false;
                minX = 1;
                maxX = 5;
              });
            } else {
              setState(() {
                isZoomIn = true;
                minX = 1;
                maxX = 24;
              });
            }
          },
          onHorizontalDragUpdate: (dragUpdDet) {
            setState(() {
              double primDelta = dragUpdDet.primaryDelta ?? 0.0;

              if (primDelta != 0) {
                if (primDelta.isNegative) {
                  minX = minX! + (maxX! * 0.005);
                  maxX = maxX! + (maxX! * 0.005);
                } else {
                  minX = minX! - (maxX! * 0.005);
                  maxX = maxX! - (maxX! * 0.005);
                }
              }
            });
          },
          child: _LineChart(
            isShowingMainData: isShowingMainData,
            maxX: maxX,
            minX: minX,
            maxY: null,
            minY: null,
            isBoy: widget.isBoy,
            listData: widget.listData,
          ),
        ),
      ),
    );
  }
}
