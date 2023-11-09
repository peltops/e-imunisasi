import 'package:eimunisasi/features/profile/presentation/screens/profile_screen.dart';
import 'package:eimunisasi/pages/home/bantuan/bantuan_page.dart';
import 'package:eimunisasi/pages/home/utama/main.dart';
import 'package:eimunisasi/pages/home/pesan/pesan_page.dart';
import 'package:eimunisasi/services/notifications.dart';
import 'package:eimunisasi/utils/datetime_extension.dart';
import 'package:eimunisasi/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:eimunisasi/models/hive_calendar_activity.dart';
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<NotificationService>(context, listen: false).initialize();
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    MainPage(),
    ProfilePage(),
    PesanPage(),
    BantuanPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ValueListenableBuilder<Box<CalendarsHive>>(
          valueListenable:
              Hive.box<CalendarsHive>('calendar_activity').listenable(),
          builder: (context, box, _) {
            List<CalendarsHive> calendarsActivity =
                box.values.toList().cast<CalendarsHive>();
            return Consumer<NotificationService>(builder: (context, model, _) {
              final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
              calendarsActivity.asMap().forEach((i, val) {
                if (val.date.orNow.isAfter(now)) {
                  model.sheduledNotification(
                    i,
                    'Pengingat jadwal',
                    'Aktivitas: ' + val.activity.orEmpty,
                    val.date.orNow,
                  );
                }
              });
              return _widgetOptions[_selectedIndex];
            });
          }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            // ignore: deprecated_member_use
            label: 'Utama',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email_outlined),
            activeIcon: Icon(Icons.email_rounded),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            activeIcon: Icon(Icons.list_alt_rounded),
            label: 'Bantuan',
          )
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.pink[300],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}
