import 'package:eimunisasi/core/extension.dart';
import 'package:eimunisasi/core/widgets/top_app_bar.dart';
import 'package:eimunisasi/features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/utils/themes/padding_constant.dart';
import '../../../../core/widgets/picker.dart';
import '../../../../core/widgets/spacer.dart';
import '../../../../core/widgets/text.dart';
import '../../../../pages/widget/button_custom.dart';
import '../../../../pages/widget/text_form_custom.dart';
import '../../../../utils/dismiss_keyboard.dart';
import '../../data/models/calendar_model.dart';
import '../../logic/bloc/calendar_bloc/calendar_bloc.dart';

class AddEventCalendar extends StatelessWidget {
  const AddEventCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CalendarBloc>();
    return BlocListener<CalendarBloc, CalendarState>(
      listener: (context, state) {
        if (state.statusAddEvent == FormzStatus.submissionSuccess) {
          snackbarCustom("Berhasil Menambah Aktivitas").show(context);
          context.navigateBack();
        }
        if (state.statusAddEvent == FormzStatus.submissionFailure) {
          snackbarCustom("Gagal Menambah Aktivitas").show(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.pink[100],
        appBar: AppBarPeltops(
          title: 'Tambah Aktivitas',
        ),
        body: Card(
          margin: EdgeInsets.all(AppPadding.paddingM),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: AppPadding.paddingM),
            children: [
              VerticalSpacer(),
              BlocBuilder<CalendarBloc, CalendarState>(
                buildWhen: (previous, current) {
                  return previous.dateTimeForm != current.dateTimeForm;
                },
                builder: (context, state) {
                  return TextFormCustom(
                    icon: Icon(Icons.date_range),
                    onTap: () async {
                      final kFirstDay = DateTime(DateTime.now().year - 1);
                      final kLastDay = DateTime(DateTime.now().year + 1);
                      final date = await Picker.pickDate(
                        context,
                        minTime: kFirstDay,
                        maxTime: kLastDay,
                        currentTime: state.dateTimeForm,
                      );
                      if (date != null) {
                        bloc.add(SetDateTimeForm(value: date));
                      }
                    },
                    label: 'Tanggal',
                    readOnly: true,
                    hintText: state.dateTimeForm == null
                        ? 'Pilih tanggal'
                        : state.dateTimeForm.formattedDate(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal tidak boleh kosong';
                      }
                      return null;
                    },
                  );
                },
              ),
              VerticalSpacer(),
              TextFormCustom(
                label: 'Aktivitas',
                hintText: 'Masukkan aktivitas',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Aktivitas tidak boleh kosong';
                  }
                  return null;
                },
                onChanged: (value) {
                  bloc.add(SetActivityForm(value: value));
                },
              ),
              VerticalSpacer(),
              BlocBuilder<CalendarBloc, CalendarState>(
                buildWhen: (previous, current) {
                  return previous.statusAddEvent != current.statusAddEvent ||
                      previous.dateTimeForm != current.dateTimeForm ||
                      previous.activityForm != current.activityForm;
                },
                builder: (context, state) {
                  return ButtonCustom(
                      loading: state.statusAddEvent ==
                          FormzStatus.submissionInProgress,
                      child: ButtonText(text: AppConstant.SAVE),
                      onPressed: () => onSaved(context, state));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValid(BuildContext context, CalendarState state) {
    if (state.activityForm.isEmpty || state.dateTimeForm == null) {
      snackbarCustom("Pastikan semua data terisi").show(context);
      return false;
    }
    return true;
  }

  void onSaved(BuildContext context, CalendarState state) {
    final auth = context.read<AuthenticationBloc>().state as Authenticated;
    final user = auth.user;
    dismissKeyboard(context);
    if (!isValid(context, state)) return;
    context.read<CalendarBloc>().add(
          AddEvent(
            event: CalendarModel(
              uid: user.uid ?? '',
              date: state.dateTimeForm?.add(Duration(hours: 6)),
              activity: state.activityForm,
            ),
          ),
        );
  }
}
