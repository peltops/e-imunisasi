import 'package:eimunisasi/core/extension.dart';
import 'package:eimunisasi/core/widgets/error.dart';
import 'package:eimunisasi/features/profile/presentation/screens/child_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/widgets/top_app_bar.dart';
import '../../../../injection.dart';
import '../../data/models/anak.dart';
import '../../logic/blocs/childBloc/child_profile_bloc.dart';

class ListChildrenScreen extends StatelessWidget {
  final Function(Anak?)? onSelected;

  const ListChildrenScreen({
    Key? key,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChildProfileBloc>()..add(OnGetChildrenEvent()),
      child: Scaffold(
        appBar: AppBarPeltops(title: AppConstant.APP_BAR_CHILD_PROFILE),
        backgroundColor: Colors.pink[100],
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Card(
            elevation: 0,
            child: BlocBuilder<ChildProfileBloc, ChildProfileState>(
              builder: (context, state) {
                if (state.statusGetChildren == FormzStatus.submissionFailure) {
                  return ErrorContainer(
                    onRefresh: () {
                      context
                          .read<ChildProfileBloc>()
                          .add(OnGetChildrenEvent());
                    },
                  );
                } else if (state.statusGetChildren ==
                    FormzStatus.submissionInProgress) {
                  return Center(child: CircularProgressIndicator());
                }
                final data = state.children;
                return ListView.builder(
                  itemCount: data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          if (onSelected != null) {
                            onSelected!(data?[index]);
                            return;
                          }
                          context.navigateTo(
                            BlocProvider.value(
                              value: context.read<ChildProfileBloc>()
                                ..add(
                                  OnInitialEvent(child: data?[index]),
                                ),
                              child: ChildProfileScreen(
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
              },
            ),
          ),
        ),
        floatingActionButton: BlocBuilder<ChildProfileBloc, ChildProfileState>(
          builder: (context, state) {
            return FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                context.navigateTo(
                  BlocProvider.value(
                    value: context.read<ChildProfileBloc>()
                      ..add(
                        OnInitialEvent(child: Anak.empty()),
                      ),
                    child: ChildProfileScreen(
                      mode: ChildProfileScreenMode.add,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
