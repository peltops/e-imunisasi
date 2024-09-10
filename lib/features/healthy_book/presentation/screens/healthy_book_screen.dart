import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/routers/route_paths/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';


class HealthyBookScreen extends StatelessWidget {
  void _navigateToPatientMedicalHistoryScreen(BuildContext context) {
    context.push(RoutePaths.chooseChildMedicalRecord);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink[300],
        elevation: 0.0,
        title: Text(
          AppConstant.HEALTH_BOOK_LABEL,
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
                      'assets/images/undraw_Books_l33t.svg',
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: ListTile(
                      onTap: () {
                        _navigateToPatientMedicalHistoryScreen(context);
                      },
                      leading: Icon(
                        Icons.history,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      title: Text('Buku Sehat'),
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
