import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eimunisasi/services/anak_database.dart';

class ListAnak extends StatelessWidget {
  const ListAnak({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        elevation: 0,
        title: Text(
          'Profil',
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
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Card(
                      elevation: 0,
                      child:
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              stream: AnakService().documentStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var data = snapshot.data;
                                  return ListView.builder(
                                    itemBuilder: (context, index) {
                                      index = index + 1;
                                      return Card(
                                          child: ListTile(
                                        onTap: () {},
                                        title: Text(
                                          data[index.toString()]['nama'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        trailing: Icon(
                                            Icons.keyboard_arrow_right_rounded),
                                      ));
                                    },
                                    itemCount: 2,
                                  );
                                }
                                return LinearProgressIndicator();
                              })),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
