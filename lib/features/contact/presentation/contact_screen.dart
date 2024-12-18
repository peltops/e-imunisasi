import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/routers/route_paths/contact_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink[300],
        elevation: 0.0,
        title: Text(
          AppConstant.CONTACT,
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
                  SizedBox(
                    height: 150,
                    child: SvgPicture.asset(
                      'assets/images/undraw_doctors_hwty.svg',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {
                        context.push(
                          ContactRoutePaths.healthWorkers.fullPath,
                          extra: {'name': 'Tenaga Kesehatan'},
                        );
                      },
                      leading: Icon(
                        Icons.medical_services_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      title: Text('Tenaga Kesehatan'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {
                        context.push(
                          ContactRoutePaths.clinics.fullPath,
                          extra: {'name': 'Klinik'},
                        );
                      },
                      leading: Icon(
                        Icons.local_hospital_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      title: Text('Klinik'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
