import 'package:eimunisasi/core/extension.dart';
import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:eimunisasi/features/profile/presentation/screens/child_profile_screen.dart';
import 'package:eimunisasi/services/anak_database.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/widgets/top_app_bar.dart';

class ListChildrenScreen extends StatelessWidget {
  const ListChildrenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBarPeltops(title: AppConstant.APP_BAR_CHILD_PROFILE),
      backgroundColor: Colors.pink[100],
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Card(
          elevation: 0,
          child: StreamBuilder<List<Anak>>(
            stream: AnakService().anakStream,
            builder: (context, AsyncSnapshot<List<Anak>> snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data;

                if (snapshot.data != null) {
                  return ListView.builder(
                    itemCount: data?.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChildProfileScreen(
                                  child: data?[index],
                                  mode: ChildProfileScreenMode.edit,
                                ),
                              ),
                            );
                          },
                          title: Text(
                            data?[index].nama ?? emptyString,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(data?[index].umurAnak ?? emptyString),
                          trailing: Icon(
                            Icons.keyboard_arrow_right_rounded,
                          ),
                        ),
                      );
                    },
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return Center(
                child: Text('Tidak ada data'),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => context.navigateTo(
          ChildProfileScreen(mode: ChildProfileScreenMode.add),
        ),
      ),
    );
  }
}
