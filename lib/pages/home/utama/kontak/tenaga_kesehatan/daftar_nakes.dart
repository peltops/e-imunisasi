import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/core/widgets/button_custom.dart';
import 'package:eimunisasi/routers/route_paths/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DaftarNakes extends StatefulWidget {
  @override
  _DaftarNakesState createState() => _DaftarNakesState();
}

class _DaftarNakesState extends State<DaftarNakes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink[300],
          elevation: 0.0,
          title: Text(
            AppConstant.CHOICE_HEALTH_OFFICER,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: SizedBox.expand(
          child: Container(
              color: Colors.pink[100],
              child: Card(
                margin: EdgeInsets.all(20),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Flexible(
                        child: GridView.count(
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          crossAxisCount: 2,
                          children: [
                            ButtonCustom(
                                onPressed: () {
                                  context.push(
                                    RoutePaths.healthWorkers,
                                    extra: {
                                      'name': AppConstant.DOCTOR,
                                    },
                                  );
                                },
                                child: Text(
                                  AppConstant.DOCTOR,
                                  style: TextStyle(color: Colors.white),
                                )),
                            ButtonCustom(
                                onPressed: () {
                                  context.push(
                                    RoutePaths.healthWorkers,
                                    extra: {
                                      'name': AppConstant.NURSE,
                                    },
                                  );
                                },
                                child: Text(
                                  AppConstant.NURSE,
                                  style: TextStyle(color: Colors.white),
                                )),
                            ButtonCustom(
                                onPressed: () {
                                  context.push(
                                    RoutePaths.healthWorkers,
                                    extra: {
                                      'name': AppConstant.MIDWIFE,
                                    },
                                  );
                                },
                                child: Text(
                                  AppConstant.MIDWIFE,
                                  style: TextStyle(color: Colors.white),
                                )),
                            ButtonCustom(
                                onPressed: () {
                                  context.push(
                                    RoutePaths.healthWorkers,
                                    extra: {
                                      'name': AppConstant.NUTRITIONIST,
                                    },
                                  );
                                },
                                child: Text(
                                  AppConstant.NUTRITIONIST,
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ));
  }
}
