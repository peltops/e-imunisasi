import 'package:eimunisasi/core/extension.dart';
import 'package:eimunisasi/core/widgets/top_app_bar.dart';
import 'package:eimunisasi/core/widgets/snackbar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/utils/themes/padding_constant.dart';
import '../../../../core/widgets/picker.dart';
import '../../../../core/widgets/spacer.dart';
import '../../../../core/widgets/text.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../../../core/widgets/text_form_custom.dart';
import '../../../../core/utils/dismiss_keyboard.dart';
import '../../data/models/calendar_model.dart';
import '../../logic/bloc/calendar_bloc/calendar_bloc.dart';

class UpdateEventCalendarScreen extends StatelessWidget {
  final CalendarModel event;
  const UpdateEventCalendarScreen({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<CalendarBloc>()
        ..add(SetDateTimeForm(value: event.date))
        ..add(SetActivityForm(value: event.activity)),
      child: UpdateEventCalendar(event: event),
    );
  }
}

class UpdateEventCalendar extends StatelessWidget {
  final CalendarModel event;

  const UpdateEventCalendar({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CalendarBloc>();
    return BlocListener<CalendarBloc, CalendarState>(
      listener: (context, state) {
        if (state.statusUpdateEvent == FormzSubmissionStatus.success) {
          snackbarCustom("Berhasil Mengubah Aktivitas").show(context);
          context.pop();
        }
        if (state.statusUpdateEvent == FormzSubmissionStatus.failure) {
          snackbarCustom("Gagal Mengubah Aktivitas").show(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.pink[100],
        appBar: AppBarPeltops(
          title: 'Ubah Aktivitas',
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
                        ? event.date?.formattedDate()
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
                initialValue: event.activity,
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
                  return previous.statusUpdateEvent !=
                          current.statusUpdateEvent ||
                      previous.dateTimeForm != current.dateTimeForm ||
                      previous.activityForm != current.activityForm;
                },
                builder: (context, state) {
                  return ButtonCustom(
                    loading: state.statusUpdateEvent ==
                        FormzSubmissionStatus.inProgress,
                    child: ButtonText(text: AppConstant.SAVE),
                    onPressed: () => onSaved(context, state, event),
                  );
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

  void onSaved(BuildContext context, CalendarState state, CalendarModel event) {
    dismissKeyboard(context);
    if (!isValid(context, state)) return;
    context.read<CalendarBloc>().add(
          UpdateEvent(
            event: event.copyWith(
              activity: state.activityForm,
              date: state.dateTimeForm,
            ),
          ),
        );
  }
}
