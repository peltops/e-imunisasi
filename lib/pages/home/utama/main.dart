import 'package:eimunisasi/features/healthy_book/presentation/screens/healthy_book_screen.dart';
import 'package:eimunisasi/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:eimunisasi/pages/home/utama/vaksinasi/vaksinasi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../features/profile/presentation/screens/list_children_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        elevation: 0,
        title: Text(
          'Utama',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.pink[100],
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              isLandscape
                  ? SizedBox()
                  : Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 4,
                      child: Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            'assets/images/undraw_baby_ja7a.svg',
                          ),
                        ),
                      ),
                    ),
              Expanded(
                child: Card(
                  elevation: 0,
                  child: GridView.count(
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    padding: EdgeInsets.all(20),
                    crossAxisCount: isLandscape ? 4 : 2,
                    children: [
                      TombolMenu(
                        icon: Icons.calendar_today,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CalendarScreen(),
                            ),
                          );
                        },
                        label: 'Kalender',
                      ),
                      TombolMenu(
                        icon: Icons.child_friendly_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListChildrenScreen(),
                            ),
                          );
                        },
                        label: 'Anak',
                      ),
                      TombolMenu(
                        icon: Icons.medical_services_rounded,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VaksinasiPage(),
                            ),
                          );
                        },
                        label: 'Vaksinasi',
                      ),
                      TombolMenu(
                        icon: Icons.my_library_books_rounded,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HealthyBookScreen(),
                            ),
                          );
                        },
                        label: 'Buku Sehat',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TombolMenu extends StatelessWidget {
  final Function? onTap;
  final IconData? icon;
  final String? label;

  TombolMenu({
    Key? key,
    this.icon,
    this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Flexible(
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.pink[400],
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              label!,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
