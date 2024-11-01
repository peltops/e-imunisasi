import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/routers/route_paths/vaccination_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class VaccinationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink[300],
        elevation: 0.0,
        title: Text(
          AppConstant.VACCINATION,
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: SvgPicture.asset(
                      'assets/images/undraw_medical_care_movn.svg',
                      semanticsLabel: 'A red up arrow',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {
                        context.push(
                          VaccinationRoutePaths.chooseChildVaccination.fullPath,
                        );
                      },
                      leading: Icon(
                        Icons.medical_services_outlined,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      title: Text('Vaksinasi'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {
                        context.push(
                          VaccinationRoutePaths.appointmentVaccination.fullPath,
                        );
                      },
                      leading: Icon(
                        Icons.list_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      title: Text('Daftar Janji'),
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
