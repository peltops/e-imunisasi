import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/routers/route_paths/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class BantuanPage extends StatefulWidget {
  @override
  _BantuanPageState createState() => _BantuanPageState();
}

class _BantuanPageState extends State<BantuanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink[300],
          elevation: 0.0,
          title: Text(
            AppConstant.SUPPORT_LABEL,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: SizedBox.expand(
          child: Container(
              color: Colors.pink[100],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 150,
                            child: SvgPicture.asset(
                                'assets/images/undraw_searching_p5ux.svg'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Card(
                              child: ListTile(
                            onTap: () {
                              context.push(RoutePaths.hospitals);
                            },
                            leading: Icon(
                              Icons.local_hospital_outlined,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            ),
                            title: Text('Rumah sakit'),
                          )),
                          Card(
                              child: ListTile(
                            onTap: () {
                              context.push(RoutePaths.medicalInformation);
                            },
                            leading: Icon(
                              Icons.info_outline,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            ),
                            title: Text('Informasi Kesehatan'),
                          )),
                          Card(
                              child: ListTile(
                            onTap: () {
                              context.push(RoutePaths.appManual);
                            },
                            leading: Icon(
                              Icons.video_settings_sharp,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            ),
                            title: Text('E-imunisasi Manual'),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ));
  }
}
