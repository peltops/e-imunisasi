import 'package:e_imunisasi/models/user.dart';
import 'package:e_imunisasi/services/database.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class CardGrafikTumbuh extends StatefulWidget {
  @override
  _CardGrafikTumbuhState createState() => _CardGrafikTumbuhState();
}

class _CardGrafikTumbuhState extends State<CardGrafikTumbuh> {
  List<FlSpot> _groupDataBB(List<DataTumbuh> allEvents) {
    List<FlSpot> data = [];
    allEvents.asMap().forEach((index, value) {
      // print(value.beratBadan + index.toString());
      FlSpot chart = FlSpot(index.toDouble(), double.parse(value.beratBadan));
      data.add(chart);
    });
    return data;
  }

  List<FlSpot> _groupDataTB(List<DataTumbuh> allEvents) {
    List<FlSpot> data = [];
    allEvents.asMap().forEach((index, value) {
      // print(value.beratBadan + index.toString());
      FlSpot chart = FlSpot(index.toDouble(), double.parse(value.tinggiBadan));
      data.add(chart);
    });
    return data;
  }

  List<FlSpot> _groupDataLB(List<DataTumbuh> allEvents) {
    List<FlSpot> data = [];
    allEvents.asMap().forEach((index, value) {
      FlSpot chart = FlSpot(index.toDouble(), double.parse(value.lingkarBadan));
      data.add(chart);
    });
    return data;
  }

  listSemuaData(List<DataTumbuh> allEvents, bool type) {
    var data = [];
    allEvents.asMap().forEach((index, value) {
      double bb = double.parse(value.beratBadan);
      double tb = double.parse(value.tinggiBadan);
      double lb = double.parse(value.lingkarBadan);
      data.add(bb);
      data.add(tb);
      data.add(lb);
    });
    final double largestValue =
        data.reduce((current, next) => current > next ? current : next);
    if (type) {
      return largestValue.toInt();
    } else
      return largestValue;
  }

  @override
  void initState() {
    super.initState();
  }

  var userType;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<List<DataTumbuh>>(
        stream:
            DatabaseService(uid: user.uid).dataPerkembangan(false, 'idPeserta'),
        builder:
            (BuildContext context, AsyncSnapshot<List<DataTumbuh>> snapshot) {
          if (snapshot.hasData) {
            List<DataTumbuh> listData = snapshot.data;
            return Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: AspectRatio(
                aspectRatio: 1.1,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  shadowColor: Colors.deepOrange[100],
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Grafik Perkembangan Anak',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: LineChart(
                              LineChartData(
                                lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                    tooltipBgColor:
                                        Colors.blueGrey.withOpacity(0.8),
                                  ),
                                  touchCallback:
                                      (LineTouchResponse touchResponse) {},
                                  handleBuiltInTouches: true,
                                ),
                                gridData: FlGridData(
                                  show: false,
                                ),
                                titlesData: FlTitlesData(
                                  bottomTitles: SideTitles(
                                    margin: 35,
                                    rotateAngle: -45.0,
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                      color: Color(0xff72719b),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    getTitles: (value) {
                                      var asal = [];
                                      var index = 0;
                                      listData.asMap().forEach((key, val) {
                                        asal.add(val.takeDate
                                            .toString()
                                            .split(' ')[0]);
                                      });
                                      for (var x in asal) {
                                        if (value.toInt() == index) {
                                          return '$x';
                                        }
                                        index = index + 1;
                                      }
                                      return '';
                                    },
                                  ),
                                  rightTitles:
                                      SideTitles(showTitles: false, margin: 35),
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                      color: Color(0xff75729e),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    getTitles: (value) {
                                      if (value.toInt() == 0) {
                                        return '0 cm';
                                      } else if (value.toInt() ==
                                          listSemuaData(listData, true)) {
                                        return listSemuaData(listData, true)
                                                .toString() +
                                            ' cm';
                                      }
                                      return '';
                                    },
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: const Border(
                                    bottom: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                    left: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    right: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    top: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                                minX: 0,
                                maxX: listData.length.toDouble() - 1,
                                maxY: listSemuaData(listData, false),
                                minY: 0,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: _groupDataBB(listData),
                                    isCurved: true,
                                    colors: [
                                      const Color(0xff4af699),
                                    ],
                                    barWidth: 3,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: false,
                                    ),
                                    belowBarData: BarAreaData(
                                      show: false,
                                    ),
                                  ),
                                  LineChartBarData(
                                    spots: _groupDataTB(listData),
                                    isCurved: true,
                                    colors: [
                                      const Color(0xffaa4cfc),
                                    ],
                                    barWidth: 3,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: false,
                                    ),
                                    belowBarData:
                                        BarAreaData(show: false, colors: [
                                      const Color(0x00aa4cfc),
                                    ]),
                                  ),
                                  LineChartBarData(
                                    spots: _groupDataLB(listData),
                                    isCurved: true,
                                    colors: const [
                                      Color(0xff27b6fc),
                                    ],
                                    barWidth: 3,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: false,
                                    ),
                                    belowBarData: BarAreaData(
                                      show: false,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
